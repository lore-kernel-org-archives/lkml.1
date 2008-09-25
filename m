Return-Path: <linux-kernel-owner+w=401wt.eu-S1755176AbYIYMYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176AbYIYMYB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 08:24:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753716AbYIYMXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 08:23:45 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:12934 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029AbYIYMXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 08:23:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent:sender;
        b=rQBxcTChYjXgUvRorMEVspBBwIh8/ioW+gvIrFNv/9mNn9PLT/xOTMJDfFvY5CK3JT
         K98kBHDQXN0em85qrGvS71DRgnoG/ozzxf2MgUGK1w7LCwBkMh5+FYO5H+7Yeg6h1o6A
         A+b/h1zAsAmZHdTTqSg9uFra6NyBY2UVAgHMQ=
Date: Thu, 25 Sep 2008 08:22:41 -0400
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: paulus@samba.org
Cc: David Gibson <david@gibson.dropbear.id.au>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: Fix PCI in Holly device tree
Message-ID: <20080925122241.GC2243@yoda.jdub.homelinux.org>
References: <20080925023904.GC15169@yookeroo.seuss> <20080925081129.7f882085@zod.rchland.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080925081129.7f882085@zod.rchland.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2008 at 08:11:29AM -0400, Josh Boyer wrote:
>On Thu, 25 Sep 2008 12:39:04 +1000
>David Gibson <david@gibson.dropbear.id.au> wrote:
>
>> The PCI bridge on the Holly board is current incorrectly represented
>> in the device tree.  The current device tree node for the PCI bridge
>> sits under the tsi-bridge node.  That's not obviously wrong, but the
>> PCI bridge translated some PCI spaces into CPU address ranges which
>> were not translated by the tsi-bridge node.
>> 
>> We used to get away with this problem because the PCI bridge discovery
>> code was also buggy, assuming incorrectly that PCI host bridge nodes
>> were always directly under the root bus and treating the translated
>> addresses as raw CPU addresses, rather than parent bus addresses.
>> This has since been fixed, breaking Holly.
>> 
>> This could be fixed by adding extra translations to the tsi-bridge
>> node, but this patch instead moves the Holly PCI bridge out of the
>> tsi-bridge node to the root bus.  This makes the tsi-bridge node
>> represent only the built-in IO devices in the bridge, with a
>> more-or-less contiguous address range.  This is the same convention
>> used on Freescale SoC chips, where the "soc" node represents only the
>> IMMR region, and the PCI and other bus bridges are separate nodes
>> under the root bus.
>> 
>> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
>
>Acked-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>
>
>Paul, I can include this in my 'next' branch if you aren't opposed.
>I'll have another set of patches going in there today/tomorrow.

Er... on second thought, this actually fixes a regression on Holly.  So
I'll amend my offer to put it in my 'next' branch to be contingent on you
not wanting to get it into 2.6.27 this late.

josh
