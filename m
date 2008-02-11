Return-Path: <linux-kernel-owner+w=401wt.eu-S1755832AbYBKUPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832AbYBKUPc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 15:15:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757993AbYBKUPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 15:15:05 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52546 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753266AbYBKUPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 15:15:03 -0500
Date: Mon, 11 Feb 2008 11:48:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Badari Pulavarty <pbadari@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com, haveblue@us.ibm.com,
       linux-mm@kvack.org
Subject: Re: [-mm PATCH] register_memory/unregister_memory clean ups
Message-Id: <20080211114818.74c9dcc7.akpm@linux-foundation.org>
In-Reply-To: <1202750598.25604.3.camel@dyn9047017100.beaverton.ibm.com>
References: <1202750598.25604.3.camel@dyn9047017100.beaverton.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2008 09:23:18 -0800
Badari Pulavarty <pbadari@us.ibm.com> wrote:

> Hi Andrew,
> 
> While testing hotplug memory remove against -mm, I noticed
> that unregister_memory() is not cleaning up /sysfs entries
> correctly. It also de-references structures after destroying
> them (luckily in the code which never gets used). So, I cleaned
> up the code and fixed the extra reference issue.
> 
> Could you please include it in -mm ?
> 
> Thanks,
> Badari
> 
> register_memory()/unregister_memory() never gets called with
> "root". unregister_memory() is accessing kobject_name of
> the object just freed up. Since no one uses the code,
> lets take the code out. And also, make register_memory() static.  
> 
> Another bug fix - before calling unregister_memory()
> remove_memory_block() gets a ref on kobject. unregister_memory()
> need to drop that ref before calling sysdev_unregister().
> 

I'd say this:

> Subject: [-mm PATCH] register_memory/unregister_memory clean ups

is rather tame.  These are more than cleanups!  These sound like
machine-crashing bugs.  Do they crash machines?  How come nobody noticed
it?

All very strange...


