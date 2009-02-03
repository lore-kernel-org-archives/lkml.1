Return-Path: <linux-kernel-owner+w=401wt.eu-S1753866AbZBCEAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbZBCEAh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 23:00:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbZBCEAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 23:00:19 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:53803 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041AbZBCEAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 23:00:17 -0500
Message-ID: <4987C133.60806@garzik.org>
Date: Mon, 02 Feb 2009 22:59:47 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Hugh Dickins <hugh@veritas.com>, Jeff Garzik <jgarzik@redhat.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.29-rc libata sff 32bit PIO regression
References: <Pine.LNX.4.64.0901211322010.15945@blonde.anvils> <20090126191151.18b094e6@lxorguk.ukuu.org.uk>
In-Reply-To: <20090126191151.18b094e6@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> [PATCH] libata sff: 32bit PIO use 16bit on slop
>>
>> 871af1210f13966ab911ed2166e4ab2ce775b99d libata: Add 32bit PIO support
>> causes errors on a four-year-old ata_piix Dell Precision 670.  Using
>> 16bit PIO instead of 32bit PIO on the odd 1, 2 or 3 chars fixes that.
>>
>> Signed-off-by: Hugh Dickins <hugh@veritas.com>
> 
> For the 3 bytes of slop it should use a single iowrite32 but otherwise
> that seems ok. We do need to handle the FIFO setup on the AMD differently
> if we do this - something like this:
> 
> pata_amd: Program FIFO
> 
> From: Alan Cox <alan@lxorguk.ukuu.org.uk>
> 
> With 32bit PIO we can use the posted write buffers, but only for 32bit I/O
> cycles. This means we must disable the FIFO for ATAPI where a final 16bit
> cycle may occur.
> 
> Rework the FIFO logic so that we disable the FIFO then selectively re-enable
> it when we set the timings on AMD devices. Also fix a case where we scribbled
> on PCI config 0x41 of Nvidia chips when we shouldn't.
> 
> Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
> ---
> 
>  drivers/ata/pata_amd.c |   78 +++++++++++++++++++++++++++++++++++++-----------
>  1 files changed, 60 insertions(+), 18 deletions(-)

tested and ok for -rc?


