Return-Path: <linux-kernel-owner+w=401wt.eu-S1755850AbZGCJHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850AbZGCJHV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 05:07:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752829AbZGCJHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 05:07:10 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47365 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751779AbZGCJHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 05:07:08 -0400
Date: Fri, 3 Jul 2009 10:08:34 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: lennart@poettering.net, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] vt: add an event interface
Message-ID: <20090703100834.6cb241b6@lxorguk.ukuu.org.uk>
In-Reply-To: <20090703064518.GA30674@elte.hu>
References: <20090702113529.4896.2321.stgit@t61.ukuu.org.uk>
	<20090703064518.GA30674@elte.hu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Just a side-note, please run new patches through 
> scripts/checkpatch.pl:
> 
>     total: 4 errors, 2 warnings, 0 checks, 294 lines checked

Given the code doesn't currently *work* yet but is a first draft its
hardly important and there are better uses of time than playing
checkpatch policeman.

>  - the copy_from_user() in vt_event_wait_ioctl() could be shortened 
>    if we didnt pass in an unsigned long (which is pointless anyway).
>    The cast to void __user * should be done in the ioctl 
>    demultiplexer vt_ioctl(), and the ioctl ugliness should not 
>    invade cleaner child functions such as vt_event_wait_ioctl().
> 
>  - same for vt_event_wait_ioctl() - it passes in a type damaged by 
>    ioctl's limitations. Such type limitations and ioctl demuxing 
>    artifacts should be kept local to vt_ioctl().

That had already occurred to me. The events should also become a mask so
you can wait for several at once. What I wanted to know was whether such
an interface actually meets Lennart's requirements.

Alan
