Return-Path: <linux-kernel-owner+w=401wt.eu-S1754972AbZGPKKB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972AbZGPKKB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 06:10:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754961AbZGPKKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 06:10:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:36058 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754951AbZGPKKA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 06:10:00 -0400
Message-ID: <4A5EFC52.7080201@kernel.org>
Date: Thu, 16 Jul 2009 03:09:22 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: dann frazier <dannf@hp.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [x86] pci: Get rid of magic number in AMD bus discovery
References: <20090716002821.GV11729@ldl.fc.hp.com>
In-Reply-To: <20090716002821.GV11729@ldl.fc.hp.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dann frazier wrote:
> The number 4 is hardcoded in a couple of loops.
> Use the already-defined PCI_ROOT_NR macro instead.
> 
> Signed-off-by: dann frazier <dannf@hp.com>
> ---
>  arch/x86/pci/amd_bus.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
> index 3ffa10d..feb3e09 100644
> --- a/arch/x86/pci/amd_bus.c
> +++ b/arch/x86/pci/amd_bus.c
> @@ -332,7 +332,7 @@ static int __init early_fill_mp_bus_info(void)
>  		return 0;
>  
>  	pci_root_num = 0;
> -	for (i = 0; i < 4; i++) {
> +	for (i = 0; i < PCI_ROOT_NR; i++) {
>  		int min_bus;
>  		int max_bus;
>  		reg = read_pci_config(bus, slot, 1, 0xe0 + (i << 2));
> @@ -368,7 +368,7 @@ static int __init early_fill_mp_bus_info(void)
>  	memset(range, 0, sizeof(range));
>  	range[0].end = 0xffff;
>  	/* io port resource */
> -	for (i = 0; i < 4; i++) {
> +	for (i = 0; i < PCI_ROOT_NR; i++) {
>  		reg = read_pci_config(bus, slot, 1, 0xc0 + (i << 3));
>  		if (!(reg & 3))
>  			continue;

please don't do that.

how about
        /* mmio resource */
        for (i = 0; i < 8; i++) {

those value is decided by HW...

YH
