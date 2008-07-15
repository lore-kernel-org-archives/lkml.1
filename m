Return-Path: <linux-kernel-owner+w=401wt.eu-S1762329AbYGOSQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762329AbYGOSQ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 14:16:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754903AbYGOSQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 14:16:49 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:47925 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138AbYGOSQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 14:16:48 -0400
Date: Tue, 15 Jul 2008 12:16:32 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Alex Chiang <achiang@hp.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 01/14] Introduce cpu_enabled_map and friends
Message-ID: <20080715181632.GG14894@parisc-linux.org>
References: <20080715023344.2528.1836.stgit@blender.achiang> <20080715023349.2528.9423.stgit@blender.achiang> <20080715031512.GF14894@parisc-linux.org> <87wsjnxy4w.fsf@basil.nowhere.org> <20080715102130.GA22866@flint.arm.linux.org.uk> <20080715175740.GB10919@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080715175740.GB10919@ldl.fc.hp.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 11:57:40AM -0600, Alex Chiang wrote:
> My thought was that big SMP systems like ia64, possibly sparc and
> ppc, and increasingly, x86, might find something like this
> useful, as systems get larger and larger, and vendors are going
> to want to do RAS-ish features, like the ability to keep CPUs in
> firmware across reboots until told otherwise by the sysadmin.
> 
> Right now, a 'present' CPU strongly implies 'online' as well,
> since we're calling cpu_up() for all 'present' CPUs in
> smp_init(). But this hurts if:
> 
> 	- you don't actually want to bring up all 'present' CPUs
> 	- you still want to interact with these weirdo zombie
> 	  CPUs that are 'present' but not 'online'

Have you considered simply failing __cpu_up() for CPUs that are
deconfigured by firmware?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
