Return-Path: <linux-kernel-owner+w=401wt.eu-S1756365AbZJNHBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756365AbZJNHBu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 03:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755942AbZJNHBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 03:01:50 -0400
Received: from mail.perches.com ([173.55.12.10]:2141 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754817AbZJNHBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 03:01:49 -0400
Subject: Re: [RFC 1/2] Unified UUID/GUID definition
From: Joe Perches <joe@perches.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Steven Whitehouse <swhiteho@redhat.com>,
       Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1255501805.6047.1192.camel@yhuang-dev.sh.intel.com>
References: <1255501805.6047.1192.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Oct 2009 00:01:11 -0700
Message-Id: <1255503671.1851.43.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-14 at 14:30 +0800, Huang Ying wrote:
> There are many different UUID/GUID definitions in kernel, such as that
> in EFI, many file systems, some drivers, etc. Every kernel components
> need UUID/GUID has its own definition. This patch provides a unified
> definition for UUID/GUID.
> 
> UUID is defined via typedef. This makes that UUID appears more like a
> preliminary type, and makes the data type explicit (comparing with
> implicit "u8 uuid[16]").
> 
> The binary representation of UUID/GUID can be little-endian (used by
> EFI, etc) or big-endian (defined by RFC4122), so both is defined.
[]
> +typedef struct {
> +	__u8 b[16];
> +} uuid_le;
> +
> +typedef struct {
> +	__u8 b[16];
> +} uuid_be;

I thought you originally suggested something like:

typedef union {
	u8 b[16];
	struct {
		__be32 time_low;
		__be16 time_mid;
		__be16 time_hi_and_version;
		u8 clock_seq_hi;
		u8 clock_seq_low;
		u8 node[6];
	} v1;
} uuid_be;

typedef union {
	u8 b[16];
	struct {
		__le32 time_low;
		__le16 time_mid;
		__le16 time_hi_and_version;
		u8 clock_seq_hi;
		u8 clock_seq_low;
		u8 node[6];
	} v1;
} uuid_le;


