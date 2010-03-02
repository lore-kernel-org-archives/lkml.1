Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020Ab0CBXDr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:03:47 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37538 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753238Ab0CBXDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:03:46 -0500
Date: Tue, 2 Mar 2010 15:03:36 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Dave Airlie <airlied@linux.ie>
cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm request 2
In-Reply-To: <alpine.LFD.2.00.1003021451130.3616@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1003021459450.3616@localhost.localdomain>
References: <alpine.DEB.2.00.1003012345440.4099@skynet.skynet.ie> <alpine.LFD.2.00.1003021451130.3616@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 2 Mar 2010, Linus Torvalds wrote:
> 
> I disabled it in the merge, since I had to fix up that file anyway. But 
> please don't make me do these so-called "evil merges" where I end up 
> modifying the thing I merge.

Never mind. I've unpulled the whole effin' mess since it doesn't even 
compile:

	drivers/gpu/drm/nouveau/nouveau_acpi.c:191: error: redefinition of ¡nouveau_register_dsm_handler¢
	drivers/gpu/drm/nouveau/nouveau_drv.h:859: note: previous definition of ¡nouveau_register_dsm_handler¢ was here
	drivers/gpu/drm/nouveau/nouveau_acpi.c:202: error: redefinition of ¡nouveau_unregister_dsm_handler¢
	drivers/gpu/drm/nouveau/nouveau_drv.h:860: note: previous definition of ¡nouveau_unregister_dsm_handler¢ was here

because not only was that VGA_SWITCHEROO Kconfig default the wrong way 
around, the thing had clearly never ever been tested at all.

Why does sh*t like this even make it to me? Was this ever at all in -next? 
I assume not, since that would have picked up on basic compile failures.

Grr. Things like this is what makes me go "Ok, there's always the next 
merge window, maybe it will have gotten some testing by then".

		Linus
