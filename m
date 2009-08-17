Return-Path: <linux-kernel-owner+w=401wt.eu-S932227AbZHQRIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227AbZHQRIZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 13:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757108AbZHQRIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 13:08:25 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:55253 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755677AbZHQRIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 13:08:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tqx+kKMeqsnGpXD39rgg0l1CJsZGHMvn8jxkvFmmXh3u2nL/a36Xt8L1dG5Dulqu04
         pRPKtujktCvLzxEi2SD5xqk66TGSNa6KNynZ7d0kn4zBRL6wWQjlOcsYZYFloXnFXXBv
         DjBZs1aGvUW5QOUyDzWxlESaB6vQ4sorh89iI=
MIME-Version: 1.0
In-Reply-To: <4A898752.9000205@tmr.com>
References: <200908122007.43522.ngupta@vflare.org>
	 <1250344518.4159.4.camel@mulgrave.site>
	 <20090816150530.2bae6d1f@lxorguk.ukuu.org.uk>
	 <20090816083434.2ce69859@infradead.org>
	 <1250437927.3856.119.camel@mulgrave.site> <4A8834B6.2070104@rtr.ca>
	 <1250446047.3856.273.camel@mulgrave.site> <4A884D9C.3060603@rtr.ca>
	 <1250447052.3856.294.camel@mulgrave.site> <4A898752.9000205@tmr.com>
Date: Mon, 17 Aug 2009 13:08:23 -0400
Message-ID: <87f94c370908171008t44ff64ack2153e740128278e@mail.gmail.com>
Subject: Re: Discard support (was Re: [PATCH] swap: send callback when swap 
	slot is freed)
From: Greg Freemyer <greg.freemyer@gmail.com>
To: Bill Davidsen <davidsen@tmr.com>
Cc: James Bottomley <James.Bottomley@suse.de>, Mark Lord <liml@rtr.ca>,
       Arjan van de Ven <arjan@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Chris Worley <worleys@gmail.com>,
       Matthew Wilcox <matthew@wil.cx>, Bryan Donlan <bdonlan@gmail.com>,
       david@lang.hm, Markus Trippelsdorf <markus@trippelsdorf.de>,
       Matthew Wilcox <willy@linux.intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Nitin Gupta <ngupta@vflare.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, Linux RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All,

Seems like the high-level wrap-up of all this is:

There are hopes that highly efficient SSDs will appear on the market
that can leverage a passthru non-coalescing discard feature.  And that
a whitelist should be created to allow those SSDs to see discards
intermixed with the rest of the data i/o.

For the other known cases:

SSDs that meet the ata-8 spec, but don't exceed it
Enterprise SCSI
mdraid with SSD storage used to build raid5 / raid6 arrays

Non-coalescing is believed detrimental, but a regular flushing of the
unused blocks/sectors via a tool like Mark Lord has written should be
acceptable.

Mark, I don't believe your tool really addresses the mdraid situation,
do you agree.  ie. Since your bypassing most of the block stack,
mdraid has no way of snooping on / adjusting the discards you are
sending out.

Thus the 2 solutions that have been worked on already seem to address
the needs of everything but mdraid.

Also, there has been no discussion of dm based volumes.  (ie LVM2 based volumes)

For mdraid or dm it seems we need to enhance Mark's script to pass the
trim commands through the full block stack.  Mark, please cmiiw

Greg
