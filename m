Return-Path: <linux-kernel-owner+w=401wt.eu-S1751065AbXE2WeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751065AbXE2WeW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 18:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751002AbXE2Wdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 18:33:54 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:46935 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750883AbXE2Wdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 18:33:53 -0400
Date: Tue, 29 May 2007 15:33:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: Tim Gardner <rtg@tpi.com>, linux-kernel@vger.kernel.org,
       tim.gardner@ubuntu.com, Andi Kleen <ak@suse.de>, stable@kernel.org
Subject: Re: [PATCH 1/1] Work around Dell E520 BIOS reboot bug.
Message-Id: <20070529153331.7b643698.akpm@linux-foundation.org>
In-Reply-To: <20070526025809.GA23351@lists.us.dell.com>
References: <20070523191244.50078196AA1@rtg.theglobal.net>
	<20070526025809.GA23351@lists.us.dell.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2007 21:58:09 -0500
Matt Domsch <Matt_Domsch@dell.com> wrote:

> On Wed, May 23, 2007 at 01:12:44PM -0600, Tim Gardner wrote:
> > From: Tim Gardner <tim.gardner@ubuntu.com>
> > Subject: [PATCH] Work around Dell E520 BIOS reboot bug.
> > 
> > Force Dell E520 to use the BIOS to shutdown/reboot.
> > 
> > Signed-off-by: Tim Gardner <tim.gardner@ubuntu.com>
> 
> Acked-by: Matt Domsch <Matt_Domsch@dell.com>
> 
> Thanks Tim for submitting this.

Do you think this is also required in 2.6.21.x?

Andi: ack for 2.6.22 inclusion?

Thanks.



From: Tim Gardner <tim.gardner@ubuntu.com>

Force Dell E520 to use the BIOS to shutdown/reboot.

I have at least one report that this patch fixes shutdown/reboot
problems on the Dell E520 platform.

Signed-off-by: Tim Gardner <tim.gardner@ubuntu.com>
Cc: Andi Kleen <ak@suse.de>
Acked-by: Matt Domsch <Matt_Domsch@dell.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/reboot.c |    8 ++++++++
 1 files changed, 8 insertions(+)

diff -puN arch/i386/kernel/reboot.c~work-around-dell-e520-bios-reboot-bug arch/i386/kernel/reboot.c
--- a/arch/i386/kernel/reboot.c~work-around-dell-e520-bios-reboot-bug
+++ a/arch/i386/kernel/reboot.c
@@ -89,6 +89,14 @@ static int __init set_bios_reboot(struct
 }
 
 static struct dmi_system_id __initdata reboot_dmi_table[] = {
+	{	/* Handle problems with rebooting on Dell E520's */
+		.callback = set_bios_reboot,
+		.ident = "Dell E520",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Dell DM061"),
+		},
+	},
 	{	/* Handle problems with rebooting on Dell 1300's */
 		.callback = set_bios_reboot,
 		.ident = "Dell PowerEdge 1300",
_

