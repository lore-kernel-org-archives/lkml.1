Return-Path: <linux-kernel-owner+w=401wt.eu-S1758345AbZAMN4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758345AbZAMN4W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 08:56:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751211AbZAMN4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 08:56:05 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44253 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751163AbZAMN4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 08:56:03 -0500
Date: Tue, 13 Jan 2009 13:55:26 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Benny Halevy <bhalevy@panasas.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>,
       open-osd development <osd-dev@open-osd.org>,
       Avishay Traeger <avishay@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [osd-dev] [PATCH 1/9] exofs: osd Swiss army knife
Message-ID: <20090113135526.28730314@lxorguk.ukuu.org.uk>
In-Reply-To: <4964CEA4.7080001@panasas.com>
References: <4947BFAA.4030208@panasas.com>
	<4947C624.3050602@panasas.com>
	<4964CEA4.7080001@panasas.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +#define EXOFS_SUPER_ID	0x10000	/* object ID for on-disk superblock */

And if an OS failure breaks the super block and you have only one how do
you recover it ?

> > +#define EXOFS_BM_ID	0x10001	/* object ID for ID bitmap */
> > +#define EXOFS_ROOT_ID	0x10002	/* object ID for root directory */
> > +#define EXOFS_TEST_ID	0x10003	/* object ID for test object */

Ditto some of the others

> > +	EXOFS_UINT64_MAX = (~0LL),
> > +	EXOFS_MAX_INO_ID = (sizeof(ino_t) * 8 == 64) ? EXOFS_UINT64_MAX :
> > +					(1LL << (sizeof(ino_t) * 8 - 1)),

Ok so thats quite a big number

> > +	uint32_t  s_nextid;	/* Highest object ID used */

but that is a smaller one

> > +	uint32_t  s_numfiles;	/* Number of files on fs */

as is this

> > +	uint32_t  i_atime;        	/* Access time */
> > +	uint32_t  i_ctime;        	/* Creation time */
> > +	uint32_t  i_mtime;        	/* Modification time */

2038 ? - bits are cheap

