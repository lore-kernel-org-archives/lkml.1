Return-Path: <linux-kernel-owner+w=401wt.eu-S1759014AbYBUTXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759014AbYBUTXq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 14:23:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753303AbYBUTXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 14:23:38 -0500
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:36734 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752975AbYBUTXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 14:23:37 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=50epHcQNplUoBNGtX1awJ5svYSRDID60R64Bt3iqwCrziJJFf8XGAvQoXhPtrrb5i/bY3HTLLPQ2rzwaag6CrVfBjBJQInqDf+pGSq9yxRsVI8ywRGCzWN/KjULhxmC/WD95M73oOQb/nTQKjjDodbrvK0v1/LQ17d2T+kxnT8g=  ;
X-YMail-OSG: LQbvcS4VM1ksWXnyU0MfdYzOo27E4SfexNmM.HshbVrtZBcwHgqWNja.SKUc89ZHwvL5AbwMfQ--
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 21 Feb 2008 11:23:34 -0800
From: David Brownell <david-b@pacbell.net>
To: marc.pignat@hevs.ch, anemo@mba.ocn.ne.jp
Subject: Re: [PATCH] atmel_spi: support zero length transfer
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       hskinnemoen@atmel.com
References: <20080221.005432.07645461.anemo@mba.ocn.ne.jp>
 <200802201855.02605.marc.pignat@hevs.ch>
 <20080221.105233.41199605.nemoto@toshiba-tops.co.jp>
 <200802211026.17816.marc.pignat@hevs.ch>
In-Reply-To: <200802211026.17816.marc.pignat@hevs.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080221192334.EE97A230A58@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> David, do you think writing 0 bytes is a valid use of this API?

Just a zero byte transfer ... no, though it depends what you mean
by "valid".  (I'm not sure I'd expect all controller drivers to
reject such requests.)  That has no effect on bits-on-the-wire,
and would make trouble for various DMA engines.

Passing zero bytes to get an inline delay at an exact spot in the
overall protocol message ... I don't see why not.  Better than
adding delay fields for every spot it might be needed by various
oddball devices, for sure!!


> IMHO, we should add a fied to the spi_transfer struct.

What would that do, exactly?

This *specific* usage might arguably belong in spi_device, since
it's a delay required after chipselect goes active and before any
bytes get transferred.  It's clearly not a per-transfer thing, and
should also apply after a temporary mid-message chip deselect.

And it would probably deserve a mode flag (sigh) unless someone
can update every master controller driver.

- Dave

