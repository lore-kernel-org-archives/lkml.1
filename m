Return-Path: <linux-kernel-owner+w=401wt.eu-S1758360AbYGOQL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758360AbYGOQL3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 12:11:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753647AbYGOQLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 12:11:22 -0400
Received: from smtp-out.google.com ([216.239.33.17]:39750 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217AbYGOQLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 12:11:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=ROcPrnzP5esjS4OnhF9k5IyHSXmaUZrGThCwGZ/JKWurM/OUL1sgYOhoOTwQte5T9
	4/Jj4a7viGgUeeegG4k/A==
Message-ID: <6599ad830807150911jede167ewbcdfdff905b5059e@mail.gmail.com>
Date: Tue, 15 Jul 2008 09:11:10 -0700
From: "Paul Menage" <menage@google.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: [PATCH] cpuset: Make rebuild_sched_domains() usable from any context
Cc: "Max Krasnyansky" <maxk@qualcomm.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl
In-Reply-To: <20080715110726.5837c783.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1216122293-4888-1-git-send-email-maxk@qualcomm.com>
	 <20080715110726.5837c783.pj@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 9:07 AM, Paul Jackson <pj@sgi.com> wrote:
> If this rebuild thread was the -only- way that sched domains were
> allowed to be rebuilt, and if this rebuild was done -asynchronously-
> sometime shortly after requested, without any error or status feedback,
> then it would seem to simplify the locking issues.

I sent a patch that was similar a couple of weeks ago, that used a
workqueue to do the rebuild. It didn't quite work then since it wasn't
safe to call get_online_cpus() from a multi-threaded workqueue then,
but I believe there's been a patch since then that makes this safe.
And if not, we could always have a single-threaded workqueue that
wasn't bound to any particular CPU.

Paul
