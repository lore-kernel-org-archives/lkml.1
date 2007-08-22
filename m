Return-Path: <linux-kernel-owner+w=401wt.eu-S932968AbXHVScx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932968AbXHVScx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 14:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764358AbXHVSco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 14:32:44 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35470 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761127AbXHVScn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 14:32:43 -0400
Date: Wed, 22 Aug 2007 11:32:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, Jan Beulich <jbeulich@novell.com>,
       Andi Kleen <ak@suse.de>
Subject: Re: 2.6.23-rc3-mm1
Message-Id: <20070822113211.9ac85162.akpm@linux-foundation.org>
In-Reply-To: <20070822110348.8fd6a937.randy.dunlap@oracle.com>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
	<20070822110348.8fd6a937.randy.dunlap@oracle.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Aug 2007 11:03:48 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Wed, 22 Aug 2007 02:06:48 -0700 Andrew Morton wrote:
> 
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc3/2.6.23-rc3-mm1/
> 
> allyesconfig on x86_64 says:
> 
> kernel/unwind.c:1016:31: error: undefined identifier '__builtin_labs'
> kernel/unwind.c:1232:25: error: undefined identifier '__builtin_labs'
> 

One wonders why x86_64-mm-unwinder.patch has an open-coded call to
__builtin_labs(), when include/linux/kernel.h:abs() should do a fine job.

And what's this stuff, anyway?

+typedef unsigned long uleb128_t;
+typedef   signed long sleb128_t;
+#define sleb128abs __builtin_labs

unsigned and signed little-endian 128-bit types?  Nope, they're 32-bit or
64-bit.   All very mysterious.
