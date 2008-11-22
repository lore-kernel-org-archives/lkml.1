Return-Path: <linux-kernel-owner+w=401wt.eu-S1758215AbYKVNat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758215AbYKVNat (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 08:30:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757848AbYKVNal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 08:30:41 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:62781 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757802AbYKVNak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 08:30:40 -0500
Date: Sat, 22 Nov 2008 08:30:37 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Teoh <htmldeveloper@gmail.com>
cc: Steven Rostedt <srostedt@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Some FTRACE related question
In-Reply-To: <804dabb00811220047q6e0f24eap23e9a7c4c7bd71b6@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0811220827310.26464@gandalf.stny.rr.com>
References: <804dabb00811220047q6e0f24eap23e9a7c4c7bd71b6@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 22 Nov 2008, Peter Teoh wrote:

> Q1:   how to use ftrace to ftrace itself?   (i would like to see some
> ftrace-triggered flow)   In view of the following patch:

ftrace can be very dangerous, (the function tracer part of ftrace).
It would be very difficult for ftrace to ftrace itself.
When I need to debug ftrace, I use my old tracer logdev:

 http://rostedt.homelinux.com/logdev

> 
> http://linux.derkeiler.com/Mailing-Lists/Kernel/2008-11/msg03745.html
> 
> Is it to prevent this from being possible?
> 
> Q2:   how to ftrace s2ram and resume?   I attempted to do it, but the
> trace output is always filled with "resume" related functions when it
> started up, which is only logical.

s2ram does a lot of nasty tricks. On startup, it calls functions before 
smp_prossor_id() is defined. We use that to disable ftrace recursion (see 
Q1 ;-).  But if you use that in s2ram resume, it will blow up.

Now, you can try to hack ftrace for your own tracing to handle the above 
problems.

-- Steve

