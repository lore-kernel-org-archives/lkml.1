Return-Path: <linux-kernel-owner+w=401wt.eu-S1755316AbZGBTHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316AbZGBTHw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 15:07:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753292AbZGBTHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 15:07:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:40244 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752947AbZGBTHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 15:07:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,336,1243839600"; 
   d="scan'208";a="529768992"
Subject: Re: [RFC patch] disable the assumption of apic_is_clustered_box
 for cores 	>= 6
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: suresh.b.siddha@intel.com
To: Luming Yu <luming.yu@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
In-Reply-To: <3877989d0906291953n599b7047x5fdf6033114e0eed@mail.gmail.com>
References: <3877989d0906291953n599b7047x5fdf6033114e0eed@mail.gmail.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Thu, 02 Jul 2009 12:04:42 -0700
Message-Id: <1246561482.27006.10694.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-29 at 19:53 -0700, Luming Yu wrote:
> Hello,
> 
> We have to disable the assumption of apic_is_clustered_box that assumes high
> 4bits of 8 bit APIC ID was cluster id, which is just the function's guess.
> On a normal 4-socket system with >6cores Processor and HT enabled, we hit the
> limitation of the guess and failed. Have to disable the guess on any
> cores > 6 system.
> 
> Without this patch, we can't use good TSC on any SMP system with 48+ logical CPU

This patch doesn't seem to be the right fix. BTW, it appears that
Yinghai's patch in mainline appear to address this issue already. Did
you check if the mainline still has the issue that you are trying to fix
here?

commit e0e42142bab96404de535cceb85d6533d5ad7942
Author: Yinghai Lu <yinghai@kernel.org>
Date:   Sun Apr 26 23:39:38 2009 -0700

    x86: Use dmi check in apic_is_clustered() on 64-bit to mark the TSC
unstable

thanks,
suresh

