Return-Path: <linux-kernel-owner+w=401wt.eu-S1755920AbXITNrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920AbXITNrS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 09:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753131AbXITNrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 09:47:07 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54468 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbXITNrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 09:47:04 -0400
Date: Thu, 20 Sep 2007 19:19:59 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: error from checkpatch.pl version 0.10
In-Reply-To: <200709202156.GFC11109.HOFQLOVOFFtSJM@I-love.SAKURA.ne.jp>
Message-ID: <alpine.LFD.0.999.0709201916400.17093@enigma.security.iitk.ac.in>
References: <200709202156.GFC11109.HOFQLOVOFFtSJM@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 20 Sep 2007, Tetsuo Handa wrote:
> 
> I checked my patch using checkpatch.pl version 0.10
> and I got the following error.
> 
>   ERROR: need consistent spacing around '*' (ctx:WxV)
>   #2334: FILE: security/tomoyo/common.c:2306:
>   +static unsigned int tmy_poll(struct file *file, poll_table *wait)
>                                                               ^

Looks like a checkpatch.pl bug to me -- that was nothing to warn about.


> What action should I take?
> Ignore this error because "poll_table" is used everywhere?
> Replace "poll_table" with "struct poll_table_struct" according to
> definition of "poll_table"?

Yeah, this would be better to do anyway (and rename poll_table_struct
to just poll_table).

>   typedef struct poll_table_struct {
>           poll_queue_proc qproc;
>   } poll_table;

So:

	struct poll_table {
		poll_queue_proc qproc;
	};

In general the kernel's codingstyle consensus is to avoid adding typedefs.
