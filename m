Return-Path: <linux-kernel-owner+w=401wt.eu-S1753241AbYKEWu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241AbYKEWu3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 17:50:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751540AbYKEWuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 17:50:21 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:48181 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbYKEWuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 17:50:19 -0500
Date: Wed, 5 Nov 2008 14:50:06 -0800
From: Gary Hade <garyhade@us.ibm.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Gary Hade <garyhade@us.ibm.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org, y-goto@jp.fujitsu.com,
       pbadari@us.ibm.com, mel@csn.ul.ie, lcm@us.ibm.com, mingo@elte.hu,
       greg@kroah.com, nish.aravamudan@gmail.com
Subject: Re: [PATCH] [REPOST #2] mm: show node to memory section
	relationship with symlinks in sysfs
Message-ID: <20081105225006.GA14663@us.ibm.com>
References: <20081103234808.GA13716@us.ibm.com> <20081105123609.878085be.akpm@linux-foundation.org> <1225919024.11514.4.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225919024.11514.4.camel@nimitz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2008 at 01:03:44PM -0800, Dave Hansen wrote:
> On Wed, 2008-11-05 at 12:36 -0800, Andrew Morton wrote:
> > Dumb question: why do this with a symlink forest instead of, say, cat
> > /proc/sys/vm/mem-sections?
> 
> The basic problem is that we on/offline memory based on sections and not
> nodes.  But, physically, people care about nodes.
> 
> So, the question we're answering is "to which sections does this node's
> memory belong?".  We could just put all this data in one big file and
> have:
> 
> $ cat /proc/sys/vm/mem-sections?
> node: section numbers
> 0: 1 2 3 4 5
> 1: 5 6 7 8
> 2: 99 100 101 102
> 
> But, we have the nodes in sysfs and we also have the sections in sysfs
> and I don't want Greg to be mean to me.  He's scary.  We could simply
> dump the section numbers in sysfs, but the first thing userspace is
> going to do is:
> 
> for section in /sys/devices/system/node/node1/memory*; do
> 	nr=$(cat $section)
> 	cat foo > /sys/devices/system/memory/memory$nr/bar
> done
> 
> Making the symlinks makes it harder for us to screw this process up,
> both in the kernel and in userspace.  Plus, symlinks are easy to code up
> in sysfs. 

The new symlinks to the mem sections directories from within
the node directories are also consistent with the presidence set
by symlinks to the CPU directories from these same locations.

Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc

