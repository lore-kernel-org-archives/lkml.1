Return-Path: <linux-kernel-owner+w=401wt.eu-S1761258AbZD1IRH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761258AbZD1IRH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 04:17:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760282AbZD1IQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 04:16:49 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44018 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760192AbZD1IQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 04:16:48 -0400
Date: Tue, 28 Apr 2009 09:16:46 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Brownell <david-b@pacbell.net>
Cc: Paul Walmsley <paul@pwsan.com>, linux-omap@vger.kernel.org,
       lrg@slimlogic.co.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator core: fix double-free in
	regulator_register() error path
Message-ID: <20090428081646.GC20027@rakim.wolfsonmicro.main>
References: <alpine.DEB.2.00.0904250526210.28378@utopia.booyaka.com> <alpine.DEB.2.00.0904252250230.4291@utopia.booyaka.com> <200904272008.50268.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904272008.50268.david-b@pacbell.net>
X-Cookie: Process promptly.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 08:08:50PM -0700, David Brownell wrote:
> On Saturday 25 April 2009, Paul Walmsley wrote:

> > For the 3430SDP users out there, this patch also fixes the boot hang after 
> > "regulator_init_complete: incomplete constraints, leaving VAUX3 on"
> > on that device.

> For the record, that "incomplete constraints" message is bogus.
> On that board, VAUX3 has a complete set of constraints:  it may
> only emit 2.8V.

It's not VAUX3 that it's saying has incomplete constraints, it's the
board as a whole - if the constraints for the board were fully specified
(and the core had been told about it) then it would power off VAUX3 at
that point.

> Mark and/or Liam ... you might want to fix that diagnostic, to
> avoid leading more developers astray!

Probably shove a "board has" in there or something I guess.
