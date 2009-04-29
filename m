Return-Path: <linux-kernel-owner+w=401wt.eu-S1755286AbZD2Loh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286AbZD2Loh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 07:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129AbZD2LoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 07:44:23 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:28981 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbZD2LoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 07:44:22 -0400
Subject: Re: btrfs BUG on creating huge sparse file
From: Chris Mason <chris.mason@oracle.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, hugh@veritas.com, npiggin@suse.de,
       riel@redhat.com, lee.schermerhorn@hp.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
       "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
In-Reply-To: <20090429082151.GA15170@localhost>
References: <20090407509.382219156@firstfloor.org>
	 <20090407151010.E72A91D0471@basil.firstfloor.org>
	 <1239210239.28688.15.camel@think.oraclecorp.com>
	 <20090409072949.GF14687@one.firstfloor.org>
	 <20090409075805.GG14687@one.firstfloor.org>
	 <1239283829.23150.34.camel@think.oraclecorp.com>
	 <20090409140257.GI14687@one.firstfloor.org>
	 <1239287859.23150.57.camel@think.oraclecorp.com>
	 <20090429081616.GA8339@localhost>  <20090429082151.GA15170@localhost>
Content-Type: text/plain
Date: Wed, 29 Apr 2009 07:40:22 -0400
Message-Id: <1241005222.19174.1.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt707.oracle.com [141.146.40.85]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.49F83CAB.034B:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-29 at 16:21 +0800, Wu Fengguang wrote:
> On Wed, Apr 29, 2009 at 04:16:16PM +0800, Wu Fengguang wrote:
> > On Thu, Apr 09, 2009 at 10:37:39AM -0400, Chris Mason wrote:
> [snip]
> > > PagePrivate is very common.  try_to_releasepage failing on a clean page
> > > without the writeback bit set and without dirty/locked buffers will be
> > > pretty rare.
> > 
> > Yup. btrfs seems to tag most(if not all) dirty pages with PG_private.
> > While ext4 won't.
> 
> Chris, I run into a btrfs BUG() when doing
> 
>         dd if=/dev/zero of=/b/sparse bs=1k count=1 seek=104857512345
> 
> The half created sparse file is
> 
>         -rw-r--r-- 1 root root 98T 2009-04-29 14:54 /b/sparse
>         Or
>         -rw-r--r-- 1 root root 107374092641280 2009-04-29 14:54 /b/sparse
> 
> Below is the kernel messages. I can test patches you throw at me :-)
> 

How big was the FS you were testing this on?  It works for me...

-chris


