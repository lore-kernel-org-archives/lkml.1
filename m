Return-Path: <linux-kernel-owner+w=401wt.eu-S1758076AbYAUXHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076AbYAUXHo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 18:07:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755581AbYAUXHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 18:07:37 -0500
Received: from gate.crashing.org ([63.228.1.57]:49083 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754976AbYAUXHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 18:07:36 -0500
Subject: Re: [i2c] [PATCH 19 3/5] Clean up error returns
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Jean Delvare <khali@linux-fr.org>
Cc: Jon Smirl <jonsmirl@gmail.com>, i2c@lm-sensors.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080121171025.524dc465@hyperion.delvare>
References: <20080112024737.7023.61680.stgit@terra.home>
	 <20080112024743.7023.23630.stgit@terra.home>
	 <20080120120730.06dd8a7f@hyperion.delvare>
	 <9e4733910801200718q7304bc29q38e67580613189e4@mail.gmail.com>
	 <9e4733910801200739x502d5407x85f0d950ace80bee@mail.gmail.com>
	 <20080121171025.524dc465@hyperion.delvare>
Content-Type: text/plain
Date: Tue, 22 Jan 2008 10:04:44 +1100
Message-Id: <1200956684.6807.14.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-01-21 at 17:10 +0100, Jean Delvare wrote:
> Hi Jon,
> 
> On Sun, 20 Jan 2008 10:39:43 -0500, Jon Smirl wrote:
> > Here' s a version with the compares to zero switched to NO_IRQ. If I
> > understand how NO_IRQ works it is the correct change. My understanding
> > is that under ppc IRQ zero was legal and NO_IRQ was -1. But then the
> > whole kernel switched to NO_IRQ = zero. Powerpc updated to NO_IRQ=0
> > and used virtual IRQs to move a physical IRQ 0 to another IRQ number.
> > ppc was not changed. This driver does not appear to have been updated
> > to track this global change since it didn't initially use the NO_IRQ
> > define everywhere.
> 
> As I have already applied the part of this patch that preserves error
> values in error paths, can you please send an incremental patch that
> only fixes the IRQ issues? These are separate issues so it's better to
> have separate patches anyway.

To be clear, nowadays, checking against 0 is correct unless you intend
the driver to work with arch/ppc (which we'll deprecate soon).

Ben.


