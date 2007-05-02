Return-Path: <linux-kernel-owner+w=401wt.eu-S1766952AbXEBRtj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766952AbXEBRtj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 13:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766954AbXEBRtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 13:49:39 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:24984 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766952AbXEBRth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 13:49:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YdV/WDcnIcDM/5i01UbzBlWoL+iSmqGmscUaXSGHA+VZYwpdEBXRRSJNunGh72Zu9riri9GSwSIScnK6ltxdrV4CUnDjr2+fjU972uuIFZ/zJ1njydSKMo5AWQou52omIcjjrWiBBC1HCC8IbG90vAHUoaDnoFL5CwdlW94QWSM=
Message-ID: <a36005b50705021049k44881c5er1b9e61d64618ae1e@mail.gmail.com>
Date: Wed, 2 May 2007 10:49:36 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Davi Arnaut" <davi@haxent.com.br>
Subject: Re: [patch 14/22] pollfs: pollable futex
Cc: "Eric Dumazet" <dada1@cosmosbay.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Davide Libenzi" <davidel@xmailserver.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <4638CC6D.6080505@haxent.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070502052235.914764000@haxent.com.br>
	 <20070502053427.123392000@haxent.com.br>
	 <a36005b50705020040l8874d64m1bcf25da5cae885d@mail.gmail.com>
	 <20070502095503.a06f5472.dada1@cosmosbay.com>
	 <a36005b50705020108o6fb7495ak2383ae64e49c48a0@mail.gmail.com>
	 <20070502104936.674a4b54.dada1@cosmosbay.com>
	 <a36005b50705020939j491ced9ekf3f4203fc8b865a3@mail.gmail.com>
	 <4638C37D.7050503@haxent.com.br>
	 <a36005b50705021010l5c7badc6ub61228f14fdbb28a@mail.gmail.com>
	 <4638CC6D.6080505@haxent.com.br>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/2/07, Davi Arnaut <davi@haxent.com.br> wrote:
> NO! Every single waiter of the _file descriptor_ is waked, not of the futex.

And how is this better?  In this world of yours a program must have
one file descriptor for each single futex which is used like this *per
thread*.  There can be hundreds, thousands of threads.  And there can
be large numbers of futexes, too.

This is not going to fly.  You reach the file descriptor limit just
with this.  And this in many processes on the system.


> davi@karmic:~/git/linux-2.6$ find patches/ -name *.patch |grep -v
> syscall | wc -l
> 10
>
> davi@karmic:~/git/linux-2.6$ find patches/ -name *.patch |grep -v
> syscall |grep futex
> patches/pollfs-futex-async-wait.patch
> patches/pollfs-futex.patch

I don't know what  you want to show here.  You 10 new syscalls?  You
have two patches alone modifying futexes?  And 22 patches in total.
That's not "a lot"?
