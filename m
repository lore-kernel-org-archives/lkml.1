Return-Path: <linux-kernel-owner+w=401wt.eu-S1753590AbZGAQhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590AbZGAQhs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 12:37:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750907AbZGAQhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 12:37:41 -0400
Received: from 195-23-16-24.net.novis.pt ([195.23.16.24]:34566 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbZGAQhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 12:37:40 -0400
X-Greylist: delayed 1290 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Jul 2009 12:37:40 EDT
Message-ID: <4A4B8BCB.6000108@grupopie.com>
Date: Wed, 01 Jul 2009 17:16:11 +0100
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 2.0.0.21 (X11/20090310)
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: sam@ravnborg.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] reduce kallsyms table size on 64-bit arch-s
References: <4A4A1ED10200007800008379@vpn.id2.novell.com>
In-Reply-To: <4A4A1ED10200007800008379@vpn.id2.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> Some architectures (the patch carries it out for x86-64) can reduce the
> kallsyms pointer table's size by half through the use of relative 32-
> bit pointers. Since the kallsyms tables get created as assembly files
> anyway, the adjustment is strait forward and only requires a little bit
> of abstraction at the consuming side.

I've been wanting to do this for a long time, so I'm really glad someone
stepped up to do it for me :)

I've reviewed the patch and it looks good. I worry that other
architectures have strange uses for addresses that might produce larger
than 32 bit offsets, especially with CONFIG_KALLSYMS_ALL, but since this
is an "opt-in" config option, I guess it's ok.

Acked-by: Paulo Marques <pmarques@grupopie.com>

> Further, independent of architecture, kallsyms_num_syms and
> kallsyms_markers[] can use 32-bit types.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>

-- 
Paulo Marques - www.grupopie.com

"Who is general Failure and why is he reading my disk?"
