Return-Path: <linux-kernel-owner+w=401wt.eu-S1757550AbYCMUgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757550AbYCMUgl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 16:36:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757448AbYCMUg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 16:36:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40651 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757439AbYCMUgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 16:36:25 -0400
Date: Thu, 13 Mar 2008 13:34:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Geert.Uytterhoeven@sonycom.com, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>
Subject: Re: [PATCH 1/4] introduce explicit signed/unsigned 64bit divide
Message-Id: <20080313133459.8d7d870d.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0803131546420.1791@scrub.home>
References: <20080313002235.351414762@linux-m68k.org>
	<20080313004902.808083566@linux-m68k.org>
	<Pine.LNX.4.64.0803131110520.9727@vixen.sonytel.be>
	<Pine.LNX.4.64.0803131546420.1791@scrub.home>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008 15:59:27 +0100 (CET)
Roman Zippel <zippel@linux-m68k.org> wrote:

> On Thu, 13 Mar 2008, Geert Uytterhoeven wrote:
> 
> > > +static inline u64 div_u64_rem(u64 dividend, u32 divisor, u32 *remainder)
> >                  ^       ^       ^             ^            ^
> > 		 s64 div_s64_rem s64           s32          s32
> 
> Thanks for noticing.
> I'm quite sure I fixed this before, as I compiled this also for 
> 64bit, so I'm not sure how it got back. Anyway, new patch below.

I think what happened was that [patch 3/4] fixed this up.  Of course,
that patch doesn't apply on this updated [1/4].  I _could_ just take the
old [1/4] (I think), but I don't know if that wouild be bisection-friendly.

Anyway, please redo&resend?  Thanks.



Please have a think about that code in arch/x86/kvm/i8254.c too.  It is
painful to see remote subsystems (re)implementing generic infrastructure.
Can KVM use existing code?  Should we hoist what KVM has done there into
generic code?  Did it have to use a(nother bleeding) macro?
