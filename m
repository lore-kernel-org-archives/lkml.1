Return-Path: <linux-kernel-owner+w=401wt.eu-S1753055AbZDZExq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055AbZDZExq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 00:53:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750957AbZDZExh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 00:53:37 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:55955 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbZDZExg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 00:53:36 -0400
Date: Sat, 25 Apr 2009 22:53:35 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: linux-omap@vger.kernel.org
cc: lrg@slimlogic.co.uk, broonie@opensource.wolfsonmicro.com,
       linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net
Subject: Re: [PATCH] regulator core: fix double-free in regulator_register()
 error path
In-Reply-To: <alpine.DEB.2.00.0904250526210.28378@utopia.booyaka.com>
Message-ID: <alpine.DEB.2.00.0904252250230.4291@utopia.booyaka.com>
References: <alpine.DEB.2.00.0904250526210.28378@utopia.booyaka.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Apr 2009, Paul Walmsley wrote:

> During regulator registration, any error after device_register() will 
> cause a double-free on the struct regulator_dev 'rdev'.  The bug is in 
> drivers/regulator/core.c:regulator_register():
>
> ...
> 
> device_unregister() calls regulator_dev_release() which frees rdev.  The 
> subsequent kfree corrupts memory and causes some OMAP3 systems to oops on 
> boot in regulator_get().

For the 3430SDP users out there, this patch also fixes the boot hang after 
"regulator_init_complete: incomplete constraints, leaving VAUX3 on"
on that device.

- Paul
