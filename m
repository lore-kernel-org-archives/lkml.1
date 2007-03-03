Return-Path: <linux-kernel-owner+w=401wt.eu-S2992775AbXCBXua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992775AbXCBXua (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 18:50:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992773AbXCBXua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 18:50:30 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:37262 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992772AbXCBXu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 18:50:29 -0500
Date: Sat, 3 Mar 2007 00:54:33 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] libata: warn if speed limited due to 40-wire cable (v2)
Message-ID: <20070303005433.714d75ad@lxorguk.ukuu.org.uk>
In-Reply-To: <45E8B42E.7010900@garzik.org>
References: <45DA44B4.6000209@shaw.ca>
	<45E8B42E.7010900@garzik.org>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> it seems broken to manipulate xfer_mask after returning from the 
> driver's ->mode_filter hook.
> 
> this patch is more than just a speed-limited warning printk, afaics

I actually suggested that order because the only way the printk can be
done correctly is for it to be the very last test made. Since the mode
filter is not told what mode will be used but just subtracts modes that
are not allowed this should be safe.

I don't otherwise see how we deal with the case where a 40wire cable is
used and the mode filter function decides itself to drop to UDMA33 or
lower due to incompatibilities or errata.

Alan
