Return-Path: <linux-kernel-owner+w=401wt.eu-S1764644AbXGSJsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764644AbXGSJsa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 05:48:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756136AbXGSJsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:48:13 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59983 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755352AbXGSJsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:48:12 -0400
Date: Thu, 19 Jul 2007 02:47:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Paul Mackerras <paulus@samba.org>, Jens Axboe <axboe@kernel.dk>,
       "James E.J. Bottomley" <James.Bottomley@SteelEye.com>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org, Geoff Levand <geoffrey.levand@am.sony.com>
Subject: Re: [patch 2/3] ps3: BD/DVD/CD-ROM Storage Driver
Message-Id: <20070719024730.03609f1f.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.62.0707191137470.8661@pademelon.sonytel.be>
References: <20070716161539.075822000@pademelon.sonytel.be>
	<20070716162206.529280000@pademelon.sonytel.be>
	<20070718164351.a92ec032.akpm@linux-foundation.org>
	<Pine.LNX.4.62.0707191100270.8661@pademelon.sonytel.be>
	<20070719021752.35cb7daa.akpm@linux-foundation.org>
	<Pine.LNX.4.62.0707191137470.8661@pademelon.sonytel.be>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jul 2007 11:39:32 +0200 (CEST) Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:

> > Oh dear.
> > 
> > 	ps3rom_priv(dev) = host;
> > 
> > that's 'orrid.  We have an identifier pretending to be a function, only we
> > go and treat it as an lvalue.
> > 
> > I mean, C code should look like C code, and the above just doesn't.
> > 
> > Sigh.
> 
> Do you prefer
> 
> static inline struct ps3rom_private *ps3rom_priv_get(struct ps3_storage_device
> *dev)
> {
> 	return dev->sbd.core.driver_data;
> }
> 
> static inline void ps3rom_priv_set(struct ps3_storage_device *dev,
> 				   struct ps3rom_private *priv)
> {
> 	dev->sbd.core.driver_data = priv;
> }
> 
> instead?

Yes.  Not that it's a terribly important issue, particularly down in the
dark and dusty corners where this code lurks.  The "function" as an lvalue
thing would be more obnoxious in some top-level interface.  We probably
already have some :(

If it were mine I'd open-code the "set" and do the "get" as a static
inline.  Or you could leave it as-is and go off and do something more
important ;)
