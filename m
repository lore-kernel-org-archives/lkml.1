Return-Path: <linux-kernel-owner+w=401wt.eu-S1754566Ab0ATEjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab0ATEjl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 23:39:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754023Ab0ATEjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 23:39:40 -0500
Received: from outbound-mail-313.bluehost.com ([67.222.54.6]:50428 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753975Ab0ATEjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 23:39:40 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=lxLBtBSPlqJJFhxAYrK5m2+cgA+QZ57AeT7ODTIwjLvYYcuqH7jSTx8VV+DLwQjV6/wd4949i+m0cuh6xTwytfTh+pw1WF4DeV7sLsaawDPlXewTtEXh+JLCiRTiDyrf;
Date: Wed, 20 Jan 2010 06:39:32 +0200
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Shaohua Li <shaohua.li@intel.com>
Subject: Re: linux-next: pci tree build failure
Message-ID: <20100120063932.3a8ac69e@jbarnes-x200.intel.com>
In-Reply-To: <20100118194050.7ea0c406.sfr@canb.auug.org.au>
References: <20100118194050.7ea0c406.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; i586-moblin-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 213.28.64.81 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pushed this fix out to linux-next, thanks.

Jesse

On Mon, 18 Jan 2010 19:40:50 +1100
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Jesse,
> 
> Today's linux-next build (ppc64 allyesconfig) failed like this:
> 
> In file included from drivers/pci/pcie/pme/pcie_pme.c:22:
> include/linux/pci-acpi.h:42: error: expected '=', ',', ';', 'asm' or
> '__attribute__' before 'acpi_find_root_bridge_handle'
> 
> This file was added in commit f3adb5a4f2e1dfdf9482af05481d0928a39477e8
> ("PCI PM: PCIe PME root port service driver") from the pci tree and
> seems to depend on ACPI.  Maybe its building should depend on
> CONFIG_ACPI?
> 
> I added the following patch for today (I presume there is a better
> fix):
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 18 Jan 2010 19:36:11 +1100
> Subject: [PATCH] pci: PCIE_PME seems to depend on ACPI
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/pci/pcie/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/pci/pcie/Kconfig b/drivers/pci/pcie/Kconfig
> index cf3c35f..b8b494b 100644
> --- a/drivers/pci/pcie/Kconfig
> +++ b/drivers/pci/pcie/Kconfig
> @@ -49,4 +49,4 @@ config PCIEASPM_DEBUG
>  
>  config PCIE_PME
>  	def_bool y
> -	depends on PCIEPORTBUS && PM_RUNTIME && EXPERIMENTAL
> +	depends on PCIEPORTBUS && PM_RUNTIME && EXPERIMENTAL && ACPI
