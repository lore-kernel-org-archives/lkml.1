Return-Path: <linux-kernel-owner+w=401wt.eu-S1753852AbZLROK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852AbZLROK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 09:10:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753820AbZLROKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 09:10:23 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:63078 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813AbZLROKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 09:10:20 -0500
Date: Fri, 18 Dec 2009 09:10:03 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: sniper <s3c24xx@gmail.com>,
       "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Re: [PATCH] btrfs: Simplify offset calculation method for
 ctree.h
Message-ID: <20091218141003.GB3202@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Zhaolei <zhaolei@cn.fujitsu.com>, sniper <s3c24xx@gmail.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <4B2ADB4C.7010900@cn.fujitsu.com>
 <9bd6b5360912172039y432361fu243d0f05bf75b7b7@mail.gmail.com>
 <4B2B1852.6080105@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B2B1852.6080105@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4B2B8D44.0073:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 18, 2009 at 01:51:14PM +0800, Zhaolei wrote:
> sniper wrote:
> > No, many pointers in btrfs function arguments are not pointing to an
> > absolute address, but relative to the start address of extent.
> > Take following function as example, argument inode_item is an offset
> > value to the beginning of leaf. So we can't reach its member with
> > &inode_item->xxx
> 
> Notice that we are not reach its member, we are getting pointer of its
> member with &inode_item->mtime.
> This operation have same effect as old one.

It relies on gcc doing something specific with the pointer address
manipulation while the original code makes it clear we're just taking
the offset.  We do rely on gcc being gcc in lots of places in the code,
but in this case I prefer the offsetof.

-chris
