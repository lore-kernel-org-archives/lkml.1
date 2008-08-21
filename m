Return-Path: <linux-kernel-owner+w=401wt.eu-S1754671AbYHUMYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671AbYHUMYp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 08:24:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752746AbYHUMYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 08:24:35 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:59871 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbYHUMYf convert rfc822-to-8bit (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 08:24:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: jaredeh@gmail.com
Subject: Re: [PATCH 03/10] AXFS: axfs.h
Date: Thu, 21 Aug 2008 14:24:31 +0200
User-Agent: KMail/1.9.9
Cc: Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       =?iso-8859-1?q?J=F6rn_Engel?= <joern@logfs.org>, tim.bird@am.sony.com,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
References: <48AD00E6.2070505@gmail.com>
In-Reply-To: <48AD00E6.2070505@gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808211424.31966.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/xhmE907W48AafEeO7mfSPQ2rrN4hrVY7mzmT
 GkTQyUb9fxE9NZeDNHAG95pz6F39/cvUQD2H7TQal4oGcOylqj
 FOddOYMGd/R2GAaMAc0Tg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 August 2008, Jared Hulbert wrote:
> +static inline u64 axfs_bytetable_stitch(u8 depth, u8 *table, u64 index)
> +{
> +       u64 i;
> +       u64 output = 0;
> +       u64 byte = 0;
> +       u64 j;
> +       u64 bits;
> +
> +       for (i = 0; i < depth; i++) {
> +               j = index * depth + i;
> +               bits = 8 * (depth - i - 1);
> +               byte = table[j];
> +               output += byte << bits;
> +       }
> +       return output;
> +}
> +
> +#define AXFS_GET_BYTETABLE_VAL(desc,index) \
> +  axfs_bytetable_stitch(((struct axfs_region_desc)(desc)).table_byte_depth,\
> +  (u8 *)((struct axfs_region_desc)(desc)).virt_addr, index)
> +

This bytetable stuff looks overly complicated, both the data structure and
the access method. It seems like you are implementing your own custom Huffman
compression with this.

Is the reasonn for the bytetable just to pack numbers efficiently, or do you
have a different intention?

Did you see a significant size benefit over simply storing all metadata as
uncompressed data structures like in cramfs?

Have you considered storing simple dentry/inode data in node_type==Compressed
nodes?

	Arnd <><
