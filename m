Return-Path: <linux-kernel-owner+w=401wt.eu-S933715AbZIDRqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933715AbZIDRqH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 13:46:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757084AbZIDRqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 13:46:06 -0400
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:36206 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757088AbZIDRqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 13:46:05 -0400
Date: Fri, 4 Sep 2009 19:46:05 +0200
From: Bastian Blank <waldi@debian.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       544145@bugs.debian.org, Keir Fraser <keir.fraser@eu.citrix.com>
Subject: Re: 32bit binaries on x86_64/Xen segfaults in syscall-vdso
Message-ID: <20090904174605.GA8396@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <waldi@debian.org>,
	Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
	xen-devel@lists.xensource.com, 544145@bugs.debian.org,
	Keir Fraser <keir.fraser@eu.citrix.com>
References: <20090830181637.GA7155@wavehammer.waldi.eu.org> <4AA02C57.30106@goop.org> <20090903220252.GA19309@wavehammer.waldi.eu.org> <4AA03DE8.40706@goop.org> <20090903223603.GA19945@wavehammer.waldi.eu.org> <4AA13B4B.7020101@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4AA13B4B.7020101@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 04, 2009 at 09:07:39AM -0700, Jeremy Fitzhardinge wrote:
> On 09/03/09 15:36, Bastian Blank wrote:
> > This function looks weird. It tries to restores the user code segment.
> > But the documentation from AMD explicitely stat that the CS and SS are
> > restored from the STAR register.
> 
> And STAR is always set with:
>     wrmsrl(MSR_STAR,  ((u64)__USER32_CS)<<48  | ((u64)__KERNEL_CS)<<32);

No. This is the normal kernel setup. But the Xen setup (the relevant
one) looks different:

| #define FLAT_RING3_CS32 0xe023
| wrmsr(MSR_STAR, 0, (FLAT_RING3_CS32<<16) | __HYPERVISOR_CS);

But this does not match my observation either.

And even the native Linux kernel uses "iret" to jump out of a compat
(32bit) syscall. No, I don't want to understand this, but it looks
highly broken.

Bastian

-- 
Captain's Log, star date 21:34.5...
