Return-Path: <linux-kernel-owner+w=401wt.eu-S1762236AbXK2KG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762236AbXK2KG6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 05:06:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757696AbXK2KGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 05:06:51 -0500
Received: from hellhawk.shadowen.org ([80.68.90.175]:1908 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756508AbXK2KGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 05:06:50 -0500
Date: Thu, 29 Nov 2007 10:05:56 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: rdunlap@xenotime.net, jschopp@austin.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: bug in checkpath.pl
Message-ID: <20071129100548.GB28451@shadowen.org>
References: <200711281207.38252.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711281207.38252.hs4233@mail.mn-solutions.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2007 at 12:07:38PM +0100, Holger Schurig wrote:
> I have a case where scripts/checkpatch.pl returns a false error. 
> First, here is the code:
> 
> 
> static int lbs_scan_add_rates_tlv(u8 *tlv)
> {
> 	int i;
> 	struct mrvlietypes_ratesparamset *rate_tlv =
> 		(struct mrvlietypes_ratesparamset *) tlv;
> 
> 	rate_tlv->header.type = cpu_to_le16(TLV_TYPE_RATES);
> 	tlv += sizeof(rate_tlv->header);
> 	for (i = 0; i < MAX_RATES; i++) {
> 		*tlv = lbs_bg_rates[i];
> 		if (*tlv == 0)
> 			break;
> 		if (*tlv == 0x02 || *tlv == 0x04 ||
> 		    *tlv == 0x0b || *tlv == 0x16)
> 			*tlv |= 0x80;
> 		tlv++;
> 	}
> 	rate_tlv->header.len = i;
> 	return sizeof(rate_tlv->header) + i;
> }
> 
> 
> And here the error from checkpatch.pl:
> 
> ERROR: need consistent spacing around '*' (ctx:WxV)
> #553: FILE: drivers/net/wireless/libertas/scan.c:438:
> +                       *tlv |= 0x80;
> 
> 
> 
> This error seems wrong, tlv is a pointer to some u8 value
> (a.k.a. unsigned char), and it is very well allowed to
> operate on it via *variablename |= 0x80;

Yes that would be wrong.  I believe that this is fixed in the latest
versions.  0.12 should have the fix for this, and it seems to work in
the latest development snapshot.  Can you try the 0.12 and next from the
URL below for me.

    http://www.kernel.org/pub/linux/kernel/people/apw/checkpatch/

-apw
