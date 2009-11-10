Return-Path: <linux-kernel-owner+w=401wt.eu-S1753400AbZKJLGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400AbZKJLGa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 06:06:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbZKJLG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 06:06:29 -0500
Received: from mail-iw0-f178.google.com ([209.85.223.178]:43722 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbZKJLG1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 06:06:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=sWQqIb2lNGAYda7VuBIhr3qsMaeFEKmW5wrdSJ8km4q6AOcwYL0+7SREQiLaOdHhYY
         eEzo2YPd9BtqE5if3heLcexIWnx3iBLA4PDwNEo216PT0FOtI2Bz3uxZkoPjsQg8KUjp
         Me/mWp8cgeUYNXxI8am6Yt2jytfT7gXlZXHwY=
MIME-Version: 1.0
In-Reply-To: <3e8340490911091600v3a0e9b67r279349ac852d604a@mail.gmail.com>
References: <20091103094703.GB11134@hack.redhat.com>
	 <20091103230548.0B45.A69D9226@jp.fujitsu.com>
	 <20091104002544.0B4A.A69D9226@jp.fujitsu.com>
	 <20091109144717.0cd17421.akpm@linux-foundation.org>
	 <3e8340490911091600v3a0e9b67r279349ac852d604a@mail.gmail.com>
Date: Tue, 10 Nov 2009 20:06:31 +0900
X-Google-Sender-Auth: 483fa48c6c7a5b0d
Message-ID: <2f11576a0911100306k7e2a64b9r35e13454be858140@mail.gmail.com>
Subject: Re: [PATCH v5] Added PR_SET_PROCTITLE_AREA option for prctl()
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Bryan Donlan <bdonlan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Americo Wang <xiyou.wangcong@gmail.com>, Timo Sirainen <tss@iki.fi>,
       Ulrich Drepper <drepper@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/11/10 Bryan Donlan <bdonlan@gmail.com>:
> On Mon, Nov 9, 2009 at 5:47 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
>
>> What happens if userspace unmaps the memory after telling the kernel to
>> use it?
>>
>> Will processes which try to read the command line get an error reading
>> /proc?  If so, do all the commandline-reading programs in the world
>> handle this in an appropriate fashion?
>
> This case can already occur in the current code; the userspace process
> would have to munmap() the top of its stack, but it certainly can do
> so if it tries. In any case, access_process_vm() then returns 0
> because of the fault, and thus /proc/pid/cmdline is seen to have zero
> length. Since a zero-length /proc/pid/cmdline occurs with kernel
> threads as well, we know this isn't a problem.

Plus, ps can read under exiting process. In this case, task->mm is NULL and
proc_pid_cmdline return 0.

procps tools are already NUL safe since long time ago.
