Return-Path: <linux-kernel-owner+w=401wt.eu-S1762725AbYBFME3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762725AbYBFME3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 07:04:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761899AbYBFMES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 07:04:18 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:40543 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761876AbYBFMER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 07:04:17 -0500
Message-ID: <47A9A23E.5060006@garzik.org>
Date: Wed, 06 Feb 2008 07:04:14 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] sata_nv: fix ATAPI issues with memory over 4GB (v7)
References: <47A7BE36.1010902@shaw.ca>
In-Reply-To: <47A7BE36.1010902@shaw.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> This fixes some problems with ATAPI devices on nForce4 controllers in ADMA mode
> on systems with memory located above 4GB. We need to delay setting the 64-bit
> DMA mask until the PRD table and padding buffer are allocated so that they don't
> get allocated above 4GB and break legacy mode (which is needed for ATAPI
> devices). Also, if either port is in ATAPI mode we need to set the DMA mask
> for the PCI device to 32-bit to ensure that the IOMMU code properly bounces
> requests above 4GB, as it appears setting the bounce limit does not guarantee
> that we will not try to map requests above this point.
> 
> Reported to fix https://bugzilla.redhat.com/show_bug.cgi?id=351451
> 
> Signed-off-by: Robert Hancock <hancockr@shaw.ca>

applied, though it can still be improved...  let's see if this sticks.


