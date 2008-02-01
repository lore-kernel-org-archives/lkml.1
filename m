Return-Path: <linux-kernel-owner+w=401wt.eu-S1760744AbYBAR2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760744AbYBAR2r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 12:28:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756776AbYBAR2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 12:28:38 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:55422 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756705AbYBAR2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 12:28:37 -0500
Message-ID: <47A356C3.3010904@garzik.org>
Date: Fri, 01 Feb 2008 12:28:35 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: IDE/ATA development list <linux-ide@vger.kernel.org>,
       Mark Lord <liml@rtr.ca>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH #upstream] libata: implement libata.force module parameter
References: <47A3375F.80101@gmail.com>
In-Reply-To: <47A3375F.80101@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> This patch implements libata.force module parameter which can
> selectively override ATA port, link and device configurations
> including cable type, SATA PHY SPD limit, transfer mode and NCQ.
> 
> For example, you can say "use 1.5Gbps for all fan-out ports attached
> to the second port but allow 3.0Gbps for the PMP device itself, oh,
> the device attached to the third fan-out port chokes on NCQ and
> shouldn't go over UDMA4" by the following.
> 
>  libata.force=2:1.5g,2.15:3.0g,2.03:noncq,udma4
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> ---
> I guess it's about time we add something like this.  More than
> anything else this should help debugging and can serve as a last
> resort to work around problems.
> 
> Thanks.
> 
>  Documentation/kernel-parameters.txt |   35 +++
>  drivers/ata/libata-core.c           |  375 +++++++++++++++++++++++++++++++++++-
>  drivers/ata/libata-eh.c             |    8 
>  drivers/ata/libata.h                |    1 
>  4 files changed, 415 insertions(+), 4 deletions(-)

ACK, but it breaks the build due to section type conflicts:

drivers/ata/libata-core.c:108: error: ata_force_param_buf causes a 
section type conflict

Given that the data is marked __initdata and the code is marked __init, 
I cannot see the problem.

