Return-Path: <linux-kernel-owner+w=401wt.eu-S1755768AbYLWKKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768AbYLWKKg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 05:10:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752624AbYLWKK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 05:10:26 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34618 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752330AbYLWKKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 05:10:25 -0500
Date: Tue, 23 Dec 2008 10:10:33 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tejun Heo <tj@kernel.org>
Cc: Robert Hancock <hancockr@shaw.ca>, ide <linux-ide@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sata_sil: add Large Block Transfer support
Message-ID: <20081223101033.70c74ec7@lxorguk.ukuu.org.uk>
In-Reply-To: <49506BBC.8040600@kernel.org>
References: <4945BDED.7050205@shaw.ca>
	<494F69C4.2060708@kernel.org>
	<49506AAF.3040400@shaw.ca>
	<49506BBC.8040600@kernel.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > We know the register's always MMIO on this controller, so it's slightly
> > more optimal to avoid the conditional in there.
> 
> Yeah, by a small margin but I think the consensus was to use
> ioread/write no matter what if it's mapped using iomap.  I don't think
> we guarantee iomapped address == mmio address after all.

This was discussed before - using writel/readl on iomap is wrong. It may
happen to work on some platforms but shouldn't be expected to work on all.
