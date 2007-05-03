Return-Path: <linux-kernel-owner+w=401wt.eu-S1161890AbXECNqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161890AbXECNqY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 09:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161893AbXECNqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 09:46:24 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:40827 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161890AbXECNqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 09:46:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nGkA4+zD/NlCNTAM3+34oCzUTRZutB+fRWviAQux4OG1m2hXuikprbvKEyQMW9C8y2Ad/iXIIidNDtJFO2mNaxxlhDIvVrS2IiJdERaPjpZNmV5J7BMxjfaSTGPKMbE8FRJvke0WSUn+d1n9J/srMNYC1bJXoMF+O0q5Qmq5GoU=
Message-ID: <a36005b50705030646v5b729838pe8dc7b91dc9bee2b@mail.gmail.com>
Date: Thu, 3 May 2007 06:46:22 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Davide Libenzi" <davidel@xmailserver.org>
Subject: Re: [patch 14/22] pollfs: pollable futex
Cc: "Davi Arnaut" <davi@haxent.com.br>, "Eric Dumazet" <dada1@cosmosbay.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0705021059430.7176@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070502052235.914764000@haxent.com.br>
	 <20070502095503.a06f5472.dada1@cosmosbay.com>
	 <a36005b50705020108o6fb7495ak2383ae64e49c48a0@mail.gmail.com>
	 <20070502104936.674a4b54.dada1@cosmosbay.com>
	 <a36005b50705020939j491ced9ekf3f4203fc8b865a3@mail.gmail.com>
	 <4638C37D.7050503@haxent.com.br>
	 <a36005b50705021010l5c7badc6ub61228f14fdbb28a@mail.gmail.com>
	 <Pine.LNX.4.64.0705021028520.7176@alien.or.mcafeemobile.com>
	 <a36005b50705021053r2fcaf225l956921570dff20e8@mail.gmail.com>
	 <Pine.LNX.4.64.0705021059430.7176@alien.or.mcafeemobile.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/2/07, Davide Libenzi <davidel@xmailserver.org> wrote:
> 99% of the fds you'll find inside an event loop you care to scale about,
> are *already* fd based.

You are missing the point.  To get acceptable behavior of the wakeup
it is necessary with this approach to open one descriptor _per thread_
for a futex.  Otherwise all threads get woken upon FUTEX_WAKE.

This also means you need individual epoll sets for each thread.  You
cannot share them anymore among all the threads in the process.


> On top of that, those fds are very cheap in terms of memory

They might be when they are counted in dozens.  But here we are
talking about the possible need to use thousands of additional file
descriptors.  If they are so cheap to allow thousands of descriptors
with ease, why would the rlimit for files default to a small number
(1024 on Fedora right now)?


> And this approach is not bound to a completely new and monolitic interface.

So?  It's stil additional, new code for an approach which will have to
be superceded real soon.  That's just pure overhead to me.
