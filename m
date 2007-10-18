Return-Path: <linux-kernel-owner+w=401wt.eu-S932836AbXJRWun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932836AbXJRWun (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 18:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759682AbXJRWuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 18:50:25 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:5727 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbXJRWuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 18:50:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=G+v72Qdwr5TMDB5WKQKnOoAVHVn0FQmkA5od+cMxUtKSBKZC+ehm1HzXGqaG/3WWKaAyYSqOozDy6L/WrXC8X8gR9WgdviG/pwqUoy9C2acqNSVqWmQDjI7eUMwKJgqwlD7XL8GFHXPY0/i+mpXs8GHBMT5mWnhBoja8k+6Hbag=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 0/3] ide: Fix use of paired device
Date: Thu, 18 Oct 2007 22:29:02 +0200
User-Agent: KMail/1.9.7
Cc: Linux IDE <linux-ide@vger.kernel.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>
References: <1192668978.21882.719539599813.qpush@grosgo>
In-Reply-To: <1192668978.21882.719539599813.qpush@grosgo>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710182229.03294.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 October 2007, Benjamin Herrenschmidt wrote:
> At least 2 drivers (siimage and cs5535) have a bug where they use
> the construct:
> 
> 	ide_drive_t *pair	= &hwif->drives[drive->dn ^ 1];
> 
> To access the other drive in a master/slave pair. This is bogus
> because drive->dn is not the unit number, but the global drive
> number, thus can be 2 & 3 for ide1, 4 & 5 for ide2 etc...
> 
> This causes the driver to access beyond the drive array into lalaland
> for any other interface than ide0 and in some case, actually crash :-)
> 
> These 3 patches fix those by introducing a ide_get_paired_drive()
> helper that does the right thing and then using it.
> 
> Please apply to 2.6.24 if no objection.

Thanks for debugging and fixing this!

All three patches applied.

Bart
