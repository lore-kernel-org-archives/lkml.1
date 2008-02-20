Return-Path: <linux-kernel-owner+w=401wt.eu-S1760895AbYBTJfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760895AbYBTJfS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 04:35:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756102AbYBTJfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 04:35:07 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:63179 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754663AbYBTJfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 04:35:05 -0500
Date: Wed, 20 Feb 2008 10:34:46 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: david-b@pacbell.net, spi-devel-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: atmel_spi clock polarity
Message-ID: <20080220103446.1621c81f@dhcp-252-066.norway.atmel.com>
In-Reply-To: <20080220.142109.11595419.nemoto@toshiba-tops.co.jp>
References: <20080218124237.0b5f701c@dhcp-252-066.norway.atmel.com>
	<20080218.231243.41197917.anemo@mba.ocn.ne.jp>
	<20080218153158.2ff8842a@dhcp-252-066.norway.atmel.com>
	<20080220.142109.11595419.nemoto@toshiba-tops.co.jp>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2008 14:21:09 +0900 (JST)
Atsushi Nemoto <anemo@mba.ocn.ne.jp> wrote:

> On Mon, 18 Feb 2008 15:31:58 +0100, Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:
> > > Anyway, I will try your patch in a few days.
> > 
> > Ok, thanks. If it works, that would be great, but given your
> > description above I'm not sure if I dare hope for it.
> 
> Unfortunately it did not work.  The clock state did not change by
> writing MR register.

Ok, thanks for testing.

In that case, I think the best fix is to let NPCS0 stay selected
permanently in MR and overwrite CSR0 with to the new slave's settings
before asserting CS. But that's a more complicated change, and I don't
know how it will affect the AT91RM9200 special cases.

So I suggest we merge your patch for 2.6.25, and try to optimize it
for 2.6.26.

David, do you want me to pass on the patch with my signoff or just ask
Andrew to add my Acked-by to the patch already in mm?

Haavard
