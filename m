Return-Path: <linux-kernel-owner+w=401wt.eu-S1752868AbZHXQwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbZHXQwv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 12:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752510AbZHXQwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 12:52:49 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:58439 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752482AbZHXQwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 12:52:49 -0400
Message-ID: <4A92C55F.6080506@garzik.org>
Date: Mon, 24 Aug 2009 12:52:47 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: John Stoffel <john@stoffel.org>
CC: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org, htejun@gmail.com, bzolnier@gmail.com,
       alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org
Subject: Re: [PATCH 4/7] libata: use lazy workqueues for the pio task
References: <1251100616-28604-1-git-send-email-jens.axboe@oracle.com>	<1251100616-28604-5-git-send-email-jens.axboe@oracle.com>	<4A92C081.50207@garzik.org> <19090.50074.62901.633104@stoffel.org>
In-Reply-To: <19090.50074.62901.633104@stoffel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2009 12:45 PM, John Stoffel wrote:
>>>>>> "Jeff" == Jeff Garzik<jeff@garzik.org>  writes:
> Jeff>  No objections to the code, operationally...
>
> Jeff>  But it is disappointing that the "1 thread on UP" problem is not
> Jeff>  solved while changing this libata area.  Is there no way to
> Jeff>  specify a minimum lazy-thread count?
>
> Jeff>  A key problem continues to be tying to the number of CPUs, which
> Jeff>  is quite inappropriate for libata.
>
> So should the minimum number be the NumATADisks on the system?  Actual
> or potential?  I've got a system with dual CPUs and two IDE disk, two
> SATA disks and two SCSI disks, plus two SCSI Tape drives.  All on
> seperate controllers... how would that work?

Technically speaking, the maximum is the number of PIO-polling devices.

Theoretically this can change with hotplugging, but that is _very_ rare 
-- mainly PATA+media bay situations, or bridged SATA with an ancient 
PATA device.

	Jeff




