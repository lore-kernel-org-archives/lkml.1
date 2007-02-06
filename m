Return-Path: <linux-kernel-owner+w=401wt.eu-S1751753AbXBFUZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751753AbXBFUZN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 15:25:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751938AbXBFUZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 15:25:13 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:1128 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbXBFUZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 15:25:11 -0500
X-AuthUser: davidel@xmailserver.org
Date: Tue, 6 Feb 2007 12:25:00 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Kent Overstreet <kent.overstreet@gmail.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Zach Brown <zach.brown@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
In-Reply-To: <6f703f960702051331v3ceab725h68aea4cd77617f84@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0702061220050.19136@alien.or.mcafeemobile.com>
References: <patchbomb.1170193181@tetsuo.zabbo.net>  <20070202235531.GA18904@elte.hu>
  <Pine.LNX.4.64.0702021636410.15057@woody.linux-foundation.org> 
 <20070203082308.GA6748@elte.hu>  <B27B1E97-10E3-4A60-A476-4ED4173481A5@oracle.com>
  <Pine.LNX.4.64.0702051121420.14453@alien.or.mcafeemobile.com> 
 <8CF4BE18-8EEF-4ACA-A4B4-B627ED3B4831@oracle.com> 
 <Pine.LNX.4.64.0702051147100.14453@alien.or.mcafeemobile.com> 
 <Pine.LNX.4.64.0702051223390.8424@woody.linux-foundation.org> 
 <Pine.LNX.4.64.0702051259030.14453@alien.or.mcafeemobile.com>
 <6f703f960702051331v3ceab725h68aea4cd77617f84@mail.gmail.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Feb 2007, Kent Overstreet wrote:

> > > HOWEVER, they get returned differently. The cookie gets returned
> > > immediately, the system call result gets returned in-memory only after the
> > > async thing has actually completed.
> > >
> > > I would actually argue that it's not the kernel that should generate any
> > > cookie, but that user-space should *pass*in* the cookie it wants to, and
> > > the kernel should consider it a pointer to a 64-bit entity which is the
> > > return code.
> > 
> > Yes. Let's have the userspace to "mark" the async operation. IMO the
> > cookie should be something transparent to the kernel.
> > Like you said though, that'd require compat-code (unless we fix the size).
> 
> You don't need an explicit cookie if you're passing in a pointer to
> the return code, it doesn't really save you anything to do so. Say
> you've got a bunch of user threads (with or without stacks, it doesn't
> matter).
> 
> struct asys_ret {
>     int ret;
>     struct thread *p;
> };
> 
> struct asys_ret r;
> r.p = me;
> 
> async_read(fd, buf, nbytes, &r);

Hmm, are you working for Symbian? Because that's exactly how they track 
pending async operations (address of a status variable - wrapped in a 
class of course, being them) ;)
That's another way of doing it, IMO no better no worse than letting 
explicit cookie selection from userspace. You still have to have the 
compat code though, either ways.



- Davide


