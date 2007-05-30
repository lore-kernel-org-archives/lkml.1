Return-Path: <linux-kernel-owner+w=401wt.eu-S1757803AbXE3RH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757803AbXE3RH1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 13:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753380AbXE3RHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 13:07:15 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:37320 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753923AbXE3RHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 13:07:14 -0400
Date: Wed, 30 May 2007 19:08:14 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Meelis Roos <mroos@linux.ee>
Cc: unlisted-recipients:"; no To-header on input" <""@mail.ravnborg.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Illegal-Object: Syntax error in Cc: address found on vger.kernel.org:
	Cc:	unlisted-recipients:;no To-header on input <""@mail.ravnborg.org>
					     ^-missing end of address
Illegal-Object: Syntax error in Cc: address found on vger.kernel.org:
	Cc:	unlisted-recipients:;no To-header on input <""@mail.ravnborg.org>
					     ^-missing end of address
Subject: Re: [PATCH] [ppc] fix mot_info section
Message-ID: <20070530170814.GD15335@uranus.ravnborg.org>
References: <Pine.SOC.4.64.0705141717110.23895@math> <20070515204540.GC22966@uranus.ravnborg.org> <Pine.SOC.4.64.0705301652250.23769@math> <a781481a0705300758t5f16235al1f420f09472af780@mail.gmail.com> <Pine.SOC.4.64.0705301805390.23769@math>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.SOC.4.64.0705301805390.23769@math>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2007 at 07:14:49PM +0300, Meelis Roos wrote:
> The following patch makes mot_info __initdata since it is used only in 
> __init functions. prep_pci.c change has been tested in real life on 
> Motorola Powerstack II (compiles without modpost warnings and boots 
> fine), pplus.c has not been tested but seems similar.
> 
> Signed-off-by: Meelis Roos <mroos@linux.ee>
> 
> diff --git a/arch/ppc/platforms/pplus.c b/arch/ppc/platforms/pplus.c
> index 8a1788c..9744108 100644
> --- a/arch/ppc/platforms/pplus.c
> +++ b/arch/ppc/platforms/pplus.c
> @@ -256,7 +256,7 @@ struct brd_info {
>  	const char *name;
>  	int (*map_irq) (struct pci_dev *, unsigned char, unsigned char);
>  };
> -struct brd_info mot_info[] = {
> +__initdata struct brd_info mot_info[] = {
>  	{0x300, 0x00, 0x00, "MVME 2400", Genesis2_map_irq},
>  	{0x1E0, 0xE0, 0x00, "Mesquite cPCI (MCP750)", mesquite_map_irq},
>  	{0x1E0, 0xE1, 0x00, "Sitka cPCI (MCPN750)", sitka_map_irq},
> diff --git a/arch/ppc/platforms/prep_pci.c b/arch/ppc/platforms/prep_pci.c
> index 1df3150..bdec1f1 100644
> --- a/arch/ppc/platforms/prep_pci.c
> +++ b/arch/ppc/platforms/prep_pci.c
> @@ -792,7 +792,7 @@ raven_init(void)
>  	return 1;
>  }
>  
> -struct mot_info {
> +__initdata struct mot_info {
>  	int		cpu_type;	/* 0x100 mask assumes for Raven and Hawk boards that the level/edge are set */
>  					/* 0x200 if this board has a Hawk chip. */
>  	int		base_type;

The way you place __initdata is bogus.
Please read following from init.h again:

 * For initialized data:
 * You should insert __initdata between the variable name and equal
 * sign followed by value, e.g.:
 *
 * static int init_variable __initdata = 0;
 * static char linux_logo[] __initdata = { 0x32, 0x36, ... };

If gcc happes to accept your placement does not make it correct.
It is still bogus and unreadable.

	Sam
