Return-Path: <linux-kernel-owner+w=401wt.eu-S1763283AbYD3PT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763283AbYD3PT1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 11:19:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758333AbYD3PTD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 11:19:03 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47592 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762387AbYD3PTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 11:19:01 -0400
Date: Tue, 29 Apr 2008 10:18:52 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Fabio De Francesco <fabiomdf@alice.it>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [x86_32] With 4GB installed, in which cases low mem total is
 less than 896MB?
Message-ID: <20080429101852.6719eb59@infradead.org>
In-Reply-To: <200804301702.06019.fabiomdf@alice.it>
References: <200804301702.06019.fabiomdf@alice.it>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008 17:02:02 +0200
Fabio De Francesco <fabiomdf@alice.it> wrote:

> Hi all,
> 
> I've got a Linux box, Intel Core 2 T7700 with 4GB RAM installed, with
> vanilla kernel 2.6.24 + TuxOnIce patch-set compiled for x86_32bit
> (CONFIG_X86_32=y), whose /proc/meminfo shows "LowTotal 794MB".

I'm not an expert in this, but one thing is that the more memory the system has, the more overhead there is.
(roughly 64 bytes per 4Kb of memory).

> 
> A further issue is about the "MemTotal" value that only shows more or
> less 3550MB with HIGHMEM4G selected, and it shows a  more satisfying
> value of 4050MB with HIGHMEM64G + X86_PAE + RESOURCES_64BIT selected.
> In both cases LowTotal is always less than 800MB.
> 
> Why is it needed to activate the PAE mechanism in order to see and
> use the whole 4GB memory? Is it what it is expected to be done?

yes this is expected.
Let me explain: even though you have 4Gb of memory, it's spread out like this:

0     - 3.5Gb	Memory
3.5Gb - 4Gb  	Gap
4Gb   - 4.5Gb   Memory

This "gap" is needed for PCI. PCI devices have "memory" on them (technical term is "MMIO", memory mapped IO) and
this needs to be in the first 4Gb of memory (traditionally). So the system leaves a 0.5Gb gap on your system
for this purpose.
Some other systems have 0.25Gb or 1Gb gaps; some systems even have a BIOS option for the size of this gap.
But a gap.. all machines with >= 4Gb have that.

Just enable PAE and be done with it. (And you get the non-executable stack security feature as well then)
