Return-Path: <linux-kernel-owner+w=401wt.eu-S932750AbYB2Sdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932750AbYB2Sdu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 13:33:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755346AbYB2Sdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 13:33:42 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:31016 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835AbYB2Sdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 13:33:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=jPFSnaDH6d69ovh2mltARW3b9jp6ENhSTW2BCf+Q2TO9kHQTrtkh95OZA2z0eiposBFexX/J8K2j9C//o5jpOy2IW9kMK2MxVYVDfmK797H2bQLwi7gSykW0fgFYzOb88RA9siVOoo/s6ePnai0GnP3gdXe/b39ihFqUhDX0s1c=
Message-ID: <2c0942db0802291033p6a7f8be1te227c9c1a5ea4c5e@mail.gmail.com>
Date: Fri, 29 Feb 2008 10:33:39 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: Interactivity issue in 2.6.25-rc3
Cc: "Carlos R. Mafra" <crmafra2@gmail.com>,
       "kernel list" <linux-kernel@vger.kernel.org>,
       "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <20080229155741.GF27248@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080228184407.GA7117@localhost.ift.unesp.br>
	 <20080228191824.GA20019@elte.hu>
	 <2c0942db0802281154y3176e847g8b9a4091df5cc8af@mail.gmail.com>
	 <20080228210627.GA4337@localhost.ift.unesp.br>
	 <2c0942db0802281328y276d110cqbcc9cfe92f0c6832@mail.gmail.com>
	 <20080229155741.GF27248@elte.hu>
X-Google-Sender-Auth: ed118f65d7c05973
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 29, 2008 at 7:57 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * Ray Lee <ray-lk@madrabbit.org> wrote:
>
>  > But it's good to keep in mind that the scheduler can't do anything
>  > about slowdowns due to tasks being swapped out or waiting on reads
>  > from the disk. I mention this as shortly after CFS got into mainline,
>  > something changed in the VM that seems to make my system spend a lot
>  > more time in IO wait, causing the system to be much less responsive
>  > than it used to be.
>  >
>  > Unfortunately it seems to be dependent upon the history of what tasks
>  > I've run and their memory usage, so it's been hard to come up with a
>  > reproducible test case (well that and a complete lack of time). All I
>  > can say is that I've seen what you've reported as well, though it had
>  > nothing to do with using any 3d applications, just a browser, editor,
>  > gcc, etc.
>
>  what does latencytop say about those delays, what causes them? It should
>  be able to capture all sorts of latency sources in the system.

Ah, thanks for the reminder. The last I tried it, it didn't show
anything other than scheduler: waiting on cpu, but using a git clone
version captured this almost immediately:

EXT3: Waiting for journal access                  2261.1 msec         15.0 %
Writing a page to disk                            112.4 msec          0.7 %
Scheduler: waiting for cpu                         57.9 msec         17.7 %
default_wake_function __queue_work call_usermodehe  5.9 msec          0.1 %
Waiting for event (poll)                            5.0 msec         37.5 %
Waiting for data on unix socket                     5.0 msec          2.1 %
Userspace lock contention                           4.9 msec         23.5 %
Waiting for TTY data                                4.9 msec          0.3 %
Sending TCP/IP data                                 4.9 msec          0.0 %

I'm running postgresql in the background on this system and it does
regular sync's, so perhaps that's related?

It doesn't look like latencytop saves the trace data anywhere other
than my eyes? I'll hack in a log and see what else it gets.
