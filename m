Return-Path: <linux-kernel-owner+w=401wt.eu-S1762044AbXLRBDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762044AbXLRBDR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 20:03:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbXLRBDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 20:03:04 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52393 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbXLRBDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 20:03:03 -0500
Date: Tue, 18 Dec 2007 10:05:45 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "de Dinechin, Christophe (Integrity VM)" 
	<christophe.de-dinechin@hp.com>
Cc: "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Picco, Robert W." <robert.picco@hp.com>,
       "tony.luck@intel.com" <tony.luck@intel.com>
Subject: Re: [PATCH] ia64: Avoid unnecessary TLB flushes when allocating
 memory
Message-Id: <20071218100545.14ae2c73.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <7575980D7C4188408E8BDB171DA164B73A875A92A6@G3W1111.americas.hpqcorp.net>
References: <7575980D7C4188408E8BDB171DA164B73A875A92A6@G3W1111.americas.hpqcorp.net>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Dec 2007 15:03:07 +0000

> +       if (mm != active_mm) {
> +               /* Restore region IDs for mm */
> +               if (mm && active_mm) {
> +                       activate_context(mm);
> +               } else {
> +                       flush_tlb_all();
> +                       return;
> +               }
>         }
should be 

preempt_disable();
activate_context(mm);
preempt_enable();

?
(from comments for activate_context()).


Thanks,
-Kame

