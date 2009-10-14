Return-Path: <linux-kernel-owner+w=401wt.eu-S1756547AbZJNHHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547AbZJNHHX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 03:07:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756433AbZJNHHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 03:07:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:35312 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756411AbZJNHHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 03:07:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,556,1249282800"; 
   d="scan'208";a="559396664"
Subject: Re: [RFC 1/2] Unified UUID/GUID definition
From: Huang Ying <ying.huang@intel.com>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Steven Whitehouse <swhiteho@redhat.com>,
       Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1255503671.1851.43.camel@Joe-Laptop.home>
References: <1255501805.6047.1192.camel@yhuang-dev.sh.intel.com>
	 <1255503671.1851.43.camel@Joe-Laptop.home>
Content-Type: text/plain
Date: Wed, 14 Oct 2009 15:06:43 +0800
Message-Id: <1255504003.6047.1196.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-14 at 15:01 +0800, Joe Perches wrote: 
> On Wed, 2009-10-14 at 14:30 +0800, Huang Ying wrote:
> > There are many different UUID/GUID definitions in kernel, such as that
> > in EFI, many file systems, some drivers, etc. Every kernel components
> > need UUID/GUID has its own definition. This patch provides a unified
> > definition for UUID/GUID.
> > 
> > UUID is defined via typedef. This makes that UUID appears more like a
> > preliminary type, and makes the data type explicit (comparing with
> > implicit "u8 uuid[16]").
> > 
> > The binary representation of UUID/GUID can be little-endian (used by
> > EFI, etc) or big-endian (defined by RFC4122), so both is defined.
> []
> > +typedef struct {
> > +	__u8 b[16];
> > +} uuid_le;
> > +
> > +typedef struct {
> > +	__u8 b[16];
> > +} uuid_be;
> 
> I thought you originally suggested something like:
> 
> typedef union {
> 	u8 b[16];
> 	struct {
> 		__be32 time_low;
> 		__be16 time_mid;
> 		__be16 time_hi_and_version;
> 		u8 clock_seq_hi;
> 		u8 clock_seq_low;
> 		u8 node[6];
> 	} v1;
> } uuid_be;
> 
> typedef union {
> 	u8 b[16];
> 	struct {
> 		__le32 time_low;
> 		__le16 time_mid;
> 		__le16 time_hi_and_version;
> 		u8 clock_seq_hi;
> 		u8 clock_seq_low;
> 		u8 node[6];
> 	} v1;
> } uuid_le;

I just think the struct in union is of little use in kernel actually. I
only find that it is used in fs/afs for converting between little endian
and big endian and DEC version 1 style UUID generation. Both can be done
without the union (struct) definition.

Best Regards,
Huang Ying


