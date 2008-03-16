Return-Path: <linux-kernel-owner+w=401wt.eu-S1752778AbYCPKGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778AbYCPKGk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 06:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751745AbYCPKGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 06:06:31 -0400
Received: from relay.gothnet.se ([82.193.160.251]:6974 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751711AbYCPKGa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 06:06:30 -0400
Message-ID: <47DCF107.2040307@tungstengraphics.com>
Date: Sun, 16 Mar 2008 11:05:59 +0100
From: =?ISO-8859-2?Q?Thomas_Hellstr=F6m?= <thomas@tungstengraphics.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080306)
MIME-Version: 1.0
To: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
CC: David Airlie <airlied@linux.ie>, Shankar Giri V <shankargiri@gmail.com>,
       dri-devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] change the type of Unichrome display adapter (PCI	ID=1106:3108)
References: <47DBB442.90509@freemail.hu>
In-Reply-To: <47DBB442.90509@freemail.hu>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
X-BitDefender-Scanner: Mail not scanned due to license constraints
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Németh Márton wrote:
> From: Márton Németh <nm127@freemail.hu>
>
> Change the type of Unichrome display adapter with PCI ID=1106:3108 to
> get rid of message "irq 16: nobody cared".
>
> See http://bugzilla.kernel.org/show_bug.cgi?id=8641 for details.
>
> Signed-off-by: Shankar Giri V <shankargiri@gmail.com>
> Signed-off-by: Márton Németh <nm127@freemail.hu>
> ---
>
> --- linux-2.6.25-rc5/drivers/char/drm/drm_pciids.h.orig	2008-03-15 10:58:49.000000000 +0100
> +++ linux-2.6.25-rc5/drivers/char/drm/drm_pciids.h	2008-03-15 10:59:31.000000000 +0100
> @@ -335,7 +335,7 @@
>  	{0x1106, 0x3118, PCI_ANY_ID, PCI_ANY_ID, 0, 0, VIA_PRO_GROUP_A}, \
>  	{0x1106, 0x3122, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
>  	{0x1106, 0x7205, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
> -	{0x1106, 0x3108, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
> +	{0x1106, 0x3108, PCI_ANY_ID, PCI_ANY_ID, 0, 0, VIA_PRO_GROUP_A}, \
>  	{0x1106, 0x3344, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
>  	{0x1106, 0x3343, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0}, \
>  	{0x1106, 0x3230, PCI_ANY_ID, PCI_ANY_ID, 0, 0, VIA_DX9_0}, \
>
> -------------------------------------------------------------------------
> This SF.net email is sponsored by: Microsoft
> Defy all challenges. Microsoft(R) Visual Studio 2008.
> http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
> --
> _______________________________________________
> Dri-devel mailing list
> Dri-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/dri-devel
>   
Nope, this is not a correct fix. It enables a set of DMA commands not 
available on the K8M800, also it makes the via IRQ handler just report 
"Handled" when in fact the device keeps firing 200 000 or so interrupts 
per second.

I'm 99.99 % convinced that this is a hw bug, and it also appears in the 
KM400 chipsets. When VIA was asked about it they replied that IRQ 
functionality was never verified in the K8M800 since the windows driver 
never used it. They only use IRQ for video capture transfer, and there 
is no video-in on K8M800s. Other unichromes with the same IRQ register 
interface work fine.
Having said that, it's not impossible that there may be a hidden 
register somewhere that makes it all work.

The K8M800 irqs have been turned off in newer versions of the openChrome 
2D driver to work around this issue.

/Thomas





