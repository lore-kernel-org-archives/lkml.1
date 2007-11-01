Return-Path: <linux-kernel-owner+w=401wt.eu-S1756219AbXKAQHM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219AbXKAQHM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 12:07:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753179AbXKAQG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 12:06:59 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:35701 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160AbXKAQG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 12:06:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=H23h6DBxBgNRhwoDlOGl2knR0pjUOuq+mGXuVhpPuVswYMErJWSQJfJp8d39CRTyLqsjcjQXMCTPRpV/hQ71U2RfIIxBr9XSmccd9Uip41wEqt6HSKaUevCNB798tIDa6XInkf3tK+/023OPg3SwdNTQ/q9pGvqwuO9poL9L7B4=
Message-ID: <4729F996.4030701@gmail.com>
Date: Fri, 02 Nov 2007 01:06:46 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Daniel Drake <dsd@gentoo.org>, Jeff Garzik <jeff@garzik.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       linux list <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Albert Lee <albertcc@tw.ibm.com>
Subject: Re: "Fix ATAPI transfer lengths" causes CD writing regression
References: <47274A5F.6070409@gentoo.org>	<20071030153417.59b9182c@the-village.bc.nu>	<47276DCA.1000808@gentoo.org>	<20071030190153.373c9347@the-village.bc.nu>	<47278439.4030801@gentoo.org>	<20071031114958.210bd7cc@the-village.bc.nu>	<20071031115754.GK5059@kernel.dk>	<4729A0DF.20800@garzik.org>	<20071101105335.1f20bab3@the-village.bc.nu>	<4729B3EA.6040707@garzik.org>	<20071101141501.3746cec2@the-village.bc.nu>	<4729F1BB.20306@gentoo.org> <20071101155714.5d1f3b41@the-village.bc.nu>
In-Reply-To: <20071101155714.5d1f3b41@the-village.bc.nu>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> "one size" that you can supply to the SG_IO command (unless you want to 
>> use a stupidly large buffer) to retrieve all the data at once. Instead, 
>> as Tejun describes, you put a short read request in first, look at byte 
>> 1 of the page which tells you the length, and then read the whole lot.
> 
> ATAPI effectively requires you supply a stupidly large buffer. In theory
> you set the transfer size in the lba registers and it all works. In
> practice some drives ignore this and there isn't a nice reliable way to
> clean up.

The transfer size is specified in Allocation Length field inside CDB of
commands which can transfer variable length data.  I got confused about
this too but both the host and device know how much data can be transferred.

> Welcome to the wonderful world of IDE, where the spec sucks and the
> drives manage to do even worse things.
> 
> We can try and clean up better in these cases at least for PIO transfers
> by trying to drain the data beyond this point, on the controllers that
> cope with this but really - fix the app to reflect reality: ATAPI is SCSI
> as spoken by yokels

Not that I disagree to this point tho.  :-)

-- 
tejun
