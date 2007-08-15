Return-Path: <linux-kernel-owner+w=401wt.eu-S1765128AbXHOI4E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765128AbXHOI4E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 04:56:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757881AbXHOIzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 04:55:52 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:34146 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616AbXHOIzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 04:55:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZQQVpGXN2Y/dUW4N8a/OBc0gtBlHmQvmwaHcMSG9lyV/eqISXTwZCJUDmvPmy6BRTLg5Q8N8/t/k/gt+s2ZAlq4IN9fuPzlTsN1OHQu+h2XxyMcRTu5Drp/r7VWZc5wlE3h6W+HLFGRtk0U2t6NirOUDTjD5GoKSeJNftILxLGk=
Message-ID: <4e5ebad50708150155s5cd75a5bt813742b5a02d56d@mail.gmail.com>
Date: Wed, 15 Aug 2007 16:55:48 +0800
From: "Sonic Zhang" <sonic.adi@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH again] [libata] libata driver for bf548 on chip ATAPI controller.
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070814103013.6899813f@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1187056118.16255.1.camel@sevens.analog.com>
	 <4e5ebad50708131925k28d283f4k5057d0902ddc10ae@mail.gmail.com>
	 <20070814103013.6899813f@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/14/07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > +/**
> > + * Register transfer timing table
> > + */
>
> Libata has a complete set of transfer mode tables and timing functions -
> any reason for not using them ?
>

After a bit investigation, I find the timing paramters difined in
struct ata_timing are different from that in hardware manual of BF548.

struct ata_timing {
        unsigned short mode;            /* ATA mode */
        unsigned short setup;           /* t1 */
        unsigned short act8b;           /* t2 for 8-bit I/O */
        unsigned short rec8b;           /* t2i for 8-bit I/O */
        unsigned short cyc8b;           /* t0 for 8-bit I/O */
        unsigned short active;          /* t2 or tD */
        unsigned short recover;         /* t2i or tK */
        unsigned short cycle;           /* t0 */
        unsigned short udma;            /* t2CYCTYP/2 */
};


BF548 PIO timing registers:
        u8 teoc_reg;
        u8 t2_reg;

        u4 t4_reg;
        u8 t2_pio;
        u4 t1_reg;

        u8 teoc_pio;

BF548 UDMA timing registers:
        u8 tenv;
        u8 tack;

        u8 tcyc_tdvs;
        u8 tdvs;

        u8 tmli;
        u8 tss;

        u8 trp;
        u8 tzah;

I can't find a simple way to configure bf548 registers with the ata_timing data.
