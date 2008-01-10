Return-Path: <linux-kernel-owner+w=401wt.eu-S1756309AbYAJUbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309AbYAJUbU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 15:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbYAJUbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 15:31:10 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:51062 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbYAJUbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 15:31:08 -0500
Date: Thu, 10 Jan 2008 12:28:59 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: linville@tuxdriver.com, lkml <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org
Subject: Re: [PATCH wireless/arlan] Replace logical- by bit-and
Message-Id: <20080110122859.569b3774.randy.dunlap@oracle.com>
In-Reply-To: <47866EE9.80003@tiscali.nl>
References: <4722453E.2090801@tiscali.nl>
	<472248AC.7080201@tiscali.nl>
	<47866EE9.80003@tiscali.nl>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jan 2008 20:15:53 +0100 Roel Kluin wrote:

> Totally untested patch below from linus' git tree. The && is incorrect, right?
> 
> from drivers/net/wireless/arlan.h:390:
> #define ARLAN_POWER             0x40
> #define ARLAN_ACCESS            0x80
> 
> Replace logical and by bit-and
> 
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> ---
> diff --git a/drivers/net/wireless/arlan.h b/drivers/net/wireless/arlan.h
> index 3ed1df7..7b7498f 100644
> --- a/drivers/net/wireless/arlan.h
> +++ b/drivers/net/wireless/arlan.h
> @@ -485,7 +485,7 @@ struct arlan_private {
>  #define clearClearInterrupt(dev){\
>     writeControlRegister(dev,readControlRegister(dev) & ~ARLAN_CLEAR_INTERRUPT);}
>  #define setPowerOff(dev){\
> -   writeControlRegister(dev,readControlRegister(dev) | (ARLAN_POWER && ARLAN_ACCESS));\
> +   writeControlRegister(dev, readControlRegister(dev) | (ARLAN_POWER & ARLAN_ACCESS));\

eh?  How does that help?

0x80 && 0x40 -> 0
0x80 & 0x40  -> 0

so readControlRegister() | (0)
??

Maybe it should be (ARLAN_POWER | ARLAN_ACCESS), but some
arlan developer or someone with specs should help here...


>     writeControlRegister(dev,readControlRegister(dev) & ~ARLAN_ACCESS);}
>  #define setPowerOn(dev){\
>     writeControlRegister(dev,readControlRegister(dev) & ~(ARLAN_POWER));   }

or am I sleeping()?
---
~Randy
