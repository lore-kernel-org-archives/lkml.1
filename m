Return-Path: <linux-kernel-owner+w=401wt.eu-S1762888AbXJETGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762888AbXJETGx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 15:06:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759088AbXJETGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 15:06:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54570 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758959AbXJETGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 15:06:44 -0400
Date: Fri, 5 Oct 2007 15:06:12 -0400
From: Dave Jones <davej@redhat.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: werner <werner@copaya.yi.org>, linux-kernel@vger.kernel.org
Subject: Re: Bug in drm  modules of kernel 2.6.23-rc9-git2
Message-ID: <20071005190612.GA31345@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Adrian Bunk <bunk@kernel.org>, werner <werner@copaya.yi.org>,
	linux-kernel@vger.kernel.org
References: <1191565675.4842@copaya.yi.org> <20071005083122.GH10852@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071005083122.GH10852@stusta.de>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2007 at 10:31:22AM +0200, Adrian Bunk wrote:
 > On Fri, Oct 05, 2007 at 03:27:55AM -0300, werner wrote:
 > > attn:  linux-kernel@vger.kernel.org
 > > 
 > > 
 > > There is a bug in the drm modules,  w.r.t. radeon and savage grafic cards (at least)
 > > This bug is present on kernel 2.6.23-rc9-git2 ,  it was NOT present on 2.6.23-rc8-git4
 > > nor in the previous kernels.   Without drm, also compiz snapshot don't work longer
 > > 
 > > I hope you can find and repair this before the 2.6.23 release
 > > 
 > > Below is the beginning of dmesg  for the two kernels what I quoted above.
 > > 
 > > Werner Landgraf
 > > www.copaya.yi.org
 > > 
 > > 
 > > ==============  dmesg 2.6.23-rc9-git2 (drm no working longer ...) ===================================
 > > Linux version 2.6.23-rc9-git2-i486-1mn (root@werner) (gcc version 4.2.0 20061031 (prerelease)) #1 SMP Thu Oct 4 15:32:50 GFT 2007
 > >...
 > > via_agp: Unknown symbol agp_bridge
 > > via_agp: Unknown symbol agp3_generic_sizes
 > > via_agp: Unknown symbol global_cache_flush
 > > via_agp: Unknown symbol agp_generic_enable
 > > via_agp: Unknown symbol agp_generic_insert_memory
 > > via_agp: Unknown symbol agp_generic_destroy_page
 > > via_agp: Unknown symbol agp_off
 > > via_agp: Unknown symbol agp_remove_bridge
 > > via_agp: Unknown symbol agp_generic_mask_memory
 > > via_agp: Unknown symbol agp_generic_alloc_by_type
 > > via_agp: Unknown symbol agp_generic_free_by_type
 > > via_agp: Unknown symbol agp_alloc_bridge
 > > via_agp: Unknown symbol agp_add_bridge
 > > via_agp: Unknown symbol get_agp_version
 > > via_agp: Unknown symbol agp_generic_remove_memory
 > > via_agp: Unknown symbol agp_generic_create_gatt_table
 > > via_agp: Unknown symbol agp_generic_type_to_mask_type
 > > via_agp: Unknown symbol agp_generic_free_gatt_table
 > > via_agp: Unknown symbol agp_generic_alloc_page
 > > via_agp: Unknown symbol agp_put_bridge
 > >...
 > 
 > The agpgart module is not present.

Given that CONFIG_VIA_AGP depends on CONFIG_AGP, I'm not sure how it's
possible to even get into the above state.
I'd love to see the output of grep AGP .config for this kernel.

The only thing I can think of to reproduce this would be to
build both as modules, and insmod via-agp.ko instead of modprobe,
which is not something that really makes any sense.

	Dave

-- 
http://www.codemonkey.org.uk
