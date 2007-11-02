Return-Path: <linux-kernel-owner+w=401wt.eu-S1759455AbXKBVUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759455AbXKBVUM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 17:20:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754060AbXKBVT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 17:19:57 -0400
Received: from smtp131.iad.emailsrvr.com ([207.97.245.131]:44362 "EHLO
	smtp131.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510AbXKBVT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 17:19:56 -0400
Message-ID: <472B946F.4030004@gentoo.org>
Date: Fri, 02 Nov 2007 21:19:43 +0000
From: Daniel Drake <dsd@gentoo.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070805)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       linux list <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Albert Lee <albertcc@tw.ibm.com>
Subject: Re: "Fix ATAPI transfer lengths" causes CD writing regression
References: <47274A5F.6070409@gentoo.org>	<20071030153417.59b9182c@the-village.bc.nu>	<47276DCA.1000808@gentoo.org>	<20071030190153.373c9347@the-village.bc.nu>	<47278439.4030801@gentoo.org>	<20071031114958.210bd7cc@the-village.bc.nu>	<20071031115754.GK5059@kernel.dk>	<4729A0DF.20800@garzik.org>	<20071101105335.1f20bab3@the-village.bc.nu>	<4729B3EA.6040707@garzik.org> <20071101141501.3746cec2@the-village.bc.nu> <4729F1BB.20306@gentoo.org> <4729F8F1.4040103@gmail.com>
In-Reply-To: <4729F8F1.4040103@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Yeap, the SG command is fine.  The drive is being weird tho.  The
> allocation length field says 10 bytes, so it should just have
> transferred 10 bytes without causing HSM violation.
> 
> Can you please apply the attached patch and report what the kernel says
> after triggering the error condition?

Thanks for looking at this, the kernel now says:

<4>ata2.00: HSM violation: eh_analyze_tf: BUSY|DRQ
<3>ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
<3>ata2.00: cmd a0/00:00:00:0a:00/00:00:00:00:00/a0 tag 0 cdb 0x5a data 
10 in
<4>         res 58/00:02:00:0a:00/00:00:00:00:00/a0 Emask 0x2 (HSM 
violation)
<3>ata2.00: status: { DRDY DRQ }
<6>ata2: soft resetting link
<6>ata2.00: configured for UDMA/33
<6>ata2: EH complete

Daniel
