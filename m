Return-Path: <linux-kernel-owner+w=401wt.eu-S1754609AbYFSVQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609AbYFSVQf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 17:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751957AbYFSVQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 17:16:23 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44427 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbYFSVQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 17:16:20 -0400
Message-ID: <485ACCA1.6070507@firstfloor.org>
Date: Thu, 19 Jun 2008 23:16:17 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Max Asbock <masbock@us.ibm.com>
CC: lkml <linux-kernel@vger.kernel.org>, venkatesh.pallipadi@intel.com
Subject: Re: mce_64.c: mce_cpu_quirks being ignored
References: <1213908276.5942.16.camel@w-amax.beaverton.ibm.com>
In-Reply-To: <1213908276.5942.16.camel@w-amax.beaverton.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max Asbock wrote:



> static void __cpuinit mce_cpu_quirks(struct cpuinfo_x86 *c)
> {
>         /* This should be disabled by the BIOS, but isn't always */
>         if (c->x86_vendor == X86_VENDOR_AMD) {
>                 if(c->x86 == 15)
>                         /* disable GART TBL walk error reporting, which trips off
>                            incorrectly with the IOMMU & 3ware & Cerberus. */
>                         clear_bit(10, &bank[4]);
> ....
> 
> Is turning off that bit still needed?

Yes it is. Also referencing the bank is needed for other reasons anyways,
otherwise it would ignore the user sysfs choice on reconfiguration.

Venki, I did a patch for dynamic banks anyways, but haven't submitted it yet.

-Andi

