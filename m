Return-Path: <linux-kernel-owner+w=401wt.eu-S1030553AbXBFXXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030553AbXBFXXw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 18:23:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030569AbXBFXXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 18:23:51 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:1200 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030553AbXBFXXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 18:23:50 -0500
X-AuthUser: davidel@xmailserver.org
Date: Tue, 6 Feb 2007 15:23:47 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Kent Overstreet <kent.overstreet@gmail.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Zach Brown <zach.brown@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
In-Reply-To: <6f703f960702061445q23dd9d48q7afec75d2400ef62@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0702061518220.19136@alien.or.mcafeemobile.com>
References: <patchbomb.1170193181@tetsuo.zabbo.net>  <20070203082308.GA6748@elte.hu>
  <B27B1E97-10E3-4A60-A476-4ED4173481A5@oracle.com> 
 <Pine.LNX.4.64.0702051121420.14453@alien.or.mcafeemobile.com> 
 <8CF4BE18-8EEF-4ACA-A4B4-B627ED3B4831@oracle.com> 
 <Pine.LNX.4.64.0702051147100.14453@alien.or.mcafeemobile.com> 
 <Pine.LNX.4.64.0702051223390.8424@woody.linux-foundation.org> 
 <Pine.LNX.4.64.0702051259030.14453@alien.or.mcafeemobile.com> 
 <6f703f960702051331v3ceab725h68aea4cd77617f84@mail.gmail.com> 
 <Pine.LNX.4.64.0702061238300.8424@woody.linux-foundation.org>
 <6f703f960702061445q23dd9d48q7afec75d2400ef62@mail.gmail.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Feb 2007, Kent Overstreet wrote:

> The trouble with differentiating between calls that block and calls
> that don't is you completely loose the ability to batch syscalls
> together; this is potentially a major win of an asynchronous
> interface.

It doesn't necessarly have to, once you extend the single return code to a 
vector:

struct async_submit {
	void *cookie;
	int sysc_nbr;
	int nargs;
	long args[ASYNC_MAX_ARGS];
	int async_result;
};

int async_submit(struct async_submit *a, int n);

And async_submit() can mark each one ->async_result with -EASYNC (syscall 
has been batched), or another code (syscall completed w/out schedule).
IMO, once you get a -EASYNC for a syscall, you *have* to retire the result.



- Davide


