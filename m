Return-Path: <linux-kernel-owner+w=401wt.eu-S1759870AbZCYOza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759870AbZCYOza (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 10:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756715AbZCYOzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 10:55:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:49245 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756454AbZCYOzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 10:55:11 -0400
Date: Wed, 25 Mar 2009 15:55:07 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: Add support for the OpenCores 10/100 Mbps
	Ethernet MAC.
Message-ID: <20090325145507.GC11710@avionic-design.de>
References: <1237889923-32257-1-git-send-email-thierry.reding@avionic-design.de> <20090324120157.GB6859@ports.donpac.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324120157.GB6859@ports.donpac.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Provags-ID: V01U2FsdGVkX18jN0gn1Afe4UqKSEVYm2BDq1wg9QpmrVVy1i/
 Zhb7uAzefhST49IAK7SkvwUQeIFNOPP0FN+Fei/HAhloF0cLsA
 6o9PBd5/cMvsKDfB9gUzA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrey Panin wrote:
> On 083, 03 24, 2009 at 11:18:43AM +0100, Thierry Reding wrote:
[snip]
> > +static int ethoc_get_multicast_bit(struct dev_mc_list *mc)
> > +{
> > +	u32 crc = 0xffffffff;
> > +	u32 carry;
> > +	int i, j;
> > +
> > +	for (i = 0; i < mc->dmi_addrlen; i++) {
> > +		u8 byte = mc->dmi_addr[i];
> > +
> > +		for (j = 0; j < 8; j++) {
> > +			carry = ((crc & 0x80000000) ? 1 : 0) ^ (byte & 0x1);
> > +			byte >>= 1;
> > +			crc <<= 1;
> > +
> > +			if (carry)
> > +				crc = (crc ^ 0x04c11db6) | carry;
> > +		}
> > +	}
> 
> This looks like yet another crc32 implementation, consider using ether_crc_le()
[snip]

Yes, ether_crc() does the trick. See follow-up patch. Thanks.

Cheers,
Thierry

