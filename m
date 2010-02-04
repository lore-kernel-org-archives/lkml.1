Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab0BDDbP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 22:31:15 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33560 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab0BDDbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 22:31:12 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 4 Feb 2010 12:27:42 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
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
Message-Id: <20100204122742.2e1c38f8.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100204031854.GA14324@localhost>
References: <20100122045914.993668874@intel.com>
	<20100203234724.GA23902@kroah.com>
	<20100204024202.GD6343@localhost>
	<20100204115801.cac7c342.kamezawa.hiroyu@jp.fujitsu.com>
	<20100204031854.GA14324@localhost>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Feb 2010 11:18:54 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> On Thu, Feb 04, 2010 at 10:58:01AM +0800, KAMEZAWA Hiroyuki wrote:
> > On Thu, 4 Feb 2010 10:42:02 +0800
> > Wu Fengguang <fengguang.wu@intel.com> wrote:
> > 
> > > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > > 
> > > commit 325fda71d0badc1073dc59f12a948f24ff05796a upstream.
> > > 
> > > Otherwise vmalloc_to_page() will BUG().
> > > 
> > > This also makes the kmem read/write implementation aligned with mem(4):
> > > "References to nonexistent locations cause errors to be returned." Here
> > > we return -ENXIO (inspired by Hugh) if no bytes have been transfered
> > > to/from user space, otherwise return partial read/write results.
> > > 
> > 
> > Wu-san, I have additonal fix to this patch. Now, *ppos update is unstable..
> > Could you make merged one ?
> > Maybe this one makes the all behavior clearer.
> > 
> > ==
> > This is a more fix for devmem-check-vmalloc-address-on-kmem-read-write.patch
> > Now, the condition for updating *ppos is not good. (it's updated even if EFAULT
> > occurs..). This fixes that.
> > 
> > 
> > Reported-by: "Juha Leppanen" <juha_motorsportcom@luukku.com>
> 
> Sorry, can you elaborate the problem? How it break the application?
> 
> It looks that do_generic_file_read() also updates *ppos progressively,
> no one complains about that.
> 
Ah...it seems I misunderstood something...ok, *ppos should be updated every time.

I startted from adding comment on following line and got into a maze.

>   return (virtr + wrote) ? : err;

Sorry for noise.

-Kame

