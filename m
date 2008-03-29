Return-Path: <linux-kernel-owner+w=401wt.eu-S1756812AbYC2GWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812AbYC2GWR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 02:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbYC2GWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 02:22:08 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46546 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366AbYC2GWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 02:22:07 -0400
Date: Sat, 29 Mar 2008 15:26:51 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>,
       Christoph Lameter <clameter@sgi.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] hotplug-memory: refactor online_pages to separate
 zone growth from page onlining
Message-Id: <20080329152651.e2c40a0c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <47EDD825.20501@goop.org>
References: <47ED8685.9040409@goop.org>
	<20080329133820.e692245d.kamezawa.hiroyu@jp.fujitsu.com>
	<47EDD825.20501@goop.org>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Mar 2008 22:48:21 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> >> -	if (onlined_pages)
> >> +	if (onlined_pages) {
> >> +		struct memory_notify arg;
> >> +
> >> +		arg.start_pfn = pfn;  /* ? */
> >> +		arg.nr_pages = onlined_pages;
> >> +		arg.status_change_nid = -1;  /* ? */
> >> +
> >>  		memory_notify(MEM_ONLINE, &arg);
> >> +	}
> >>     
> > I think you should add "onlined" member instead of reusing nr_pages.
> >   
> 
> I suppose.  What would I put into nr_pages?  And anyway, there are no 
> users for this notification...
> 
My point is "Notifier" is expexted to work correctly and include precise
information regardless of users.

> > But, in general, I have no objection to this way.
> >   
> 
> The refactoring in general?
> 

Separating online_pages() into some meaningful blocks. Then, you can
reuse some parts and avoid dupilication.

Thanks,
-Kame

