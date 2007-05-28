Return-Path: <linux-kernel-owner+w=401wt.eu-S932598AbXE1Vr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932598AbXE1Vr4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 17:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751498AbXE1Vrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 17:47:49 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:19266 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbXE1Vrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 17:47:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rtu6emG7RZEIJ/3Q97hCdsA1fNNksOmXbbu0Ad/hsFWawCm9UZdubR9uIKSm++iAkxwQzSEhJ7PPtBq11sSZytAyoSpjnhSHiVxGRTieicxXEBxeV93u9txm3AKvD38WEwRjd/f8qQ0GP4/U5PuK+IbvxB015yz8fG4r9y5R/mk=
Message-ID: <9a8748490705281447t24a263a0hd5946825d3f486c7@mail.gmail.com>
Date: Mon, 28 May 2007 23:47:48 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Bill Davidsen" <davidsen@tmr.com>
Subject: Re: What causes iowait other than waiting for i/o?
Cc: "Linux Kernel mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <465B4B75.2040602@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <465B4B75.2040602@tmr.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/05/07, Bill Davidsen <davidsen@tmr.com> wrote:
> I recently noted that my system was spending a lot of time in i/o wait
> when doing some tasks which I thought didn't involve i/o, as noted by
> the lack of disk light activity most of the time. I thought of network,
> certainly the NIC had no activity for this job. So I set up a little
> loop to capture all disk i/o and network activity (including loopback).
> That was no obvious help, and the program doesn't use pipes.
>
> At this point I'm really curious, does someone have a good clue?
>
> Note: I don't think this is a bug or performance issue, unless the
> kernel is doing something and charging time to iowait instead of system
> I don't see anything to fix, but I would like to understand.
>

Nothing /should/ cause time to be attributed to i/o wait other than
waiting for i/o. But the accounting isn't completely accurate. When
the kernel records what the has happen (governed by when the timer
interrupt triggers as far as I remember), many different processes may
have run and done may different things, but only what the last one did
is recorded. So if you are unlucky you may have the system doing all
sorts of activities, but only recording i/o wait if the last process
to run before the kernel looked was doing i/o wait...  The numbers are
not exactely accurate...


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
