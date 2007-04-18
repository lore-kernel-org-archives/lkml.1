Return-Path: <linux-kernel-owner+w=401wt.eu-S2992485AbXDRUKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992485AbXDRUKx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 16:10:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992490AbXDRUKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 16:10:52 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56625
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S2992481AbXDRUKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 16:10:51 -0400
Date: Wed, 18 Apr 2007 13:10:54 -0700 (PDT)
Message-Id: <20070418.131054.70219428.davem@davemloft.net>
To: hch@infradead.org
Cc: andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, James.Bottomley@SteelEye.com,
       ema@debian.org
Subject: Re: Major qla2xxx regression on sparc64
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070418171346.GA16471@infradead.org>
References: <20070416.123743.07452378.davem@davemloft.net>
	<20070416200857.GH10822@andrew-vasquezs-computer.local>
	<20070418171346.GA16471@infradead.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@infradead.org>
Date: Wed, 18 Apr 2007 18:13:46 +0100

> Note that I expect Sun put in the invalid ROM intentionally, as we have
> similar cases with other cards that have totally messed up ROMs in
> Sun-branded versions.  Personally I think that's an utterly bad decision
> from Sun's side, but we'll have to live with this.

The way configuration paramters are provided on Sun systems is via
openfirmware properties, this is how they do everything and that is
why they never setup the NVRAMs on various chips.

This happens on PowerPC too.  One of many examples is determining the
clock parameters of the ATI Radeon graphics card, it's provided as an
openfirmware property not in some config area in the BIOS.

We can either be anti-social and _demand_ that these systems get their
NVRAMs fixed, which in reality will never happen and is totally
unreasonable, or we can say ok this is how we get the information we
need on these platforms we'll look for it there.
