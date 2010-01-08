Return-Path: <linux-kernel-owner+w=401wt.eu-S1753533Ab0AHPfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab0AHPfj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 10:35:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753442Ab0AHPfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 10:35:39 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:63423 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398Ab0AHPfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 10:35:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=hxTsZRhm6fsZEelVIACKvjQu0apgT64wtV+VDYtBRkFXPT49G6XEkccxUpuSBA9506
         1lgIyJDBJgmdaHAzZ0wFVhEAtWyDH+3K6S4SzIhOiTwaNTNSGsg5u+2qDn6GexBEMYaN
         DoNZYBAp/Wv85T/YXDTbQ7eDNyWRY8auqEDCI=
Subject: Re: [PATCH 9/9] mtd: Add new SmartMedia/xD FTL
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mtd <linux-mtd@lists.infradead.org>, Alex Dubov <oakad@yahoo.com>
In-Reply-To: <20100108152945.GC31872@logfs.org>
References: <1262963092.12577.14.camel@maxim-laptop>
	 <1262963524.12577.23.camel@maxim-laptop> <20100108152945.GC31872@logfs.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Jan 2010 17:35:31 +0200
Message-ID: <1262964931.12577.34.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-08 at 16:29 +0100, Jörn Engel wrote: 
> On Fri, 8 January 2010 17:12:04 +0200, Maxim Levitsky wrote:
> > 
> > This implements new readwrite SmartMedia/xd FTL.
> > 
> > It depends on nand driver to define proper oob layout that excludes
> > all ecc areas and nothing more.
> > 
> > Support for very old 256 byte/page devices is not yet enabled/complete.
> > For these devices, all ecc handling will be done inside this FTL
> > due to wierd oob layout.
> > 
> > Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> > ---
> >  drivers/mtd/Kconfig  |   12 +
> >  drivers/mtd/Makefile |    1 +
> >  drivers/mtd/sm_ftl.c | 1043 ++++++++++++++++++++++++++++++++++++++++++++++++++
> >  drivers/mtd/sm_ftl.h |   75 ++++
> 
> sm_ftl is certainly nicer than ssfdc.c - at least I can decrypt the
> acronym.  But I am missing a reason why ssfdc is not sufficient and we
> need yet another implementation of the same ftl.
ssfdc is readonly, and bulk of the hard work is the write part.
Also ssfdc creates one big table by reading oob of whole device and this
takes about 1 second here.
I instead defer this by doing it one per zone.

Ideally ssfdc can be deprecated/removed, since my driver is its
superset.
However if one needs only R/O support he can use the smaller and safer
ssfdc.c

I also though about patching the ssfdc.c, but really there will be
nothing old left after doing that.

Best regards,
Maxim Levitsky

