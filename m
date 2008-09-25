Return-Path: <linux-kernel-owner+w=401wt.eu-S1755296AbYIYTtL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296AbYIYTtL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 15:49:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753390AbYIYTs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 15:48:56 -0400
Received: from styx.suse.cz ([82.119.242.94]:56564 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752555AbYIYTsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 15:48:55 -0400
Date: Thu, 25 Sep 2008 22:45:24 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: David Miller <davem@davemloft.net>, jeffrey.t.kirsher@intel.com,
       airlied@gmail.com, david.vrabel@csr.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       chrisl@vmware.com, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug #11382] e1000e: 2.6.27-rc1 corrupts EEPROM/NVM
In-Reply-To: <200809251243.43441.jbarnes@virtuousgeek.org>
Message-ID: <alpine.LNX.1.10.0809252243090.3389@pegasus.suse.cz>
References: <20080923.150722.141587696.davem@davemloft.net> <alpine.LNX.1.10.0809250110070.4671@pegasus.suse.cz> <200809241726.58628.jbarnes@virtuousgeek.org> <200809251243.43441.jbarnes@virtuousgeek.org>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Sep 2008, Jesse Barnes wrote:

> Here's a patch that adds range checking to the sysfs mappings at least.  
> This patch should catch the case where X (or some other process) tries 
> to map beyond the specific BAR it's (supposedly) trying to access, 
> making things safer in general.  FWIW both my F9 and development 
> versions of X start up fine with this patch applied.

Good. We will use this on affected machines after we start some real 
debugging of this.

> +	/*
> +	 * Make sure the range the user is trying to map falls within
> +	 * the resource
> +	 */
> +	if (map_offset + map_len > pci_resource_len(pdev, i))
> +		return -EINVAL;
> +

At least for debugging purposes I'd propose to put a printk() there with 
process name, and the range it tries to map.

Thanks,

-- 
Jiri Kosina
SUSE Labs
