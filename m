Return-Path: <linux-kernel-owner+w=401wt.eu-S937623AbXGSJSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937623AbXGSJSw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 05:18:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764370AbXGSJSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:18:41 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43866 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764275AbXGSJSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:18:40 -0400
Date: Thu, 19 Jul 2007 02:17:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Paul Mackerras <paulus@samba.org>, Jens Axboe <axboe@kernel.dk>,
       "James E.J. Bottomley" <James.Bottomley@SteelEye.com>,
       Alessandro Rubini <rubini@vision.unipv.it>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       Geoff Levand <geoffrey.levand@am.sony.com>
Subject: Re: [patch 2/3] ps3: BD/DVD/CD-ROM Storage Driver
Message-Id: <20070719021752.35cb7daa.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.62.0707191100270.8661@pademelon.sonytel.be>
References: <20070716161539.075822000@pademelon.sonytel.be>
	<20070716162206.529280000@pademelon.sonytel.be>
	<20070718164351.a92ec032.akpm@linux-foundation.org>
	<Pine.LNX.4.62.0707191100270.8661@pademelon.sonytel.be>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jul 2007 11:02:07 +0200 (CEST) Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:

> On Wed, 18 Jul 2007, Andrew Morton wrote:
> > > +struct ps3rom_private {
> > > +	struct ps3_storage_device *dev;
> > > +	struct scsi_cmnd *curr_cmd;
> > > +};
> > > +#define ps3rom_priv(dev)	((dev)->sbd.core.driver_data)
> > > +
> > 
> > Someone should invent a keyboard which delivers an electric shock when the
> > operator types "#define".   In the meanwhile, I get to do the honours.
> > 
> > Please don't implement in a macro anything which can be implemented in C.
> 
> All I needed was a shorthand to access driver_data, for both read and write
> access (you cannot do the latter with C, unless you decouple read and write).

Oh dear.

	ps3rom_priv(dev) = host;

that's 'orrid.  We have an identifier pretending to be a function, only we
go and treat it as an lvalue.

I mean, C code should look like C code, and the above just doesn't.

Sigh.
