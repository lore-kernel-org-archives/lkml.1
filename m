Return-Path: <linux-kernel-owner+w=401wt.eu-S1753066AbZIJTMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066AbZIJTMx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 15:12:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752414AbZIJTMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 15:12:52 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35419 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbZIJTMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 15:12:51 -0400
Date: Thu, 10 Sep 2009 16:12:15 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Alan Cox <alan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] char/tty_io: fix legacy pty name when more than 256 pty
 devices are requested
Message-ID: <20090910161215.5129bd71@caramujo.chehab.org>
In-Reply-To: <4AA92487.5080401@zytor.com>
References: <20090908144942.76ddf0e7@caramujo.chehab.org>
	<4AA6DF50.3030603@zytor.com>
	<20090908203323.486c129c@caramujo.chehab.org>
	<4AA6F63F.7090009@zytor.com>
	<20090908235441.04549a29@caramujo.chehab.org>
	<4AA73309.8030302@zytor.com>
	<20090910010512.60a1f523@caramujo.chehab.org>
	<4AA89B02.1050909@zytor.com>
	<20090910093301.4ccfd786@caramujo.chehab.org>
	<20090910150716.66310f02@lxorguk.ukuu.org.uk>
	<4AA92487.5080401@zytor.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, 10 Sep 2009 09:08:39 -0700
"H. Peter Anvin" <hpa@zytor.com> escreveu:

> On 09/10/2009 07:07 AM, Alan Cox wrote:
> > 
> > This is a real step back.
> > 
> > It now wastes all the tty[e-p]%d namespace. ttyp%d for > 255 at least
> > only uses one for this irrelevant area.
> > 
> 
> Honestly, I *really* don't think the [pt]ty[p-za-e]* namespace should be
> used for another purpose, at least until BSD ptys are killed dead, so in
> that sense expanding tty[p-za-e][0-9a-f] to tty[p-za-e][0-9a-f]+ is
> hardly significant in the namespace pollution sense.  Can you imagine
> ttyp1 being a BSD pty and ttyp10 being a completely different kind of
> device?

+1. Reusing the namespace after tty[p-za-e][0-9a-f] doesn't seem to be good, IMHO.

In the case of the BSD sockets, the patch is not just an userless fix. This is
interesting when some applications are ported from other Unix'es and still uses BSD
pty's, since several other Unix flavors were defining a higher namespace size.

For example, on zOS Unix, a pty device seems to allow up to 10.000 pty numbers (in the
specific case of zOS Unix, they seem to be defined as /dev/[pt]typ[0-9]...) as shown at:
	www.redbooks.ibm.com/redbooks/pdfs/sg245228.pdf

Cheers,
Mauro
