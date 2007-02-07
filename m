Return-Path: <linux-kernel-owner+w=401wt.eu-S1161423AbXBGUhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161423AbXBGUhB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 15:37:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161422AbXBGUg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 15:36:59 -0500
Received: from ozlabs.org ([203.10.76.45]:33907 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161421AbXBGUg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 15:36:57 -0500
Subject: Re: [PATCH 9/11] Panic delay fix
From: Rusty Russell <rusty@rustcorp.com.au>
To: Pavel Machek <pavel@ucw.cz>
Cc: Zachary Amsden <zach@vmware.com>, Andi Kleen <ak@muc.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <20070207123552.GD4481@ucw.cz>
References: <200702060353.l163rUmj000771@zach-dev.vmware.com>
	 <20070206122729.GC47229@muc.de> <45C8FA2D.6010706@vmware.com>
	 <20070207123552.GD4481@ucw.cz>
Content-Type: text/plain
Date: Thu, 08 Feb 2007 07:36:12 +1100
Message-Id: <1170880572.11736.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-07 at 12:35 +0000, Pavel Machek wrote:
> Ugh, it sounds like paravirt is more b0rken then I thought. It should
> always to the proper delay, then replace those udelays that are not
> needed on virtualized hardware with something else.
> 
> Just magically defining udelay into nop is broken.

We'd have to audit and figure out what udelays are for hardware and
which are not, but the evidence is that the vast majority of them are
for hardware and not needed for virtualization.

Changing udelay to "hardware_udelay" or something all over the kernel
would have delayed the paravirt_ops merge by an infinite amount 8)

Rusty.

