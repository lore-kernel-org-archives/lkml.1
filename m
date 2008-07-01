Return-Path: <linux-kernel-owner+w=401wt.eu-S1759546AbYGAPwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759546AbYGAPwE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 11:52:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbYGAPvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 11:51:54 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:45873 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323AbYGAPvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 11:51:53 -0400
Date: Tue, 1 Jul 2008 17:51:52 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1 of 2] fbcon: bgcolor fix
In-Reply-To: <486A4F64.3050904@eu.citrix.com>
Message-ID: <alpine.LNX.1.10.0807011750570.20393@fbirervta.pbzchgretzou.qr>
References: <486A4F64.3050904@eu.citrix.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday 2008-07-01 17:38, Stefano Stabellini wrote:

>The forth bit of the background color is the blink property bit, not the
>intensity bit, as for the foreground color.
>Therefore it shouldn't be included in the background color.

I'm a bit skeptical, though I have not tried this.
ISTR fb has the power to render full 8 bits background
in addition to blinking.

>--- a/drivers/video/console/fbcon.h
>+++ b/drivers/video/console/fbcon.h
>@@ -92,7 +92,7 @@ struct fbcon_ops {
> #define attr_fgcol(fgshift,s)    \
> 	(((s) >> (fgshift)) & 0x0f)
> #define attr_bgcol(bgshift,s)    \
>-	(((s) >> (bgshift)) & 0x0f)
>+	(((s) >> (bgshift)) & 0x07)
> 
> /* Monochrome */
> #define attr_bold(s) \
