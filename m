Return-Path: <linux-kernel-owner+w=401wt.eu-S1754578AbYDXAm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578AbYDXAm7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 20:42:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750902AbYDXAmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 20:42:50 -0400
Received: from gate.crashing.org ([63.228.1.57]:37247 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086AbYDXAmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 20:42:50 -0400
Subject: Re: [PATCH 2/2 v2] mpic_u3msi: mpic_u3msi: failed allocation
	unnoticed
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: michael@ellerman.id.au
Cc: Roel Kluin <12o3l@tiscali.nl>, linuxppc-dev@ozlabs.org, paulus@samba.org,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1208993783.9245.10.camel@concordia.ozlabs.ibm.com>
References: <480F6905.3070808@tiscali.nl> <480F8754.7000200@tiscali.nl>
	 <df21920e067e73985f73047e2d8bcbda@kernel.crashing.org>
	 <480FB766.1040405@tiscali.nl>
	 <1208993783.9245.10.camel@concordia.ozlabs.ibm.com>
Content-Type: text/plain; charset=utf-8
Date: Thu, 24 Apr 2008 10:42:29 +1000
Message-Id: <1208997749.9060.77.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-04-24 at 09:36 +1000, Michael Ellerman wrote:
> 
> I think the real bug is that we're using irq_hw_number_t to represent
> something which isn't. At the end of the day we have to stash the
> hwirq
> into the MSI message data, which is a u32.
> 
> I guess we could imagine a driver that does something magic to allow
> it
> to put something bigger than a u32 in the MSI message, but I doubt it.
> 
> So I think ﻿mpic_msi_alloc_hwirqs() should return a long, which allows
> it to return a full u32 plus the negative error values.

Until it's used on 32 bits...

Make it return an int error code and pass the hwirq elsewhere or use the
"illegal" hwirq number (each PIC defines one) as the error return.

Cheers,
Ben.


