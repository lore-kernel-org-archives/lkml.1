Return-Path: <linux-kernel-owner+w=401wt.eu-S1755737AbYFDPEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737AbYFDPEs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 11:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760632AbYFDPEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 11:04:34 -0400
Received: from po-out-1718.google.com ([72.14.252.158]:16555 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760205AbYFDPEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 11:04:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=EZFGYfiyJ15XGBPh4WSKHYUPc2DI2gF3VpRVEe2R89EJatvGUO9xSS48tWsI8KIsal
         wD6lerTY2qwT7+0ebjJlNx0YvU9W17AOpYBK/lPPlquxkMvPiId4n+w4DXLvan9gdppH
         qB3Xd1DaJY9CMt5j8Pqjdno43eNh8ANtjsOa0=
Message-ID: <961aa3350806040804g72c85ca3ide63ab2b0074ccf2@mail.gmail.com>
Date: Thu, 5 Jun 2008 00:04:32 +0900
From: "Akinobu Mita" <akinobu.mita@gmail.com>
To: "Harvey Harrison" <harvey.harrison@gmail.com>
Subject: Re: [PATCH 1/2] lib: export bitrev16
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Marcel Holtmann" <marcel@holtmann.org>
In-Reply-To: <1212517160.11008.59.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1212517160.11008.59.camel@brick>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> --- a/lib/bitrev.c
> +++ b/lib/bitrev.c
> @@ -42,10 +42,11 @@ const u8 byte_rev_table[256] = {
>  };
>  EXPORT_SYMBOL_GPL(byte_rev_table);
>
> -static __always_inline u16 bitrev16(u16 x)
> +u16 bitrev16(u16 x)
>  {
>        return (bitrev8(x & 0xff) << 8) | bitrev8(x >> 8);
>  }
> +EXPORT_SYMBOL(bitrev16);

How about just moving bitrev16() from lib/bitrev.c to include/linux/bitrev.h
with s/__always_inline/inline/ rather than making it export symbol?
