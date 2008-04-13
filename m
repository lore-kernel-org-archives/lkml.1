Return-Path: <linux-kernel-owner+w=401wt.eu-S1756026AbYDMCAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026AbYDMCAK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 22:00:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750982AbYDMB76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 21:59:58 -0400
Received: from rv-out-0708.google.com ([209.85.198.243]:8900 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750733AbYDMB75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 21:59:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=q29W48wolwD0SJ9fP9449VDRtvquObkLiQhRq8BnfC0BBHkUQGElAlDQaGLFC+mJkeOLWNGMQkt/gjC3sZ3ec76ujORpZSq1Cjon8fvSvpnOGq7gnbtggtEAJfMIBL+0CfNo23jyBpaNsgX5G1Xi+SzSjPlVP+/6bTo07iMU4AA=
Message-ID: <86802c440804121859x42847c2cx37b8cd909b14c6b5@mail.gmail.com>
Date: Sat, 12 Apr 2008 18:59:56 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Johannes Weiner" <hannes@saeurebad.de>
Subject: Re: [patch 2/2] bootmem: Node-setup agnostic free_bootmem()
Cc: linux-kernel@vger.kernel.org, "Andi Kleen" <ak@suse.de>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Yasunori Goto" <y-goto@jp.fujitsu.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Christoph Lameter" <clameter@sgi.com>
In-Reply-To: <20080412225850.704752615@symbol.fehenstaub.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080412223319.372887160@symbol.fehenstaub.lan>
	 <20080412225850.704752615@symbol.fehenstaub.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 12, 2008 at 3:33 PM, Johannes Weiner <hannes@saeurebad.de> wrote:
> Make free_bootmem() look up the node holding the specified address
>  range which lets it work transparently on single-node and multi-node
>  configurations.
>
>  Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
>  CC: Yinghai Lu <yhlu.kernel@gmail.com>
>  CC: Andi Kleen <ak@suse.de>
>  CC: Yasunori Goto <y-goto@jp.fujitsu.com>
>  CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>  CC: Ingo Molnar <mingo@elte.hu>
>  CC: Christoph Lameter <clameter@sgi.com>
>  CC: Andrew Morton <akpm@linux-foundation.org>
>  ---
>
>  Patch tested on x86_32 uma.
>
>  Index: linux-2.6/mm/bootmem.c
>  ===================================================================
>  --- linux-2.6.orig/mm/bootmem.c
>  +++ linux-2.6/mm/bootmem.c
>  @@ -421,7 +421,15 @@ int __init reserve_bootmem(unsigned long
>
>   void __init free_bootmem(unsigned long addr, unsigned long size)
>   {
>  -       free_bootmem_core(NODE_DATA(0)->bdata, addr, size);
>  +       bootmem_data_t *bdata;
>  +
>  +       list_for_each_entry (bdata, &bdata_list, list) {
>  +               if (addr < bdata->node_boot_start)
>  +                       continue;

could have chance that bootmem with reserved_early that is crossing the nodes.

YH


YH
