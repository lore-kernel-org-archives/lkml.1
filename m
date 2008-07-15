Return-Path: <linux-kernel-owner+w=401wt.eu-S1758097AbYGOS7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097AbYGOS7Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 14:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754957AbYGOS6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 14:58:55 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55670 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761943AbYGOS6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 14:58:53 -0400
Date: Tue, 15 Jul 2008 19:48:22 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Alex Chiang <achiang@hp.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 01/14] Introduce cpu_enabled_map and friends
Message-ID: <20080715184822.GB29991@flint.arm.linux.org.uk>
Mail-Followup-To: Matthew Wilcox <matthew@wil.cx>,
	Alex Chiang <achiang@hp.com>, Andi Kleen <andi@firstfloor.org>,
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-acpi@vger.kernel.org
References: <20080715023344.2528.1836.stgit@blender.achiang> <20080715023349.2528.9423.stgit@blender.achiang> <20080715031512.GF14894@parisc-linux.org> <87wsjnxy4w.fsf@basil.nowhere.org> <20080715102130.GA22866@flint.arm.linux.org.uk> <20080715175740.GB10919@ldl.fc.hp.com> <20080715181632.GG14894@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080715181632.GG14894@parisc-linux.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 12:16:32PM -0600, Matthew Wilcox wrote:
> On Tue, Jul 15, 2008 at 11:57:40AM -0600, Alex Chiang wrote:
> > My thought was that big SMP systems like ia64, possibly sparc and
> > ppc, and increasingly, x86, might find something like this
> > useful, as systems get larger and larger, and vendors are going
> > to want to do RAS-ish features, like the ability to keep CPUs in
> > firmware across reboots until told otherwise by the sysadmin.
> > 
> > Right now, a 'present' CPU strongly implies 'online' as well,
> > since we're calling cpu_up() for all 'present' CPUs in
> > smp_init(). But this hurts if:
> > 
> > 	- you don't actually want to bring up all 'present' CPUs
> > 	- you still want to interact with these weirdo zombie
> > 	  CPUs that are 'present' but not 'online'
> 
> Have you considered simply failing __cpu_up() for CPUs that are
> deconfigured by firmware?

But what if you want to have a system boot with, say, 4 CPUs and
then decide at run time to bring up another 4 CPUs when required?

How about having smp_init() call into arch code to query whether
it should bring up a not-already-online CPU?  Architectures that
want to do something special can then make the decision there and
everyone else can define the test completely away.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
