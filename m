Return-Path: <linux-kernel-owner+w=401wt.eu-S1761416AbXKAPdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761416AbXKAPdj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 11:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753924AbXKAPda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 11:33:30 -0400
Received: from smtp121.iad.emailsrvr.com ([207.97.245.121]:39927 "EHLO
	smtp121.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711AbXKAPd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 11:33:29 -0400
Message-ID: <4729F1BB.20306@gentoo.org>
Date: Thu, 01 Nov 2007 15:33:15 +0000
From: Daniel Drake <dsd@gentoo.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070805)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Jeff Garzik <jeff@garzik.org>, Jens Axboe <jens.axboe@oracle.com>,
       linux list <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Tejun Heo <htejun@gmail.com>, Albert Lee <albertcc@tw.ibm.com>
Subject: Re: "Fix ATAPI transfer lengths" causes CD writing regression
References: <47274A5F.6070409@gentoo.org>	<20071030153417.59b9182c@the-village.bc.nu>	<47276DCA.1000808@gentoo.org>	<20071030190153.373c9347@the-village.bc.nu>	<47278439.4030801@gentoo.org>	<20071031114958.210bd7cc@the-village.bc.nu>	<20071031115754.GK5059@kernel.dk>	<4729A0DF.20800@garzik.org>	<20071101105335.1f20bab3@the-village.bc.nu>	<4729B3EA.6040707@garzik.org> <20071101141501.3746cec2@the-village.bc.nu>
In-Reply-To: <20071101141501.3746cec2@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> Lots of *other* problems occur instead. Daniel is reporting that if he
> makes a stupid request to a buggy drive he gets a reset and the system
> continues happily. Even that reset being a reset not a new command issue
> is actually us being excessively paranoid.

Sorry if I'm sprouting nonsense here -- I don't have the knowledge that 
you all do. However, just wanted to point out that I looked up the info 
about that mode page in the MMC specs.

http://www.t10.org/ftp/t10/drafts/mmc4/mmc4r05a.pdf page 513.
"E.3.3 MM Capabilities and Mechanical Status Page (Page Code 2Ah)"

The length of this mode page varies from drive to drive, so there is no 
"one size" that you can supply to the SG_IO command (unless you want to 
use a stupidly large buffer) to retrieve all the data at once. Instead, 
as Tejun describes, you put a short read request in first, look at byte 
1 of the page which tells you the length, and then read the whole lot.

Again, ignore me if I'm not contributing anything useful, but I'm 
increasingly thinking that the SG_IO command block in question is 
perfectly valid, and doing a short read of the mode page in question 
(and probably others too) is in fact required before you can know its 
true size to do a full read anyway.

Thanks,
Daniel
