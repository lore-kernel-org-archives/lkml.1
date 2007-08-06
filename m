Return-Path: <linux-kernel-owner+w=401wt.eu-S934202AbXHFXcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934202AbXHFXcB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 19:32:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934098AbXHFXbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 19:31:45 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:53591 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933963AbXHFXbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 19:31:40 -0400
Date: Mon, 06 Aug 2007 17:31:31 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Disk spin down issue on shut down/suspend to disk
In-reply-to: <fa.QgWcLG2hfRb92g4blN61qYfRjlQ@ifi.uio.no>
To: Tejun Heo <htejun@gmail.com>
Cc: Michael Sedkowski <sedmich@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-acpi@vger.kernel.org
Message-id: <46B7AF53.1040307@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <fa.bsWpbo79BZgHoaIGhEMfTEBxs54@ifi.uio.no>
 <fa.mg6p0itaOQUo/t8deCaYpyqj6Nk@ifi.uio.no>
 <fa.RxWYL8z8KktgL8LGZ/cTB2nI1Yc@ifi.uio.no>
 <fa.AyyCtZ2yLjC5noHPHtmzn4ffhhE@ifi.uio.no>
 <fa.SuAjism+m0z0haqCRVjkc2S978o@ifi.uio.no>
 <fa.QgWcLG2hfRb92g4blN61qYfRjlQ@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Michael Sedkowski wrote:
>>> Hmmm... If the problem only shows up on nx6325, it might be that ACPI is
>>> pulling unnecessary stunt.  Please apply the attached patch and report
>>> when the disk spins down and up.
>> Disk spins down on "Pre-shutdown prepare" and then goes up and down on
>> "Power down".
> 
> Oh... crap, so acpi wants to sync cache on shutdown.  I wonder whether
> it spins down the disk correctly.  Does emergency unload count increase
> after each power down?  Also, please post the result of 'dmidecode'.

I know that my Compaq X1000-series laptop does do some kind of ACPI 
games with the disk on ACPI power off (I assume it is putting the disk 
in standby before power-off at least). It also does this if you boot 
into DOS, GRUB, etc. and then hit the power button. Could be if the disk 
is dumb enough to spin up for sync cache and standby when there is 
nothing to flush, and the kernel does its own standby, this could cause 
an extra spinup/down..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

