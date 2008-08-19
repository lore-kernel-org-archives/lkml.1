Return-Path: <linux-kernel-owner+w=401wt.eu-S1753651AbYHSHMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651AbYHSHMn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 03:12:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbYHSHMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 03:12:33 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:10907 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbYHSHMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 03:12:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=WI+hQz4bpnCcsBXPL/SLaEBqBV2gm1SwydYC6iXLwl681OwmrHfBzbPO/0pWTIfnky
         hQ2QJ1aFrx/ZnLfsq2WSgM5FhvSP7ePwttxx/r1r/xeu7e0xxVpw5WufiLgb2sEZXjzB
         xxIzIC2cAZ9m/S+cVYZXOO/rl7iy5pdNd8AKc=
Message-ID: <19f34abd0808190012r4418cc4egf9bc25a52056af41@mail.gmail.com>
Date: Tue, 19 Aug 2008 09:12:31 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Andi Kleen" <ak@linux.intel.com>
Subject: Re: oprofile + hibernation = badness
Cc: "Pavel Machek" <pavel@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Robert Richter" <robert.richter@amd.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Philippe Elie" <phil.el@wanadoo.fr>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <48AA1E42.6070802@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0808181332k3c02496auabd04e927bb7cab5@mail.gmail.com>
	 <48AA1E42.6070802@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 3:13 AM, Andi Kleen <ak@linux.intel.com> wrote:
>> ------------[ cut here ]------------
>> WARNING: at
>> /uio/arkimedes/s29/vegardno/git-working/linux-2.6/kernel/smp.c:328 s
>> mp_call_function_mask+0x194/0x1a0()
>
> The usual problem: the suspend function when interrupts are
> already disabled calls smp_call_function which is not allowed with
> interrupt off. But at this point all the other CPUs should be already
> down anyways, so it should be enough to just drop that.
>
> This patch should fix that problem at least by fixing cpu hotplug&
> suspend support. Untested.
>
> -Andi
>
>
> From 3967a8b03a30f26a6a5f41b4cc6a6772b5d0ce4f Mon Sep 17 00:00:00 2001
> From: Andi Kleen <ak@linux.intel.com>
> Date: Tue, 19 Aug 2008 03:10:03 +0200
> Subject: [PATCH] oprofile: fix cpu hotcplug
>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

This gets rid of the suspend warnings, so it looks to be a step in the
right direction! FWIW, you may add my Tested-by to the patch.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
