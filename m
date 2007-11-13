Return-Path: <linux-kernel-owner+w=401wt.eu-S1752165AbXKMJgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165AbXKMJgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 04:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbXKMJgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 04:36:07 -0500
Received: from morrison.andev.ch ([213.133.123.55]:65487 "EHLO
	morrison.andev.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbXKMJgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 04:36:06 -0500
Date: Tue, 13 Nov 2007 10:36:02 +0100
From: Petar Bogdanovic <list+2007@smokva.net>
To: Milan Broz <mbroz@redhat.com>
Cc: linux-kernel@vger.kernel.org, list+2007@smokva.net
Subject: Re: dd/mke2fs on loopback hangs
Message-ID: <20071113093602.GA5570@pintail.smokva.net>
Mail-Followup-To: Milan Broz <mbroz@redhat.com>,
	linux-kernel@vger.kernel.org, list+2007@smokva.net
References: <20071106131310.GA8628@pintail.smokva.net> <4730D6F3.8030500@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4730D6F3.8030500@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2007 at 10:04:51PM +0100, Milan Broz wrote:
> Petar Bogdanovic wrote:
> > I experience some strange problems with my loopback-on-ext3-setup.
> > After creating a plain `zeroed' dummy-file and doing a /dev/loop/0 on
> > it, every dd or mke2fs hangs while doing certain write()s. Here are the
> > steps just in order to show, how simple the setup is:
> ...
> 
> > P.S:	$ uname -a
> > 	Linux pintail 2.6.23-ARCH #1 SMP PREEMPT Sat Oct 27 09:04:14 UTC
> > 	2007 i686 Intel(R) Pentium(R) M processor 1.70GHz GenuineIntel
> > 	GNU/Linux
> 
> Hi Petar,
> 
> I saw similar bug report for dm-crypt over loop but reproducible even
> on stand-alone loop devices -  see http://bugzilla.kernel.org/show_bug.cgi?id=8020
> 
> The problem was caused by loop io stalling in balance_dirty_pages.
> 
> Per BDI dirty limit patchset (included in 2.6.24-rc) fixed it.

Indeed, the problem disappeared on 2.6.24-rc2. Thanks again for the
hint!


Petar
