Return-Path: <linux-kernel-owner+w=401wt.eu-S1762682AbXGRBiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762682AbXGRBiJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 21:38:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754512AbXGRBh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 21:37:59 -0400
Received: from mx1.suse.de ([195.135.220.2]:57021 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462AbXGRBh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 21:37:58 -0400
To: Jonathan Campbell <jon@nerdgrounds.com>
Cc: linux-kernel@vger.kernel.org, torvalds@transmeta.com
Subject: Re: Patches for REALLY TINY 386 kernels
References: <469A8AED.7070207@nerdgrounds.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 18 Jul 2007 04:33:01 +0200
In-Reply-To: <469A8AED.7070207@nerdgrounds.com>
Message-ID: <p737ioyxwyq.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Campbell <jon@nerdgrounds.com> writes:

> I wrote a set of patches out of concern that even if you compile a 386
> kernel a lot of code irrelevent to legacy machines still
> remains. Things like the Pentium TSC register, DMI information, ESCD
> parsing, and the use of CPUID do not apply to these machines, but
> looking at System.map you can see they're still there.

I'm afraid a lot of this, like the CPUID changes, are fairly pointless
because they are  __cpuinit code anyways. This means (unless you compiled
a kernel with CPU hotplug support enabled) it will be all freed after
boot.

> Already with these patches I can compile a zImage kernel that is 450kb
> large (890kb decompressed)

The important part is not how big the vmlinux is, but how much
memory is actually used after boot. 

I expect concentrating some of the dynamic data structures would
be more fruitful in fact.

-Andi
