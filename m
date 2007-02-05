Return-Path: <linux-kernel-owner+w=401wt.eu-S933343AbXBESwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933343AbXBESwj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 13:52:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933344AbXBESwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 13:52:39 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:4063 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933343AbXBESwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 13:52:38 -0500
X-AuthUser: davidel@xmailserver.org
Date: Mon, 5 Feb 2007 10:52:35 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Zach Brown <zach.brown@oracle.com>
cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
In-Reply-To: <87DE673C-92A0-4401-8DE5-BDC2C08B5F41@oracle.com>
Message-ID: <Pine.LNX.4.64.0702051040160.14453@alien.or.mcafeemobile.com>
References: <patchbomb.1170193181@tetsuo.zabbo.net>
 <df7bc026d50ec5bbdd8e.1170193183@tetsuo.zabbo.net> <20070201083611.GC18233@elte.hu>
 <Pine.LNX.4.64.0702011154110.3632@woody.linux-foundation.org>
 <20070202104900.GA13941@elte.hu> <Pine.LNX.4.64.0702020738500.15057@woody.linux-foundation.org>
 <20070202222110.GA1212@elte.hu> <87DE673C-92A0-4401-8DE5-BDC2C08B5F41@oracle.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Feb 2007, Zach Brown wrote:

> > The 'pool' of kernel threads doesnt even have to be per-task, it can be
> > a natural per-CPU thing
> 
> Yeah, absolutely.

Hmmm, so we issue an async sys_read(), what a get_file(fd) will return for 
a per-CPU kthread executing such syscall? Unless we teach context_switch() 
to do a inherit-trick for "files" (even in that case, it won't work if 
we switch from another context). And, is it all for it?
IMO it's got to be either a per-process thread pool or a fibril approach.
Or we need some sort of enter_context()/leave_context() (adopt mm, files, 
...) to have a per-CPU kthread to be able to execute the syscall from the 
async() caller context. Hmmm?



- Davide


