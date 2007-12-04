Return-Path: <linux-kernel-owner+w=401wt.eu-S1754612AbXLDWRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612AbXLDWRY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 17:17:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751661AbXLDWRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 17:17:12 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:39266 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754094AbXLDWRL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 17:17:11 -0500
Message-ID: <4755D1E4.3020601@garzik.org>
Date: Tue, 04 Dec 2007 17:17:08 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] sata_nv: fix ADMA ATAPI issues with memory over 4GB (v3)
References: <47463534.9010100@shaw.ca>
In-Reply-To: <47463534.9010100@shaw.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> This fixes some problems with ATAPI devices on nForce4 controllers in ADMA mode
> on systems with memory located above 4GB. We need to delay setting the 64-bit
> DMA mask until the PRD table and padding buffer are allocated so that they don't
> get allocated above 4GB and break legacy mode (which is needed for ATAPI
> devices).
> 
> Signed-off-by: Robert Hancock <hancockr@shaw.ca>

This is a bit nasty :/

I would consider setting the consistent DMA mask to 32-bit, and setting 
the overall mask to 64-bit.

Seems like that would solve the problem?

Also, does this need to be rebased on top of what I just pushed upstream?

	Jeff



