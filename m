Return-Path: <linux-kernel-owner+w=401wt.eu-S1755221AbYGSQC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221AbYGSQC1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 12:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752738AbYGSQCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 12:02:18 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:18168 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbYGSQCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 12:02:18 -0400
Date: Sat, 19 Jul 2008 18:06:59 +0200
From: Krzysztof Helt <krzysztof.h1@poczta.fm>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Quel Qun <kelk1@comcast.net>,
       linux-fbdev-devel@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Linux-fbdev-devel] No console on Riva TNT since 2.6.26-0.rc4
Message-Id: <20080719180659.da7efbcd.krzysztof.h1@poczta.fm>
In-Reply-To: <20080710025149.GA4817@martell.zuzino.mipt.ru>
References: <062620082004.6012.4863F668000CEA0D0000177C2200751090CE05040A05@comcast.net>
	<20080709194108.f18226e8.akpm@linux-foundation.org>
	<20080710025149.GA4817@martell.zuzino.mipt.ru>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-EMID: c0e2b138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jul 2008 06:51:49 +0400
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> On Wed, Jul 09, 2008 at 07:41:08PM -0700, Andrew Morton wrote:
> > On Thu, 26 Jun 2008 20:04:56 +0000 kelk1@comcast.net (Quel Qun) wrote:
> > 
> > > Hi,
> > > 
> > > The system boots fine with 2.6.26-0.rc3.1mnb (Mandriva Cooker), but since rc4, I see a few squares of color, then a black screen and the console never comes back. This is independent of the resolution chosen when using vga=ask. The machine does boot and I can start X if I log in blindly. Only the F1 to F6 consoles are gone.
> > > 

Please try the patch below if it helps:

--- linux-2.6.26/drivers/video/vesafb.c	2008-07-13 23:51:29.000000000 +0200
+++ linux-mm/drivers/video/vesafb.c	2008-07-19 17:56:51.774318414 +0200
@@ -247,7 +247,8 @@ static int __init vesafb_probe(struct pl
 	/*   size_total -- all video memory we have. Used for mtrr
 	 *                 entries, ressource allocation and bounds
 	 *                 checking. */
-	size_total = screen_info.lfb_size * 65536;
+	size_total = screen_info.lfb_linelength * screen_info.lfb_height *
+		     screen_info.pages;
 	if (vram_total)
 		size_total = vram_total * 1024 * 1024;
 	if (size_total < size_vmode)

Regards,
Krzysztof

----------------------------------------------------------------------
Zobacz cala prawde o Lukaszu Podolskim!
kliknij >>> http://link.interia.pl/f1e57

