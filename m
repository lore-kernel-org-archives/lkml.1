Return-Path: <linux-kernel-owner+w=401wt.eu-S1752801AbZK3P1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801AbZK3P1u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 10:27:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbZK3P1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 10:27:46 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:34426 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbZK3P1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 10:27:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=k5/zB4MmiFP21GNCv5Q9BTicXFjHLMQQI8dHMYFS6Z2n7MV+J89NXMymAp7QC1hv16
         VnNwJSVGtIaouXqXNv54FnGv8Xq/s0H+3Y06zjiDvbRxDrLYEQrYsn80t1E+peW1U0v4
         WVl93HFw2RKbsDTpHdChN1OzqHSvjjIsqmIkA=
Subject: Re: [PATCH] mmc: add module parameter to set whether cards are
 assumed removable
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Pierre Ossman <pierre@ossman.eu>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Ben Hutchings <ben@decadent.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mmc@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, 504391@bugs.debian.org,
       Wouter van Heyst <larstiq@larstiq.dyndns.org>
In-Reply-To: <20091130135119.4bacade7@lxorguk.ukuu.org.uk>
References: <1257914676.2237.57.camel@localhost>
	 <20091116122329.847916b6.akpm@linux-foundation.org>
	 <1258410709.2792.9.camel@localhost> <4B02565C.1030406@s5r6.in-berlin.de>
	 <20091130133949.794fef00@mjolnir.ossman.eu>
	 <1259587966.13049.6.camel@maxim-laptop>
	 <20091130135119.4bacade7@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Nov 2009 17:27:46 +0200
Message-ID: <1259594866.13049.56.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-30 at 13:51 +0000, Alan Cox wrote: 
> > Before we do suspend, pick few random sectors from the media, run that
> > through some hash function, thus creating some sort of watermark.
> 
> Statistically speaking the chances are you'll catch zero sectors and
> lose. You'll also not detect the suspend, move to other box, use, put
> back error. That is one users make and we need to be at least vaguely
> robust against.
> 
> Hence you need the fs checking here.
> 
> Alan
I have to agree with you about that one.
An FS checking is really only solution.

Then I think such check can be added gradually to existing filesystems
(starting with fat), and allow these filesystems to persist across low
power states regardsless of CONFIG_$system_UNSAFE_RESUME

For fat, simple checksum of the 'fat' table will catch most attempts.
Also directory modification times can be compared, at least for root
directory.

Best regards,
Maxim Levitsky



