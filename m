Return-Path: <linux-kernel-owner+w=401wt.eu-S1753589AbZIJUGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589AbZIJUGV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 16:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752320AbZIJUGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 16:06:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41924 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbZIJUGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 16:06:20 -0400
Date: Thu, 10 Sep 2009 17:05:38 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Alan Cox <alan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] char/tty_io: fix legacy pty name when more than 256 pty
 devices are requested
Message-ID: <20090910170538.3df10839@caramujo.chehab.org>
In-Reply-To: <4AA950C8.1080200@zytor.com>
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
	<20090910161215.5129bd71@caramujo.chehab.org>
	<4AA950C8.1080200@zytor.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, 10 Sep 2009 12:17:28 -0700
"H. Peter Anvin" <hpa@zytor.com> escreveu:

> > In the case of the BSD sockets, the patch is not just an userless fix. This is
> > interesting when some applications are ported from other Unix'es and still uses BSD
> > pty's, since several other Unix flavors were defining a higher namespace size.
> > 
> > For example, on zOS Unix, a pty device seems to allow up to 10.000 pty numbers (in the
> > specific case of zOS Unix, they seem to be defined as /dev/[pt]typ[0-9]...) as shown at:
> > 	www.redbooks.ibm.com/redbooks/pdfs/sg245228.pdf
> > 
> 
> Yes, but you have to port the application *anyway* do deal with the
> namespace.

Or create some udev rules for that.

> BSD tty allocation is done largely by each application,
> which makes it even worse.  Furthermore, there is the static allocation
> issue, so unless there is a concrete application which needs this *and*
> cannot be ported to Unix98 ptys (which is the Right Thing[TM] to do) I
> think Alan is right.

The amount of static allocation space can be controlled via pty.legacy_count
boot parameter. It overrides whatever specified at CONFIG_LEGACY_PTY_COUNT.
You can even let LEGACY_PTY_COUNT = 0 and enable the actual numbers of needed
legacy ptys via boot parameter, where needed. So, this is not a problem on a
real situation.

Cheers,
Mauro
