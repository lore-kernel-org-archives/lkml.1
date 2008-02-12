Return-Path: <linux-kernel-owner+w=401wt.eu-S1760122AbYBLIMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760122AbYBLIMa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 03:12:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751146AbYBLIMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 03:12:22 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49417 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbYBLIMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 03:12:21 -0500
Date: Tue, 12 Feb 2008 17:06:30 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Badari Pulavarty <pbadari@us.ibm.com>
Subject: Re: [-mm PATCH] register_memory/unregister_memory clean ups
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, greg@kroah.com,
       haveblue@us.ibm.com, linux-mm <linux-mm@kvack.org>
In-Reply-To: <1202765553.25604.12.camel@dyn9047017100.beaverton.ibm.com>
References: <20080211114818.74c9dcc7.akpm@linux-foundation.org> <1202765553.25604.12.camel@dyn9047017100.beaverton.ibm.com>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20080212154309.F9DA.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.27 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 2008-02-11 at 11:48 -0800, Andrew Morton wrote:
> > On Mon, 11 Feb 2008 09:23:18 -0800
> > Badari Pulavarty <pbadari@us.ibm.com> wrote:
> > 
> > > Hi Andrew,
> > > 
> > > While testing hotplug memory remove against -mm, I noticed
> > > that unregister_memory() is not cleaning up /sysfs entries
> > > correctly. It also de-references structures after destroying
> > > them (luckily in the code which never gets used). So, I cleaned
> > > up the code and fixed the extra reference issue.
> > > 
> > > Could you please include it in -mm ?
> > > 
> > > Thanks,
> > > Badari
> > > 
> > > register_memory()/unregister_memory() never gets called with
> > > "root". unregister_memory() is accessing kobject_name of
> > > the object just freed up. Since no one uses the code,
> > > lets take the code out. And also, make register_memory() static.  
> > > 
> > > Another bug fix - before calling unregister_memory()
> > > remove_memory_block() gets a ref on kobject. unregister_memory()
> > > need to drop that ref before calling sysdev_unregister().
> > > 
> > 
> > I'd say this:
> > 
> > > Subject: [-mm PATCH] register_memory/unregister_memory clean ups
> > 
> > is rather tame.  These are more than cleanups!  These sound like
> > machine-crashing bugs.  Do they crash machines?  How come nobody noticed
> > it?
> > 
> 
> No they don't crash machine - mainly because, they never get called
> with "root" argument (where we have the bug). They were never tested
> before, since we don't have memory remove work yet. All it does
> is, it leave /sysfs directory laying around and causing next
> memory add failure. 

Badari-san.

Which function does call unregister_memory() or unregister_memory_section()?
I can't find its caller in current 2.6.24-mm1.


???????()
  |
  |nothing calls?
  |
  +-->unregister_memory_section()
       |
       |call
       |
       +---> remove_memory_block()
              |
              |call
              |
              +----> unregister_memory()

unregister_memory_section() is only externed in linux/memory.h.

Do you have any another patch to call it?
I think it is necessary for physical memory removing.

If you have not posted it or it is not merged to -mm,
I can understand why this bug remains.
If you posted it, could you point it to me?

Or do I misunderstand something?


Thanks.

-- 
Yasunori Goto 


