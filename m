Return-Path: <linux-kernel-owner+w=401wt.eu-S933571AbYBBWjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933571AbYBBWjX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 17:39:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762989AbYBBWjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 17:39:14 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:56028 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763676AbYBBWjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 17:39:14 -0500
Date: Sat, 2 Feb 2008 23:39:17 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Add EXPORT_INIT_SYMBOL()?
Message-ID: <20080202223917.GC27546@uranus.ravnborg.org>
References: <20080202135222.GA23700@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080202135222.GA23700@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 02, 2008 at 02:52:22PM +0100, Sam Ravnborg wrote:
> While analysing some of the section mismatches reported
> by modpost I came to the conclusion that there
> was no good way to say that a certain function could
> both be annotated say __cpuinit and exported.
> 
> One example is register_cpu_notifier() in kernel/cpu.c
> The function is annotated __cpuinit which is correct
> as this function is used only in the startup phase
> of a non HOTPLUG_CPU kernel and always available if
> CONFIG_HOTPLUG_CPU is equal 'y'.
> 
> There are more examples in the tree - I have used
> register_cpu_notifier as an example.
> 
> So that left me with the following choices:
> a) Drop the annotation of register_cpu_notifier()
>    thus wasting memory and loosing the checks
>    performed by modpost.
> b) Add a small helper function annotated __ref
>    that would call the __cpuinit annotated
>    __register_cpu_notifier()
> c) Drop all section mismatch checks for exported
>    symbols expect those annotated with __init

For the record I have just committed a patch
to kbuild.git implmenting approach c)

If we need to change this later to something
more or less smart we can always do so.

	Sam
