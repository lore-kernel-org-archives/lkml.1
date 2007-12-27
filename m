Return-Path: <linux-kernel-owner+w=401wt.eu-S1753108AbXL0C7M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108AbXL0C7M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 21:59:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896AbXL0C67
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 21:58:59 -0500
Received: from an-out-0708.google.com ([209.85.132.248]:26217 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbXL0C66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 21:58:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent;
        b=dzLFKhsWV++Mgcg6nCf6qBfl8fso7em+7VpCxQd3NWp1rvLIwp6lfxDSSuUPHbFQBlEv5wA/bi1YD7MTo8km/9Onfb0jByE3hKx4MKbJALrWUdXn3wzqVToxMdhjva3Jgovp8SebJ8hFvdEjkpxCRBl+yf0H/86zWUwdmNO8Q0M=
Date: Wed, 26 Dec 2007 21:21:58 -0500
From: Joseph Fannin <jfannin@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.24-rc6-mm1: __raw_spin_is_contended undefined
Message-ID: <20071227022158.GA10204@nineveh.local>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>,
	Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
References: <20071222233056.d652743e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071222233056.d652743e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 22, 2007 at 11:30:56PM -0800, Andrew Morton wrote:
>
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc6/2.6.24-rc6-mm1/
>

This doesn't build on powerpc with my .config:

In file included from arch/powerpc/kernel/asm-offsets.c:17:
include/linux/sched.h: In function ‘spin_needbreak’:
include/linux/sched.h:1947: error: implicit declaration of function ‘__raw_spin_is_contended’

I don't see where __raw_spin_is_contended is defined for any arch
other than x86, so I guess this will happen on any non-x86 arch when
SMP=y and PREEMPT=y are set?

This comes from "spinlock: lockbreak cleanup" in git-x86.

--
Joseph Fannin
jfannin@gmail.com
