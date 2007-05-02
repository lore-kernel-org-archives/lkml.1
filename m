Return-Path: <linux-kernel-owner+w=401wt.eu-S1767195AbXEBXMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767195AbXEBXMQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 19:12:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767201AbXEBXMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 19:12:16 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:42816 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767195AbXEBXMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 19:12:15 -0400
Date: Wed, 2 May 2007 16:15:33 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, jwboyer@linux.vnet.ibm.com,
       grant.likely@secretlab.ca, jketreno@linux.intel.com
Subject: Re: [PATCH] lib/hexdump
Message-Id: <20070502161533.cbf38b4b.randy.dunlap@oracle.com>
In-Reply-To: <20070502160635.31dd91e6.akpm@linux-foundation.org>
References: <20070502153556.3c995de7.randy.dunlap@oracle.com>
	<20070502154557.b463c9c3.akpm@linux-foundation.org>
	<46391730.2080003@oracle.com>
	<20070502160635.31dd91e6.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2007 16:06:35 -0700 Andrew Morton wrote:

> On Wed, 02 May 2007 15:56:48 -0700
> Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
> > Andrew Morton wrote:
> > > On Wed, 2 May 2007 15:35:56 -0700
> > > Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > > 
> > >> From: Randy Dunlap <randy.dunlap@oracle.com>
> > >>
> > >> Based on ace_dump_mem() from Grant Likely for the Xilinx 
> > >> SystemACE CompactFlash interface.
> > >>
> > >> Add hex_dumper() to lib/hexdump.c and linux/kernel.h.
> > >>
> > >> This patch adds the function 'hex_dumper' which can be used to perform a 
> > >> hex + ASCII dump of data to syslog, in an easily viewable format, thus
> > >> providing a common text hex dump format.
> > >>
> > >> It does not provide a hexdump_to_buffer() function.
> > >> if someone needs that, we'll have to add it.
> > >>
> > >> Example usage:
> > >> 	hex_dumper(KERN_DEBUG, data, length);
> > >>
> > > 
> > > Fair enough.  This is the sort of thing one could easily overdesign ;)
> > 
> > The Intel version also returned the number of bytes printed.
> > and they had a hexdump_to_buffer() for sysfs output.
> > 
> 
> Yeah, that's where we get into creature feeping.  Really it should be
> passed the address of a function which performs the per-char output and
> which is passed a bunch of args so it can do its stuff.  But doing printk
> of a single char at a time is a bit inefficient and produces mangled output
> on SMP.  And then we don't know the length of the output and we'd like it
> dynamically allocated and on and on.
> 
> Ho hum.  Perhaps a middle ground is to implement hexdump-to-memory as the
> core function.  hex_dumper() becomes a simple wrapper around that.  (but
> how big is its buffer?  One line would be OK, I guess)

Yeah, I almost did it that way.  We'll see.

> > OK, that's one way to do it.  I'll wait a bit for other comments.
> 
> Good luck ;)

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
