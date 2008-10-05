Return-Path: <linux-kernel-owner+w=401wt.eu-S1756568AbYJEWZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568AbYJEWZw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 18:25:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755085AbYJEWZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 18:25:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49562 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754887AbYJEWZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 18:25:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: 2.6.27-rc8+ - first impressions
Date: Mon, 6 Oct 2008 00:29:42 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <20081005183603.GA3263@amd.corenet.prv> <200810052119.13881.rjw@sisk.pl> <20081005211748.GA11576@amd.corenet.prv>
In-Reply-To: <20081005211748.GA11576@amd.corenet.prv>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810060029.42471.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 5 of October 2008, Dmitry Torokhov wrote:
> On Sun, Oct 05, 2008 at 09:19:13PM +0200, Rafael J. Wysocki wrote:
> > On Sunday, 5 of October 2008, Dmitry Torokhov wrote:
> > > On Sun, Oct 05, 2008 at 08:59:49PM +0200, Rafael J. Wysocki wrote:
> > > > On Sunday, 5 of October 2008, Dmitry Torokhov wrote:
> > > > > Hi,
> > > > > 
> > > > > Lats night I loaded 2.6.27-rc8-tip for the first time on my AMD Turion
> > > > > 64 laptop that is normally runs with Fedora distribution kernel.
> > > > > Compared to 2.6.25 the thing is broken - hdparm reports about 3MB/sec
> > > > > speed, fans are constantly on, everything seems sluggish.
> > > > > 
> > > > > Booting with hpet=force (HPET is disabled in BIOS) hangs the box
> > > > > somewhere in tty_init.
> > > > 
> > > > Is that an HP box, by chance?
> > > > 
> > > 
> > > Yeah, HP nx6115.
> > 
> > Oh well.
> > 
> > Please send me the output of dmidecode from it.
> > 
> 
> Here you go:

Thanks.

Please see if the appended patch helps.

Rafael


Not-yet-signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/x86/kernel/acpi/boot.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

Index: linux-2.6/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/boot.c
+++ linux-2.6/arch/x86/kernel/acpi/boot.c
@@ -1605,6 +1605,14 @@ static struct dmi_system_id __initdata a
 	 */
 	{
 	 .callback = dmi_ignore_irq0_timer_override,
+	 .ident = "HP nx6115 laptop",
+	 .matches = {
+		     DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+		     DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq nx6115"),
+		     },
+	 },
+	{
+	 .callback = dmi_ignore_irq0_timer_override,
 	 .ident = "HP NX6125 laptop",
 	 .matches = {
 		     DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
@@ -1619,6 +1627,14 @@ static struct dmi_system_id __initdata a
 		     DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq nx6325"),
 		     },
 	 },
+	{
+	 .callback = dmi_ignore_irq0_timer_override,
+	 .ident = "HP 6715b laptop",
+	 .matches = {
+		     DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+		     DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq 6715b"),
+		     },
+	 },
 	{}
 };
 
