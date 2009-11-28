Return-Path: <linux-kernel-owner+w=401wt.eu-S1754034AbZK1MnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034AbZK1MnL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 07:43:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753984AbZK1MnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 07:43:10 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:56375 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753973AbZK1MnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 07:43:09 -0500
Message-ID: <4B111ADC.9020800@garzik.org>
Date: Sat, 28 Nov 2009 07:43:08 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Stefan Assmann <sassmann@redhat.com>
CC: linux-pci@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Krzysztof Halasa <khc@pm.waw.pl>, Don Dutile <ddutile@redhat.com>,
       kaneshige.kenji@jp.fujitsu.com
Subject: Re: [PATCH] change PCI nomenclature according to PCI-SIG
References: <4B110F79.8080405@redhat.com>
In-Reply-To: <4B110F79.8080405@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2009 06:54 AM, Stefan Assmann wrote:
> From: Stefan Assmann<sassmann@redhat.com>
>
> Changing occurrences of variants of PCI-X and PCIe to the PCI-SIG
> terms listed in the "Trademark and Logo Usage Guidelines".
> http://www.pcisig.com/developers/procedures/logos/Trademark_and_Logo_Usage_Guidelines_updated_112206.pdf
> Additionally some renames of Gb/s to GT/s where appropriate, concerns PCIe.
>
> This is a followup to the discussion at:
> http://lkml.org/lkml/2009/10/14/107
> Patch is based on 2.6.32-rc8.
>
> Signed-off-by: Stefan Assmann<sassmann@redhat.com>

NAK, this clearly introduces bugs and changes sysfs output (ABI).

Typically this type of change is pointless churn that creates far more 
problems than it "solves."


> diff --git a/drivers/edac/ppc4xx_edac.c b/drivers/edac/ppc4xx_edac.c
> index 11f2172..eda4fdf 100644
> --- a/drivers/edac/ppc4xx_edac.c
> +++ b/drivers/edac/ppc4xx_edac.c
> @@ -224,8 +224,8 @@ static const unsigned ppc4xx_edac_nr_chans = 1;
>    */
>   static const char * const ppc4xx_plb_masters[9] = {
>   	[SDRAM_PLB_M0ID_ICU]	= "ICU",
> -	[SDRAM_PLB_M0ID_PCIE0]	= "PCI-E 0",
> -	[SDRAM_PLB_M0ID_PCIE1]	= "PCI-E 1",
> +	[SDRAM_PLB_M0ID_PCIE0]	= "PCIe 0",
> +	[SDRAM_PLB_M0ID_PCIE1]	= "PCIe 1",
>   	[SDRAM_PLB_M0ID_DMA]	= "DMA",
>   	[SDRAM_PLB_M0ID_DCU]	= "DCU",
>   	[SDRAM_PLB_M0ID_OPB]	= "OPB",

This data is interpreted programmatically, as the comments at its usage 
site indicate.  This change is likely to break stuff.


> diff --git a/drivers/firmware/edd.c b/drivers/firmware/edd.c
> index 9e4f59d..ed6b7e3 100644
> --- a/drivers/firmware/edd.c
> +++ b/drivers/firmware/edd.c
> @@ -150,7 +150,7 @@ edd_show_host_bus(struct edd_device *edev, char *buf)
>   	if (!strncmp(info->params.host_bus_type, "ISA", 3)) {
>   		p += scnprintf(p, left, "\tbase_address: %x\n",
>   			     info->params.interface_path.isa.base_address);
> -	} else if (!strncmp(info->params.host_bus_type, "PCIX", 4) ||
> +	} else if (!strncmp(info->params.host_bus_type, "PCI-X", 4) ||

blatantly and obviously wrong:

1) this is a BIOS-provided data structure.  this patch just broke PCI-X 
detection in edd.

2) the string length comparison is obviously wrong, even if problem #1 
was not present




> diff --git a/drivers/hwmon/abituguru3.c b/drivers/hwmon/abituguru3.c
> index 3cf28af..9bbfb02 100644
> --- a/drivers/hwmon/abituguru3.c
> +++ b/drivers/hwmon/abituguru3.c
> @@ -172,7 +172,7 @@ static const struct abituguru3_motherboard_info abituguru3_motherboards[] = {
>   		{ "DDR",		 1, 0, 10, 1, 0 },
>   		{ "DDR VTT",		 2, 0, 10, 1, 0 },
>   		{ "CPU VTT 1.2V",	 3, 0, 10, 1, 0 },
> -		{ "MCH&  PCIE 1.5V",	 4, 0, 10, 1, 0 },
> +		{ "MCH&  PCIe 1.5V",	 4, 0, 10, 1, 0 },
>   		{ "MCH 2.5V",		 5, 0, 20, 1, 0 },
>   		{ "ICH 1.05V",		 6, 0, 10, 1, 0 },
>   		{ "ATX +12V (24-Pin)",	 7, 0, 60, 1, 0 },
> @@ -194,7 +194,7 @@ static const struct abituguru3_motherboard_info abituguru3_motherboards[] = {
>   		{ "DDR",		 1, 0, 10, 1, 0 },
>   		{ "DDR VTT",		 2, 0, 10, 1, 0 },
>   		{ "CPU VTT 1.2V",	 3, 0, 10, 1, 0 },
> -		{ "MCH&  PCIE 1.5V",	 4, 0, 10, 1, 0 },
> +		{ "MCH&  PCIe 1.5V",	 4, 0, 10, 1, 0 },
>   		{ "MCH 2.5V",		 5, 0, 20, 1, 0 },
>   		{ "ICH 1.05V",		 6, 0, 10, 1, 0 },
>   		{ "ATX +12V (24-Pin)",	 7, 0, 60, 1, 0 },
> @@ -223,7 +223,7 @@ static const struct abituguru3_motherboard_info abituguru3_motherboards[] = {
>   		{ "DDR",		 1, 0, 10, 1, 0 },
>   		{ "DDR VTT",		 2, 0, 10, 1, 0 },
>   		{ "CPU VTT 1.2V",	 3, 0, 10, 1, 0 },
> -		{ "MCH&  PCIE 1.5V",	 4, 0, 10, 1, 0 },
> +		{ "MCH&  PCIe 1.5V",	 4, 0, 10, 1, 0 },
>   		{ "MCH 2.5V",		 5, 0, 20, 1, 0 },
>   		{ "ICH 1.05V",		 6, 0, 10, 1, 0 },
>   		{ "ATX +12V (24-Pin)",	 7, 0, 60, 1, 0 },
> @@ -245,7 +245,7 @@ static const struct abituguru3_motherboard_info abituguru3_motherboards[] = {
>   		{ "DDR",		 1, 0, 10, 1, 0 },
>   		{ "DDR VTT",		 2, 0, 10, 1, 0 },
>   		{ "CPU VTT 1.2V",	 3, 0, 10, 1, 0 },
> -		{ "MCH&  PCIE 1.5V",	 4, 0, 10, 1, 0 },
> +		{ "MCH&  PCIe 1.5V",	 4, 0, 10, 1, 0 },
>   		{ "MCH 2.5V",		 5, 0, 20, 1, 0 },
>   		{ "ICH 1.05V",		 6, 0, 10, 1, 0 },
>   		{ "ATX +12V (24-Pin)",	 7, 0, 60, 1, 0 },
> @@ -291,7 +291,7 @@ static const struct abituguru3_motherboard_info abituguru3_motherboards[] = {
>   		{ "NB 1.8V",		 4, 0, 10, 1, 0 },
>   		{ "NB 1.8V Dual",	 5, 0, 10, 1, 0 },
>   		{ "HTV 1.2",		 3, 0, 10, 1, 0 },
> -		{ "PCIE 1.2V",		12, 0, 10, 1, 0 },
> +		{ "PCIe 1.2V",		12, 0, 10, 1, 0 },
>   		{ "NB 1.2V",		13, 0, 10, 1, 0 },
>   		{ "ATX +12V (24-Pin)",	 7, 0, 60, 1, 0 },
>   		{ "ATX +12V (4-pin)",	 8, 0, 60, 1, 0 },
> @@ -337,7 +337,7 @@ static const struct abituguru3_motherboard_info abituguru3_motherboards[] = {
>   		{ "DDR",		 1, 0, 10, 1, 0 },
>   		{ "DDR VTT",		 2, 0, 10, 1, 0 },
>   		{ "CPU VTT 1.2V",	 3, 0, 10, 1, 0 },
> -		{ "MCH&  PCIE 1.5V",	 4, 0, 10, 1, 0 },
> +		{ "MCH&  PCIe 1.5V",	 4, 0, 10, 1, 0 },
>   		{ "MCH 2.5V",		 5, 0, 20, 1, 0 },
>   		{ "ICH 1.05V",		 6, 0, 10, 1, 0 },
>   		{ "ATX +12V (24-Pin)",	 7, 0, 60, 1, 0 },
> @@ -366,7 +366,7 @@ static const struct abituguru3_motherboard_info abituguru3_motherboards[] = {
>   		{ "DDR",		 1, 0, 10, 1, 0 },
>   		{ "DDR VTT",		 2, 0, 10, 1, 0 },
>   		{ "CPU VTT 1.2V",	 3, 0, 10, 1, 0 },
> -		{ "MCH&  PCIE 1.5V",	 4, 0, 10, 1, 0 },
> +		{ "MCH&  PCIe 1.5V",	 4, 0, 10, 1, 0 },
>   		{ "MCH 2.5V",		 5, 0, 20, 1, 0 },
>   		{ "ICH 1.05V",		 6, 0, 10, 1, 0 },
>   		{ "ATX +12V (24-Pin)",	 7, 0, 60, 1, 0 },
> @@ -411,7 +411,7 @@ static const struct abituguru3_motherboard_info abituguru3_motherboards[] = {
>   		{ "DDR2",		 1, 0, 20, 1, 0 },
>   		{ "DDR2 VTT",		 2, 0, 10, 1, 0 },
>   		{ "CPU VTT 1.2V",	 3, 0, 10, 1, 0 },
> -		{ "MCH&  PCIE 1.5V",	 4, 0, 10, 1, 0 },
> +		{ "MCH&  PCIe 1.5V",	 4, 0, 10, 1, 0 },
>   		{ "MCH 2.5V",		 5, 0, 20, 1, 0 },
>   		{ "ICH 1.05V",		 6, 0, 10, 1, 0 },
>   		{ "ATX +12V (24-Pin)",	 7, 0, 60, 1, 0 },
> @@ -443,7 +443,7 @@ static const struct abituguru3_motherboard_info abituguru3_motherboards[] = {
>   		{ "NB 1.8V",		 4, 0, 10, 1, 0 },
>   		{ "NB 1.2V ",		13, 0, 10, 1, 0 },
>   		{ "SB 1.2V",		 5, 0, 10, 1, 0 },
> -		{ "PCIE 1.2V",		12, 0, 10, 1, 0 },
> +		{ "PCIe 1.2V",		12, 0, 10, 1, 0 },
>   		{ "ATX +12V (24-Pin)",	 7, 0, 60, 1, 0 },
>   		{ "ATX +12V (4-pin)",	 8, 0, 60, 1, 0 },
>   		{ "ATX +5V",		 9, 0, 30, 1, 0 },

bugs galore:  these strings match DMI data.



> index fbf8c53..e20cdb8 100644
> --- a/drivers/infiniband/hw/ipath/ipath_iba6120.c
> +++ b/drivers/infiniband/hw/ipath/ipath_iba6120.c
> @@ -639,7 +639,7 @@ static int ipath_pe_boardname(struct ipath_devdata *dd, char *name,
>   		ipath_dev_err(dd,
>   			      "Don't yet know about board with ID %u\n",
>   			      boardrev);
> -		snprintf(name, namelen, "Unknown_InfiniPath_PCIe_%u",
> +		snprintf(name, namelen, "Unknown_InfiniPath_PCIE_%u",
>   			 boardrev);
>   		break;
>   	}

ABI breakage:  this is exported through sysfs.

I stopped reviewing here.  I presume there are more bugs, and ton more 
pointless churn in the latter 60% of the patch.

This patch introduces big diffs to several drivers for little or no 
value AFAICT.

	Jeff



