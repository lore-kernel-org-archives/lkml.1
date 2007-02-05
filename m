Return-Path: <linux-kernel-owner+w=401wt.eu-S933405AbXBET02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933405AbXBET02 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 14:26:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933406AbXBET01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 14:26:27 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:4070 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933405AbXBET01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 14:26:27 -0500
X-AuthUser: davidel@xmailserver.org
Date: Mon, 5 Feb 2007 11:26:23 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Zach Brown <zach.brown@oracle.com>
cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
In-Reply-To: <B27B1E97-10E3-4A60-A476-4ED4173481A5@oracle.com>
Message-ID: <Pine.LNX.4.64.0702051121420.14453@alien.or.mcafeemobile.com>
References: <patchbomb.1170193181@tetsuo.zabbo.net>
 <df7bc026d50ec5bbdd8e.1170193183@tetsuo.zabbo.net> <20070201083611.GC18233@elte.hu>
 <Pine.LNX.4.64.0702011154110.3632@woody.linux-foundation.org>
 <20070202104900.GA13941@elte.hu> <Pine.LNX.4.64.0702020738500.15057@woody.linux-foundation.org>
 <20070202222110.GA1212@elte.hu> <Pine.LNX.4.64.0702021445410.15057@woody.linux-foundation.org>
 <20070202235531.GA18904@elte.hu> <Pine.LNX.4.64.0702021636410.15057@woody.linux-foundation.org>
 <20070203082308.GA6748@elte.hu> <B27B1E97-10E3-4A60-A476-4ED4173481A5@oracle.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Feb 2007, Zach Brown wrote:

> > The normal and most optimal workflow should be a user-space ring-buffer
> > of these constant-size struct async_syscall entries:
> > 
> >  struct async_syscall ringbuffer[1024];
> > 
> >  LIST_HEAD(submitted);
> >  LIST_HEAD(pending);
> >  LIST_HEAD(completed);
> 
> I strongly disagree here, and I'm hoping you're not as keen on this now --
> your reply to Matt gives me hope.
> 
> As mentioned, that they complete out-of-order leads, at least, to having
> separate submission and completion rings.  I'm not sure a submission ring
> makes any sense given the goal of processing the calls in submission and only
> creating threads if it blocks.  A simple copy of an array of these input
> structs sounds fine to me.

The "result" of one async operation is basically a cookie and a result 
code. Eight or sixteen bytes at most. IMO, before going wacko designing 
complex shared userspace-kernel result buffers, I think it'd be better 
measuring the worth-value of the thing ;)



- Davide


