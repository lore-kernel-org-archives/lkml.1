Return-Path: <linux-kernel-owner+w=401wt.eu-S1755638AbZJVRnk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638AbZJVRnk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 13:43:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755489AbZJVRnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 13:43:39 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:36313 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862AbZJVRni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 13:43:38 -0400
Date: Thu, 22 Oct 2009 10:43:04 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Crane Cai <crane.cai@amd.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       lenb@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-i2c@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH] i2c-scmi: Quirk to work on IBM machines with broken
	BIOSes
Message-ID: <20091022174304.GO26149@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <20091020231149.GM26149@tux1.beaverton.ibm.com> <20091021023016.GC32413@crane-desktop> <200910210857.13978.bjorn.helgaas@hp.com> <20091021173733.GN26149@tux1.beaverton.ibm.com> <20091022071748.GA17917@crane-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091022071748.GA17917@crane-desktop>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 22, 2009 at 03:17:53PM +0800, Crane Cai wrote:

> This patch below represents my meanings:
> *) add a new HID for IBM SMBus CMI devices
> *) add methods for IBM SMBus CMI devices as you did
> *) hook different HID with different control methods set
> It may be more smooth for i2c-scmi, please consider.

Looks fine to me.

I still need the changes to drivers/acpi/scan.c, but if you push this patch
upstream then I'll reroll my patch as a follow-on to yours...

>  static const struct acpi_device_id acpi_smbus_cmi_ids[] = {
> -	{"SMBUS01", 0},
> +	{"SMBUS01", (kernel_ulong_t)&smbus_methods},
> +	{"SMBUSIBM", (kernel_ulong_t)&ibm_smbus_methods},

...with the custom HID string #define'd in a header file someplace.

Actually, if you'll add a Signed-off-by line to your patch, I'll submit both of
them as a patchset and save you a little work. :)

> +	for (; id->id[0]; id++)

Stylistic nit--would it be clearer to initialize id in the for loop instead of
at the beginning of the function?

--D

