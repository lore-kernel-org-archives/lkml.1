Return-Path: <linux-kernel-owner+w=401wt.eu-S934264AbXHHC1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934264AbXHHC1O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 22:27:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757805AbXHHC06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 22:26:58 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:18740 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755122AbXHHC05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 22:26:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=KRRIwMG0QfPWFPsA85tI627iqPIwhaKbonovEme6WQRr5U1Hpbz/rLDxvg0PJ8oigGoMc81LZ0B2lOIYkPC0GP75223ROWpGccmqXl2ObqBNQ9jdmB/ApTejFchzymRdXN8HQr7HNig2gpX9NeMi2y1QKbU8eEhBug8tTxb2mTE=
Message-ID: <75b66ecd0708071926s519ebcf5t680c2ed8ab7ead8e@mail.gmail.com>
Date: Tue, 7 Aug 2007 22:26:57 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: allow non root users to set io priority "idle" ?
Cc: dragoran <drago01@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <p73zm14lxyy.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46B6EDCB.6030806@gmail.com> <p73zm14lxyy.fsf@bingen.suse.de>
X-Google-Sender-Auth: cd91d551a833495d
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06 Aug 2007 13:11:01 +0200, Andi Kleen <andi@firstfloor.org> wrote:
> For IO I suppose the same could happen too. e.g. low priority
> task wants to write out a page and keeps it locked until the IO
> is finished. High priority task wants to access the page and has
> to wait until it is unlocked. Middle task generates an endless
> stream of IO that makes the idle priority writeout never finish.

I don't think it's a problem for high priority (RT) tasks - it's well
known in the real time Linux community that you never, ever do IO from
a thread that has to satisfy RT constraints.  A correct RT linux app
does its IO from a SCHED_NORMAL thread, with *plenty* of buffering,
and feeds the RT constrained SCHED_FIFO threads using a lock free
ringbuffer.

SCHED_IDLE starving SCHED_NORMAL is an issue of course.  But
SCHED_IDLE seems a lot more useful for read than write which I would
expect to take fewer locks.  For example I'd expect Beagle to want to
read at SCHED_IDLE but write out its indices at SCHED_NORMAL.

Would it make any sense to allow anyone to set SCHED_IDLE for reads
but require root to change IO priority for writes?

Lee
