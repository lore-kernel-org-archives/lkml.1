Return-Path: <linux-kernel-owner+w=401wt.eu-S1762619AbXEQAmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762619AbXEQAmn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 20:42:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757847AbXEQAmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 20:42:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47250 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757681AbXEQAmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 20:42:35 -0400
Date: Wed, 16 May 2007 20:42:09 -0400
From: Dave Jones <davej@redhat.com>
To: Christian <haveaniceday@cv-sv.de>
Cc: linux-kernel@vger.kernel.org, ak@suse.de
Subject: Re: 2.6.22-rc1 does not boot on VIA C3_2 cause of X86_CMPXCHG64
Message-ID: <20070517004209.GE16810@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Christian <haveaniceday@cv-sv.de>, linux-kernel@vger.kernel.org,
	ak@suse.de
References: <464B9D2C.7040704@cv-sv.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464B9D2C.7040704@cv-sv.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2007 at 02:09:16AM +0200, Christian wrote:

 > my small VIA C3_2 box does not boot with 2.6.22-rc1.
 > It even does not uncompress the kernel.
 > 
 > The configuration as M386 M486 works. But M586 + MVIAC3_2
 > does not work.
 > 
 > solution for me, cahnge arch/i386/Kconfig.cpu
 > 
 > --- arch/i386/Kconfig.cpu.before     2007-05-17 01:38:26.000000000 +0200
 > +++ arch/i386/Kconfig.cpu       2007-05-17 00:54:52.000000000 +0200
 > @@ -299,5 +299,5 @@
 > 
 >  config X86_CMPXCHG64
 >         bool
 > -       depends on !M386 && !M486
 > +       depends on !M386 && !M486 && !MVIAC3_2
 >         default y
 > 
 > 
 > The related #ifdef is in ./include/asm-i386/cmpxchg.h
 > May be cmpxchg8b is not supported by VIAC3_2 ?
 > 
 > May be some other non Intel/AMD need to be excluded from X86_CMPXCHG64 ?
 > May be the generic option CONFIG_X86_GENERIC need to switch this off also ?

The C3s all have cx8, but it needs to be enabled in an MSR first.
(See arch/i386/kernel/cpu/centaur.c , search for CX8)

Did we add code that uses cmpxchg8b before identify_cpu() gets run ?
I've not been paying attention to .22rc (busy trying to beat .21 into shape for F7)
so I may have missed something obvious. Andi?

	Dave

-- 
http://www.codemonkey.org.uk
