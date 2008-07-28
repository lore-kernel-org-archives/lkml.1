Return-Path: <linux-kernel-owner+w=401wt.eu-S1759444AbYG1BHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759444AbYG1BHo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 21:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752594AbYG1BHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 21:07:37 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52772
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752095AbYG1BHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 21:07:36 -0400
Date: Sun, 27 Jul 2008 18:07:36 -0700 (PDT)
Message-Id: <20080727.180736.74131389.davem@davemloft.net>
To: marcel@holtmann.org
Cc: linux-kernel@vger.kernel.org, sfr@canb.auug.org.au,
       linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, kkeil@suse.de
Subject: Re: mISDN still breaking the allmodconfig build...
From: David Miller <davem@davemloft.net>
In-Reply-To: <93120C4B-D2F4-4479-806B-2141AC3DC607@holtmann.org>
References: <20080727.170235.97056809.davem@davemloft.net>
	<93120C4B-D2F4-4479-806B-2141AC3DC607@holtmann.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcel Holtmann <marcel@holtmann.org>
Date: Mon, 28 Jul 2008 03:03:04 +0200

> > More fallout from the premature mISDN driver merge:
> >
> > drivers/isdn/hardware/mISDN/hfcmulti.c:5255:2: error: #error "not  
> > running on big endian machines now"
> 
> is that only the HFC driver or the whole mISDN stack?
> 
> I know that the two old ISDN stacks where really bad on big endian,  
> but my assumption was that we did sort this out in the end.

One of the two mISDN drivers uses the deprecated virt_to_bus()
interface for handling DMA addresses (that doesn't even work on many
x86 systems these days) and the other mISDN driver gives the above
big-endian compile time error.

In short, this driver was not ready for merging at all.
