Return-Path: <linux-kernel-owner+w=401wt.eu-S964885AbZLPXNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964885AbZLPXNR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 18:13:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763134AbZLPXNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 18:13:13 -0500
Received: from kroah.org ([198.145.64.141]:60127 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762914AbZLPXNL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 18:13:11 -0500
Date: Wed, 16 Dec 2009 15:12:10 -0800
From: Greg KH <greg@kroah.com>
To: Tejun Heo <teheo@novell.com>
Cc: stable@kernel.org, tony.luck@intel.com, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jan Beulich <JBeulich@novell.com>,
       linux-mm@kvack.org, Geert Uytterhoeven <geert@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [stable] [PATCH -stable] vmalloc: conditionalize build of
 pcpu_get_vm_areas()
Message-ID: <20091216231210.GB9421@kroah.com>
References: <4B1D3A3302000078000241CD@vpn.id2.novell.com>
 <20091207153552.0fadf335.akpm@linux-foundation.org>
 <4B1E1B1B0200007800024345@vpn.id2.novell.com>
 <4B1E0E56.8020003@kernel.org>
 <4B1E1EE60200007800024364@vpn.id2.novell.com>
 <4B1E1513.3020000@kernel.org>
 <4B203614.1010907@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B203614.1010907@novell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10, 2009 at 08:43:16AM +0900, Tejun Heo wrote:
> pcpu_get_vm_areas() is used only when dynamic percpu allocator is used
> by the architecture.  In 2.6.32, ia64 doesn't use dynamic percpu
> allocator and has a macro which makes pcpu_get_vm_areas() buggy via
> local/global variable aliasing and triggers compile warning.
> 
> The problem is fixed in upstream and ia64 uses dynamic percpu
> allocators, so the only left issue is inclusion of unnecessary code
> and compile warning on ia64 on 2.6.32.
> 
> Don't build pcpu_get_vm_areas() if legacy percpu allocator is in use.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Jan Beulich <JBeulich@novell.com>
> Cc: stable@kernel.org
> ---
> Please note that this commit won't appear on upstream.

So this is only needed for the .32 kernel stable tree?  Not .31?  And
it's not upstream as it was solved differently there?

thanks,

greg k-h
