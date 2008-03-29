Return-Path: <linux-kernel-owner+w=401wt.eu-S1753461AbYC2Egn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461AbYC2Egn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 00:36:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750871AbYC2Ege
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 00:36:34 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38540 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbYC2Egd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 00:36:33 -0400
Date: Sat, 29 Mar 2008 13:38:20 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>,
       Christoph Lameter <clameter@sgi.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] hotplug-memory: refactor online_pages to separate
 zone growth from page onlining
Message-Id: <20080329133820.e692245d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <47ED8685.9040409@goop.org>
References: <47ED8685.9040409@goop.org>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Fri, 28 Mar 2008 17:00:05 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> -	if (onlined_pages)
> +	if (onlined_pages) {
> +		struct memory_notify arg;
> +
> +		arg.start_pfn = pfn;  /* ? */
> +		arg.nr_pages = onlined_pages;
> +		arg.status_change_nid = -1;  /* ? */
> +
>  		memory_notify(MEM_ONLINE, &arg);
> +	}
I think you should add "onlined" member instead of reusing nr_pages.

But, in general, I have no objection to this way.

Thanks,
-Kame

