Return-Path: <linux-kernel-owner+w=401wt.eu-S1760264AbYFINHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760264AbYFINHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 09:07:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757029AbYFING6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 09:06:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45114 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756217AbYFING5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 09:06:57 -0400
Date: Mon, 9 Jun 2008 09:06:46 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Bernhard Walle <bwalle@suse.de>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, anderson@redhat.com
Subject: Re: [patch 0/3] [x86] Fix crashkernel reservation on NUMA machines
Message-ID: <20080609130646.GB3542@redhat.com>
References: <20080608134628.757299158@halley.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080608134628.757299158@halley.suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 08, 2008 at 03:46:28PM +0200, Bernhard Walle wrote:
> This patch series fixes the crashkernel reservation on NUMA machine. The
> regression was discovered by Dave Anderson <anderson@redhat.com>.
> 
> The background is that on NUMA machines, reserve_bootmem_generic() is required
> instead of reserve_bootmem(). To achieve that, it's necessary to make a few
> API changes.
> 
> The patches are against latest linux-2.6 git. They should still go into 2.6.26
> since it's only bug fixing. For 2.6.27, we should unify crashkernel reservation
> for i386 and x86-64.
> 
> Tested on both i386 and x86-64. Compilation was tested with both kexec disabled
> and enabled. The change is x86 only, so no need to test on other architectures.
> 
> 
> Signed-off-by: Bernhard Walle <bwalle@suse.de>

Yes we should be using reserve_bootmem_generic() for reserving memory
on NUMA machines. Recently myself and Dave A. ran into crash while 
reserving memory using resreve_bootmem() on a NUMA machine. 

Reason for crash? reserve_bootmem() always assumes node id to be zero, and
that was not the case.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Thanks
Vivek
