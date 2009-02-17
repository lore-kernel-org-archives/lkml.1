Return-Path: <linux-kernel-owner+w=401wt.eu-S1755605AbZBRCvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755605AbZBRCvU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 21:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbZBRCvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 21:51:12 -0500
Received: from mga09.intel.com ([134.134.136.24]:27443 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256AbZBRCvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 21:51:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,225,1233561600"; 
   d="scan'208";a="490818803"
Date: Tue, 17 Feb 2009 20:50:21 +0800
From: Yu Zhao <yu.zhao@intel.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 6/7] PCI: document SR-IOV sysfs entries
Message-ID: <20090217125021.GA2403@yzhao-otc.sh.intel.com>
References: <1234790920-1810-1-git-send-email-yu.zhao@intel.com> <1234790920-1810-7-git-send-email-yu.zhao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234790920-1810-7-git-send-email-yu.zhao@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

The `struct device' is preferred over the `struct kobject' in all cases
that create subdirectory in sysfs, is this true?

I'd like to create a subdirectory under PCI device sysfs directory and
put some symbol links into that directory (only symbol links). Should I
use `device' or `kobject'? Currently I use `device' and get two extra
file/directory (uevent and power) which look like useless for my case
because this subdirectory doesn't reflect a real device.

I checked some code and found they use kobject_init_and_add(). Should
I use it instead, or keep using the `device'?

Please advise.

Regards,
Yu

On Mon, Feb 16, 2009 at 09:28:39PM +0800, Zhao, Yu wrote:
> Signed-off-by: Yu Zhao <yu.zhao@intel.com>
> ---
>  Documentation/ABI/testing/sysfs-bus-pci |   27 +++++++++++++++++++++++++++
>  1 files changed, 27 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
> index ceddcff..84dc100 100644
> --- a/Documentation/ABI/testing/sysfs-bus-pci
> +++ b/Documentation/ABI/testing/sysfs-bus-pci
> @@ -9,3 +9,30 @@ Description:
>  		that some devices may have malformatted data.  If the
>  		underlying VPD has a writable section then the
>  		corresponding section of this file will be writable.
> +
> +What:		/sys/bus/pci/devices/.../virtfn/N
> +Date:		February 2009
> +Contact:	Yu Zhao <yu.zhao@intel.com>
> +Description:
> +		This symbol link appears when hardware supports SR-IOV
> +		capability and Physical Function driver has enabled it.
> +		The symbol link points to the PCI device sysfs entry of
> +		Virtual Function whose index is N (0...MaxVFs-1).
> +
> +What:		/sys/bus/pci/devices/.../virtfn/dep_link
> +Date:		February 2009
> +Contact:	Yu Zhao <yu.zhao@intel.com>
> +Description:
> +		This symbol link appears when hardware supports SR-IOV
> +		capability and Physical Function driver has enabled it,
> +		and this device has vendor specific dependencies with
> +		others. The symbol link points to the PCI device sysfs
> +		entry of Physical Function this device depends on.
> +
> +What:		/sys/bus/pci/devices/.../physfn
> +Date:		February 2009
> +Contact:	Yu Zhao <yu.zhao@intel.com>
> +Description:
> +		This symbol link appears when a device is Virtual Function.
> +		The symbol link points to the PCI device sysfs entry of
> +		Physical Function this device associates with.
> -- 
> 1.5.6.4
> 
