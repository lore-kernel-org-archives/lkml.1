Return-Path: <linux-kernel-owner+w=401wt.eu-S1761007AbYCWLsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761007AbYCWLsg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 07:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754625AbYCWLs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 07:48:27 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:12423 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483AbYCWLs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 07:48:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=KH7VeCndBDMZFDhQ92jmP3RlAmnnfQ/awAl0jCzatAT/S5pJ8V2QxnYWnWE/k+vD/3GcodMxj37MVCwMYneMcRmVM41x3vbh90K2bgmQvyZvOnkPZPKydUhyunOB1A/+qGPkLwxO/AdlZ7mFKCuDDPpb1AvEn8Hjjv9cLWMktnU=
Date: Sun, 23 Mar 2008 14:47:43 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH] CDROM: use kmalloced buffers instead of buffers on
	stack
Message-ID: <20080323114743.GB7612@cvg>
References: <20080323111532.19DBFC2DFF@solo.franken.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080323111532.19DBFC2DFF@solo.franken.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Thomas Bogendoerfer - Sun, Mar 23, 2008 at 12:15:32PM +0100]
| If cdrom commands are issued to a scsi drive in most cases the buffer
| will be filled via dma. This leads to bad stack corruption on non coherent
| platforms, because the buffers are neither cache line aligned nor is
| the size a multiple of the cache line size. Using kmalloced buffers
| avoids this.
| 
| Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
| ---
| 
|  drivers/cdrom/cdrom.c |  274 ++++++++++++++++++++++++++++++++-----------------
|  1 files changed, 181 insertions(+), 93 deletions(-)
| 
[...]

Hi Thomas,

maybe would be better to use one memory pool instead?

		- Cyrill -
