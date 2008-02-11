Return-Path: <linux-kernel-owner+w=401wt.eu-S1758540AbYBKV3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758540AbYBKV3v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 16:29:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753500AbYBKV3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 16:29:43 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:49098 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420AbYBKV3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 16:29:42 -0500
Subject: Re: [-mm PATCH] register_memory/unregister_memory clean ups
From: Badari Pulavarty <pbadari@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, greg@kroah.com, haveblue@us.ibm.com,
       linux-mm <linux-mm@kvack.org>
In-Reply-To: <20080211114818.74c9dcc7.akpm@linux-foundation.org>
References: <1202750598.25604.3.camel@dyn9047017100.beaverton.ibm.com>
	 <20080211114818.74c9dcc7.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 11 Feb 2008 13:32:32 -0800
Message-Id: <1202765553.25604.12.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-02-11 at 11:48 -0800, Andrew Morton wrote:
> On Mon, 11 Feb 2008 09:23:18 -0800
> Badari Pulavarty <pbadari@us.ibm.com> wrote:
> 
> > Hi Andrew,
> > 
> > While testing hotplug memory remove against -mm, I noticed
> > that unregister_memory() is not cleaning up /sysfs entries
> > correctly. It also de-references structures after destroying
> > them (luckily in the code which never gets used). So, I cleaned
> > up the code and fixed the extra reference issue.
> > 
> > Could you please include it in -mm ?
> > 
> > Thanks,
> > Badari
> > 
> > register_memory()/unregister_memory() never gets called with
> > "root". unregister_memory() is accessing kobject_name of
> > the object just freed up. Since no one uses the code,
> > lets take the code out. And also, make register_memory() static.  
> > 
> > Another bug fix - before calling unregister_memory()
> > remove_memory_block() gets a ref on kobject. unregister_memory()
> > need to drop that ref before calling sysdev_unregister().
> > 
> 
> I'd say this:
> 
> > Subject: [-mm PATCH] register_memory/unregister_memory clean ups
> 
> is rather tame.  These are more than cleanups!  These sound like
> machine-crashing bugs.  Do they crash machines?  How come nobody noticed
> it?
> 

No they don't crash machine - mainly because, they never get called
with "root" argument (where we have the bug). They were never tested
before, since we don't have memory remove work yet. All it does
is, it leave /sysfs directory laying around and causing next
memory add failure. 

Thanks,
Badari

