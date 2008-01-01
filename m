Return-Path: <linux-kernel-owner+w=401wt.eu-S1755454AbYAAQUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbYAAQUM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 11:20:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753955AbYAAQT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 11:19:59 -0500
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:20694 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753500AbYAAQT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 11:19:58 -0500
Message-ID: <477A6732.4010609@panasas.com>
Date: Tue, 01 Jan 2008 18:15:46 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: Andy Whitcroft <apw@shadowen.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: WARNING: do not add new typedefs - is that for real?
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Jan 2008 16:15:50.0590 (UTC) FILETIME=[9355C5E0:01C84C91]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have this code:

<c_code>
/* 
 * osd-r10 4.12.5 Data-In and Data-Out buffer offsets
 * byte offset = mantissa * (2^(exponent+8))
 */
typedef __be32 osd_cdb_offset;

osd_cdb_offset __osd_encode_offset(u64 offset, unsigned *padding,
	int min_shift, int max_shift);

struct osd_attributes_list_mode {
	__be32		get_attr_desc_bytes;
	osd_cdb_offset	get_attr_desc_offset;

	__be32		get_attr_alloc_length;
	osd_cdb_offset	get_attr_offset;

	__be32		set_attr_bytes;
	osd_cdb_offset	set_attr_offset;
	__be32 not_used;
};
</c_code>


the osd_cdb_offset above is this special OSD-standard floating-point-like
special type. It is of size 32 bit in special network order. What should
I do then:

__be32 __osd_encode_offset(u64 offset, unsigned *padding,
	int min_shift, int max_shift);

But it is not a __be32. It is this special floating-point-like thingy!!!?
How was __be32 defined with a #define???!!

Come on guys, it is not checkpatch.pl place to complain about good language
constructs that can be misused. This is the maintainers and reviewers
job to say that a: "typedef struct foo Foo;" is bad practice and we don't
like it, but it can not be left to a script. "typedef"s should be used
where they should be used.

Boaz
