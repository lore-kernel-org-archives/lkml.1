Return-Path: <linux-kernel-owner+w=401wt.eu-S1755200AbYIYMLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200AbYIYMLw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 08:11:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753456AbYIYMLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 08:11:44 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:39147 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189AbYIYMLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 08:11:43 -0400
Date: Thu, 25 Sep 2008 08:11:29 -0400
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: David Gibson <david@gibson.dropbear.id.au>
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: Fix PCI in Holly device tree
Message-ID: <20080925081129.7f882085@zod.rchland.ibm.com>
In-Reply-To: <20080925023904.GC15169@yookeroo.seuss>
References: <20080925023904.GC15169@yookeroo.seuss>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Sep 2008 12:39:04 +1000
David Gibson <david@gibson.dropbear.id.au> wrote:

> The PCI bridge on the Holly board is current incorrectly represented
> in the device tree.  The current device tree node for the PCI bridge
> sits under the tsi-bridge node.  That's not obviously wrong, but the
> PCI bridge translated some PCI spaces into CPU address ranges which
> were not translated by the tsi-bridge node.
> 
> We used to get away with this problem because the PCI bridge discovery
> code was also buggy, assuming incorrectly that PCI host bridge nodes
> were always directly under the root bus and treating the translated
> addresses as raw CPU addresses, rather than parent bus addresses.
> This has since been fixed, breaking Holly.
> 
> This could be fixed by adding extra translations to the tsi-bridge
> node, but this patch instead moves the Holly PCI bridge out of the
> tsi-bridge node to the root bus.  This makes the tsi-bridge node
> represent only the built-in IO devices in the bridge, with a
> more-or-less contiguous address range.  This is the same convention
> used on Freescale SoC chips, where the "soc" node represents only the
> IMMR region, and the PCI and other bus bridges are separate nodes
> under the root bus.
> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>

Acked-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>

Paul, I can include this in my 'next' branch if you aren't opposed.
I'll have another set of patches going in there today/tomorrow.

josh
