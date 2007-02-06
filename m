Return-Path: <linux-kernel-owner+w=401wt.eu-S965135AbXBFAcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965135AbXBFAcn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 19:32:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965165AbXBFAcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 19:32:43 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:4191 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965135AbXBFAcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 19:32:42 -0500
X-AuthUser: davidel@xmailserver.org
Date: Mon, 5 Feb 2007 16:32:39 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Zach Brown <zach.brown@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
In-Reply-To: <Pine.LNX.4.64.0702051259030.14453@alien.or.mcafeemobile.com>
Message-ID: <Pine.LNX.4.64.0702051631260.14453@alien.or.mcafeemobile.com>
References: <patchbomb.1170193181@tetsuo.zabbo.net>
 <df7bc026d50ec5bbdd8e.1170193183@tetsuo.zabbo.net> <20070201083611.GC18233@elte.hu>
 <Pine.LNX.4.64.0702011154110.3632@woody.linux-foundation.org>
 <20070202104900.GA13941@elte.hu> <Pine.LNX.4.64.0702020738500.15057@woody.linux-foundation.org>
 <20070202222110.GA1212@elte.hu> <Pine.LNX.4.64.0702021445410.15057@woody.linux-foundation.org>
 <20070202235531.GA18904@elte.hu> <Pine.LNX.4.64.0702021636410.15057@woody.linux-foundation.org>
 <20070203082308.GA6748@elte.hu> <B27B1E97-10E3-4A60-A476-4ED4173481A5@oracle.com>
 <Pine.LNX.4.64.0702051121420.14453@alien.or.mcafeemobile.com>
 <8CF4BE18-8EEF-4ACA-A4B4-B627ED3B4831@oracle.com>
 <Pine.LNX.4.64.0702051147100.14453@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0702051223390.8424@woody.linux-foundation.org>
 <Pine.LNX.4.64.0702051259030.14453@alien.or.mcafeemobile.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Feb 2007, Davide Libenzi wrote:

> On Mon, 5 Feb 2007, Linus Torvalds wrote:
> 
> > Indeed. One word is *exactly* what a normal system call returns too.
> > 
> > That said, normally we have a user-space library layer to turn that into 
> > the "errno + return value" thing, and in the case of async() calls we 
> > very basically wouldn't have that. So either:
> > 
> >  - we'd need to do it in the kernel (which is actually nasty, since 
> >    different system calls have slightly different semantics - some don't 
> >    return any error value at all, and negative numbers are real numbers)
> > 
> >  - we'd have to teach user space about the "negative errno" mechanism, in 
> >    which case one word really is alwats enough.
> > 
> > Quite frankly, I much prefer the second alternative. The "negative errno" 
> > thing has not only worked really really well inside the kernel, it's so 
> > obviously 100% superior to the standard UNIX "-1 + errno" approach that 
> > it's not even funny. 
> 
> Currently it's in the syscall wrapper. Couldn't we have it in the 
> asys_teardown_stack() stub?

Eeeek, that was something *really* stupid I said :D



- Davide


