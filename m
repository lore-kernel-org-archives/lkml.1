Return-Path: <linux-kernel-owner+w=401wt.eu-S1758811AbYDKWyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758811AbYDKWyR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 18:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756736AbYDKWyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 18:54:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57547 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756363AbYDKWyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 18:54:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: yhlu.kernel@gmail.com
Subject: Re: [PATCH] x86_64: don't need set default res if only have one root bus
Date: Sat, 12 Apr 2008 00:54:01 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Ingo Molnar <mingo@elte.hu>, kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200804111514.53680.yhlu.kernel@gmail.com>
In-Reply-To: <200804111514.53680.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804120054.01959.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 12 of April 2008, Yinghai Lu wrote:
> only one root bus, don't need to split that root resources.

This patch fixes the issue described at
http://lkml.org/lkml/2008/4/10/304 and in the following thread for me.

> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Tested-by: Rafael J. Wysocki <rjw@sisk.pl>
 
> diff --git a/arch/x86/pci/k8-bus_64.c b/arch/x86/pci/k8-bus_64.c
> index 7ed7f51..c433982 100644
> --- a/arch/x86/pci/k8-bus_64.c
> +++ b/arch/x86/pci/k8-bus_64.c
> @@ -69,7 +69,8 @@ void set_pci_bus_resources_arch_default(struct pci_bus *b)
>  	int j;
>  	struct pci_root_info *info;
>  
> -	if (!pci_root_num)
> +	/* if only one root bus, don't need to anything */
> +	if (pci_root_num < 2)
>  		return;
>  
>  	for (i = 0; i < pci_root_num; i++) {
> 
> 

Thanks,
Rafael
