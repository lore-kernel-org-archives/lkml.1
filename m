Return-Path: <linux-kernel-owner+w=401wt.eu-S1753550AbYC1Ekq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550AbYC1Ekq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 00:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750855AbYC1Ekg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 00:40:36 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:52689 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbYC1Ekf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 00:40:35 -0400
Date: Fri, 28 Mar 2008 13:39:40 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <clameter@sgi.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2 of 4] hotplug-memory: adding non-section-aligned
 memory is bad
Message-Id: <20080328133940.dc3be13d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <47EC7202.3040009@goop.org>
References: <e0b16cc8349b38a5f3f9.1206664118@localhost>
	<20080328102719.3ab9162b.kamezawa.hiroyu@jp.fujitsu.com>
	<20080328102342.B0BF.E1E9C6FF@jp.fujitsu.com>
	<20080328105406.5dc61c6c.kamezawa.hiroyu@jp.fujitsu.com>
	<47EC5440.5020107@goop.org>
	<20080328113312.65cca8b5.kamezawa.hiroyu@jp.fujitsu.com>
	<47EC5D2E.8060001@goop.org>
	<20080328121758.7f355925.kamezawa.hiroyu@jp.fujitsu.com>
	<47EC7202.3040009@goop.org>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Mar 2008 21:20:18 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> > How about capturing online_page() by balloon ?
> >   
> 
> You're saying that using online_page() on each page on its own is not 
> sufficient?
> 
online_page() just remove PG_reserved flags and free it. 
Not dealing with global data, like total pages, zonelist, etc.

> > ex.)
> > ==
> > call add_memory() to create mem_map
> > call online_pages() against the whole section. <=== call this without sysfs.
> >      online_pages() do misc. jobs
> >         call online_page() one by one (arch dependent) called by walk_memory_resource.
> >             online_page() will finally call free_page(page).
> >             <=========== Xen capture here.
> >             Don't free onlined page and swallow them into baloon driver.
> > ==
> >   
> 
> I'm not sure what you mean by "capture" here.  Do you mean a hook?  I'd 
> rather not have to put some Xen-specific hook in here.
> 
ok.

> What would happen if I did online_pages(pfn, 1) on each page as I 
> populate it?
> 
I think (hope) it works well. But it seems no one tries to do that.

Thanks,
-Kame



