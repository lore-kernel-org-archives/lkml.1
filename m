Return-Path: <linux-kernel-owner+w=401wt.eu-S1753997AbXLFDvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbXLFDvl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 22:51:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbXLFDve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 22:51:34 -0500
Received: from wr-out-0506.google.com ([64.233.184.232]:57657 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbXLFDvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 22:51:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=GQc3o6bUmavWz+H8rC7bTY9NBHilg3QM0ne2mUoX8a1cx9Yjtvh6GBiRI6N8EMiUZmgh6MbvYYr4sboWZDHW7bArpAhU5nNeRTfed4BvrmjrCcpNMN38qpv5GkWT+WEUEIsTeac0qqwWVsjXfeLrYI2JzUcKWTEupsZoQ/2UM+s=
Message-ID: <9c9fda240712051951w28aae15dle08279f8cc329e95@mail.gmail.com>
Date: Thu, 6 Dec 2007 12:51:31 +0900
From: "Kyungmin Park" <kmpark@infradead.org>
To: "Jared Hulbert" <jaredeh@gmail.com>
Subject: Re: solid state drive access and context switching
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Chris Friesen" <cfriesen@nortel.com>, linux-kernel@vger.kernel.org
In-Reply-To: <6934efce0712051401x2b137420hb04f971e1ca2cbf6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47548BF4.3010907@nortel.com>
	 <20071203230629.725f4c7a@the-village.bc.nu>
	 <6934efce0712040954v74cf0b4bk19b49988bc828233@mail.gmail.com>
	 <20071204203536.2bf6d025@the-village.bc.nu>
	 <6934efce0712041354n47c11d6ckbc7f4aa1e7c85f@mail.gmail.com>
	 <20071204232449.6148e152@the-village.bc.nu>
	 <6934efce0712041608w2e25587n6b2d738fa0265d9d@mail.gmail.com>
	 <20071205002454.52ea755c@the-village.bc.nu>
	 <6934efce0712051401x2b137420hb04f971e1ca2cbf6@mail.gmail.com>
X-Google-Sender-Auth: 471eca0eb49e0b6d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Dec 6, 2007 7:01 AM, Jared Hulbert <jaredeh@gmail.com> wrote:
> > Probably about 1000 clocks but its always going to depend upon the
> > workload and whether any other work can be done usefully.
>
> Yeah.  Sounds right, in the microsecond range.  Be interesting to see data.
>
> Anybody have ideas on what kind of experiments could confirm this
> estimate is right?

Is it the right place to write synchronously?
Now only concern the SATA.

Thank you,
Kyungmin Park

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 3b927be..cce0618 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -3221,6 +3221,13 @@ static inline void __generic_make_request(struct bio *bio
        if (bio_check_eod(bio, nr_sectors))
                goto end_io;

+#if 1
+       /* FIXME simple hack */
+       if (MAJOR(bio->bi_bdev->bd_dev) == 8 && bio_data_dir(bio) == WRITE) {
+               /* WRITE_SYNC */
+               bio->bi_rw |= (1 << BIO_RW_SYNC);
+       }
+#endif
        /*
         * Resolve the mapping until finished. (drivers are
         * still free to implement/resolve their own stacking
