Return-Path: <linux-kernel-owner+w=401wt.eu-S1759788AbZKFUSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759788AbZKFUSy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 15:18:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759715AbZKFUSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 15:18:54 -0500
Received: from one.firstfloor.org ([213.235.205.2]:56029 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbZKFUSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 15:18:53 -0500
To: castet.matthieu@free.fr
Cc: linux-kernel@vger.kernel.org
Subject: Re: Using x86 segments against NULL pointer deference exploit
From: Andi Kleen <andi@firstfloor.org>
References: <1257512389.4af41dc504e1b@imp.free.fr>
Date: Fri, 06 Nov 2009 21:18:58 +0100
In-Reply-To: <1257512389.4af41dc504e1b@imp.free.fr> (castet matthieu's message of "Fri, 06 Nov 2009 13:59:49 +0100")
Message-ID: <87eiob76fh.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

castet.matthieu@free.fr writes:

> Hi,
>
> I am wondering why we can't set the KERNEL_DS data segment to not contain the
> first page, ie changing it from R/W flat model to R/W expand down from
> 0xffffffff to 4096.

As Alan pointed out setting segment limits/bases has large penalties.

This has been already addressed by the mmap limit defaults 
on the VM level by disallowing to place something on the zero page.

In fact a lot of systems should already run with that default.

> PS : why x86_64 segment got access bit set and x86_32 doesn't ?

It's a extremly minor optimization, but the CPU sets it on the first
access anyways.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
