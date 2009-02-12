Return-Path: <linux-kernel-owner+w=401wt.eu-S1758487AbZBLPs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758487AbZBLPs7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 10:48:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750970AbZBLPsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 10:48:46 -0500
Received: from smtp3.ultrahosting.com ([74.213.175.254]:41246 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750742AbZBLPsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 10:48:45 -0500
Date: Thu, 12 Feb 2009 10:25:20 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Andi Kleen <andi@firstfloor.org>,
       Matthew Wilcox <matthew@wil.cx>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>, matthew.r.wilcox@intel.com,
       chinang.ma@intel.com, linux-kernel@vger.kernel.org,
       sharad.c.tripathi@intel.com, arjan@linux.intel.com,
       suresh.b.siddha@intel.com, harita.chilukuri@intel.com,
       douglas.w.styner@intel.com, peter.xihong.wang@intel.com,
       hubert.nueckel@intel.com, chris.mason@oracle.com, srostedt@redhat.com,
       linux-scsi@vger.kernel.org, andrew.vasquez@qlogic.com,
       anirban.chakraborty@qlogic.com, Ingo Molnar <mingo@elte.hu>
Subject: Re: Mainline kernel OLTP performance update
In-Reply-To: <1234417660.2604.391.camel@ymzhang>
Message-ID: <alpine.DEB.1.10.0902121022450.3559@qirst.com>
References: <BC02C49EEB98354DBA7F5DD76F2A9E800317003CB0@azsmsx501.amr.corp.intel.com>  <1232616517.11429.129.camel@ymzhang>  <1232617672.14549.25.camel@penberg-laptop>  <1232679773.11429.155.camel@ymzhang> <4979692B.3050703@cs.helsinki.fi> 
 <1232697998.6094.17.camel@penberg-laptop>  <1232699401.11429.163.camel@ymzhang>  <1232703989.6094.29.camel@penberg-laptop>  <alpine.DEB.1.10.0901231020030.21692@qirst.com>  <1232765728.11429.193.camel@ymzhang>  <84144f020901232336v71687223y2fb21ee081c7517f@mail.gmail.com>
  <1234416153.2604.387.camel@ymzhang> <1234417660.2604.391.camel@ymzhang>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-716562517-1241989607-1234452320=:3559"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---716562517-1241989607-1234452320=:3559
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Thu, 12 Feb 2009, Zhang, Yanmin wrote:

> =EF=BB=BFThe default order of =EF=BB=BFkmalloc-8192 on 2*4 stoakley is an=
 issue of calculate_order.
>
>
> slab_size       order           name
> -------------------------------------------------
> 4096            3               sgpool-128
> 8192            2               kmalloc-8192
> 16384           3               kmalloc-16384
>
> =EF=BB=BFkmalloc-8192's default order is smaller than =EF=BB=BFsgpool-128=
's.

You reverted the page allocator passthrough patch before this right?
Otherwise kmalloc-8192 should not exist and allocation calls for 8192
bytes would be converted inline to request of an order 1 page from the
page allocator.
---716562517-1241989607-1234452320=:3559--
