Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753261AbYLQVnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbYLQVnd (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 16:43:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbYLQVnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 16:43:15 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:64476 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbYLQVnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 16:43:13 -0500
Subject: Re: Notes on support for multiple devices for a single filesystem
From: Chris Mason <chris.mason@oracle.com>
To: Andreas Dilger <adilger@sun.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, sfr@canb.auug.org.au,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
In-Reply-To: <20081217212409.GB5000@webber.adilger.int>
References: <1227183484.6161.17.camel@think.oraclecorp.com>
	 <1228962896.21376.11.camel@think.oraclecorp.com>
	 <20081211141436.030c2d65.sfr@canb.auug.org.au>
	 <20081210200604.8e190b0d.akpm@linux-foundation.org>
	 <1229006596.22236.46.camel@think.oraclecorp.com>
	 <20081215210323.GB5000@webber.adilger.int>
	 <20081217132343.GA14695@infradead.org>
	 <20081217115325.3312858a.akpm@linux-foundation.org>
	 <1229547485.27170.77.camel@think.oraclecorp.com>
	 <20081217212409.GB5000@webber.adilger.int>
Content-Type: text/plain
Date: Wed, 17 Dec 2008 16:41:58 -0500
Message-Id: <1229550118.27170.103.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4949722A.0025:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-17 at 14:24 -0700, Andreas Dilger wrote:

> I can't speak for btrfs, but I don't think multiple device access from
> the filesystem is a "layering violation" as some people comment.  It
> is
> just a different type of layering.  With ZFS there is a distinct layer
> that is handling the allocation, redundancy, and transactions (SPA,
> DMU)
> that is exporting an object interface, and the filesystem (ZPL, or
> future
> versions of Lustre) is built on top of that object interface.

Clean interfaces aren't really my best talent, but btrfs also layers
this out.  logical->physical mappings happen in a centralized function,
and all of the on disk structures use logical block numbers.

The only exception to that rule is the superblock offsets on the device.

-chris


