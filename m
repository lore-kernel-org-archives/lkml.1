Return-Path: <linux-kernel-owner+w=401wt.eu-S1755319AbXK0DcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbXK0DcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 22:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753080AbXK0DcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 22:32:05 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:54289 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233AbXK0DcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 22:32:03 -0500
Date: Mon, 26 Nov 2007 19:23:24 -0800
From: Greg KH <greg@kroah.com>
To: Konrad Rzeszutek <konrad@darnok.org>
Cc: linux-kernel@vger.kernel.org, pjones@redhat.com, konradr@redhat.com,
       konradr@linux.vnet.ibm.com, randy.dunlap@oracle.com, hpa@zytor.com,
       lenb@kernel.org, mike.anderson@us.ibm.com, dwm@austin.ibm.com
Subject: Re: [PATCH] Add iSCSI IBFT Support (v0.3)
Message-ID: <20071127032324.GA30770@kroah.com>
References: <20071126225642.GA7973@andromeda.dapyr.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071126225642.GA7973@andromeda.dapyr.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2007 at 06:56:42PM -0400, Konrad Rzeszutek wrote:
> 
> This patch adds /sysfs/firmware/ibft/[chosen|aliases|ethernet@0,X|target@0,X]
> directories along with text properties which export the the iSCSI Boot
> Firmware Table (iBFT) structure. The layout of the directories mirrors
> how PowerPC OpenBoot exports this data.
> 
> What is iSCSI Boot Firmware Table? It is a mechanism for the iSCSI
> tools to extract from the machine NICs the iSCSI connection information
> so that they can automagically mount the iSCSI share/target. Currently
> the iSCSI information is hard-coded in th initrd.
> 
> For full details of the IBFT structure please take a look at:
> ftp://ftp.software.ibm.com/systems/support/system_x_pdf/ibm_iscsi_boot_firmware_table_v1.02.pdf

As you are adding sysfs files in /sys/firmware, please add documentation
to Documentation/ABI as to what these files are, what they do, what is
in them, and what they are to be used for.

> +	rc = firmware_register(&ibft_subsys);
> +	if (rc)
> +		return rc;

This function, as well as the whole decl_subsys() stuff is gone in my
tree and in -mm.  /sys/firmware is now just a simple kobject that you
are free to chain off of.  If you describe just what these sysfs
subdirectories and files are for and how they are going to be used, I'd
be glad to rework this patch to use the new interfaces.

thanks,

greg k-h
