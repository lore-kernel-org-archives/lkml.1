Return-Path: <linux-kernel-owner+w=401wt.eu-S934872AbZKYSEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934872AbZKYSEq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 13:04:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932179AbZKYSEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 13:04:45 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44554 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758829AbZKYSEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 13:04:44 -0500
Date: Wed, 25 Nov 2009 18:06:48 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 82/86] pata_via: clear UDMA transfer mode bit for PIO
 and MWDMA
Message-ID: <20091125180648.6ab19725@lxorguk.ukuu.org.uk>
In-Reply-To: <200911251858.38491.bzolnier@gmail.com>
References: <20091125170218.5446.13513.sendpatchset@localhost>
	<20091125171218.5446.41962.sendpatchset@localhost>
	<20091125175257.796afeb3@lxorguk.ukuu.org.uk>
	<200911251858.38491.bzolnier@gmail.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Do you really find such tidy patch hard to review?

When doing it at speed - yes.

>  	/* Set UDMA unless device is not UDMA capable */
> -	if (udma_type && t.udma) {
> -		u8 cable80_status;
> +	if (udma_type) {
> +		u8 udma_etc;

Ok that makes sense - we in fact could hit this case on a failure
changedown from UDMA to PIO.
