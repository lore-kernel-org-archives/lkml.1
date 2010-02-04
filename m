Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab0BDDTB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 22:19:01 -0500
Received: from mga11.intel.com ([192.55.52.93]:46500 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754948Ab0BDDTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 22:19:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,402,1262592000"; 
   d="scan'208";a="537575128"
Date: Thu, 4 Feb 2010 11:18:54 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Andi Kleen <andi@firstfloor.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>,
       "juha_motorsportcom@luukku.com" <juha_motorsportcom@luukku.com>
Subject: Re: [stable] [PATCH] devmem: check vmalloc address on kmem
	read/write
Message-ID: <20100204031854.GA14324@localhost>
References: <20100122045914.993668874@intel.com> <20100203234724.GA23902@kroah.com> <20100204024202.GD6343@localhost> <20100204115801.cac7c342.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100204115801.cac7c342.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 04, 2010 at 10:58:01AM +0800, KAMEZAWA Hiroyuki wrote:
> On Thu, 4 Feb 2010 10:42:02 +0800
> Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> > commit 325fda71d0badc1073dc59f12a948f24ff05796a upstream.
> > 
> > Otherwise vmalloc_to_page() will BUG().
> > 
> > This also makes the kmem read/write implementation aligned with mem(4):
> > "References to nonexistent locations cause errors to be returned." Here
> > we return -ENXIO (inspired by Hugh) if no bytes have been transfered
> > to/from user space, otherwise return partial read/write results.
> > 
> 
> Wu-san, I have additonal fix to this patch. Now, *ppos update is unstable..
> Could you make merged one ?
> Maybe this one makes the all behavior clearer.
> 
> ==
> This is a more fix for devmem-check-vmalloc-address-on-kmem-read-write.patch
> Now, the condition for updating *ppos is not good. (it's updated even if EFAULT
> occurs..). This fixes that.
> 
> 
> Reported-by: "Juha Leppanen" <juha_motorsportcom@luukku.com>

Sorry, can you elaborate the problem? How it break the application?

It looks that do_generic_file_read() also updates *ppos progressively,
no one complains about that.

Thanks,
Fengguang
