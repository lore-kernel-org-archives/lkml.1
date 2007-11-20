Return-Path: <linux-kernel-owner+w=401wt.eu-S1761497AbXKTTfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761497AbXKTTfk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 14:35:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756466AbXKTTfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 14:35:30 -0500
Received: from accolon.hansenpartnership.com ([64.109.89.108]:41363 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756407AbXKTTf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 14:35:29 -0500
Subject: Re: SCSI breakage on non-cache coherent architectures
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: benh@kernel.crashing.org
Cc: David Miller <davem@davemloft.net>, Roland Dreier <rdreier@cisco.com>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       rmk@arm.linux.org.uk
In-Reply-To: <1195528497.6970.35.camel@pasglop>
References: <1195501874.6539.5.camel@pasglop>
	 <20071119.143115.251022325.davem@davemloft.net>
	 <1195518864.6970.23.camel@pasglop>
	 <20071119.164611.64664648.davem@davemloft.net>  <ada8x4ty8e1.fsf@cisco.com>
	 <1195528497.6970.35.camel@pasglop>
Content-Type: text/plain
Date: Tue, 20 Nov 2007 13:35:23 -0600
Message-Id: <1195587324.17601.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-11-20 at 14:14 +1100, Benjamin Herrenschmidt wrote:
> FYI, Here's what I have for the SCSI change. I haven't updated drivers
> to care for the new return code though, help appreciated with that as I
> don't know much about these drivers.

It looks to me like the return problem could be solved by passing in the
buffer to be used for sense; that way we can allocate it in hostdata at
init time for all the drivers and scsi_error can allocate and free a
page using GFP_KERNEL.

James


