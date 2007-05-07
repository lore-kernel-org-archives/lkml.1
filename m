Return-Path: <linux-kernel-owner+w=401wt.eu-S966054AbXEGSEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966054AbXEGSEe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 14:04:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934473AbXEGSEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 14:04:30 -0400
Received: from host2.innominate.fta-berlin.de ([141.16.82.35]:51565 "EHLO
	home.innominate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934461AbXEGSE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 14:04:28 -0400
X-Greylist: delayed 732 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 May 2007 14:04:28 EDT
Date: Mon, 7 May 2007 19:52:13 +0200
From: Christian Hohnstaedt <chohnstaedt@innominate.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Michael-Luke Jones <mlj28@cam.ac.uk>, netdev@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Russell King <rmk@arm.linux.org.uk>, Jeff Garzik <jeff@garzik.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] Intel IXP4xx network drivers
Message-ID: <20070507175213.GU23611@tweety>
Mail-Followup-To: Christian Hohnstaedt <chohnstaedt@innominate.com>,
	Krzysztof Halasa <khc@pm.waw.pl>,
	Michael-Luke Jones <mlj28@cam.ac.uk>, netdev@vger.kernel.org,
	linux-arm-kernel@lists.arm.linux.org.uk,
	Russell King <rmk@arm.linux.org.uk>, Jeff Garzik <jeff@garzik.org>,
	lkml <linux-kernel@vger.kernel.org>
References: <m3abwhcy74.fsf@maximus.localdomain> <m3vef5biob.fsf@maximus.localdomain> <5BB7E1AB-5CE1-43C8-8CE3-E0DE0236BD09@cam.ac.uk> <m3hcqoa772.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3hcqoa772.fsf@maximus.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2007 at 07:12:49PM +0200, Krzysztof Halasa wrote:
> Michael-Luke Jones <mlj28@cam.ac.uk> writes:
> 
> > Code placement:
> > Queue Manager & NPE code => arch/arm/mach-ixp4xx
> > WAN driver code => drivers/net/wan
> > Eth code => drivers/net/arm
> 
> Why would you want such placement?
> Potential problems: header files would have to be moved to
> include/asm-arm = headers pollution.
> All 4 drivers are, in fact, network (related) drivers.
No.

- qmgr is a versatile hardware fifo stack, that is currently
  used to exchange data with the NPE.

- the NPE can also be used as DMA engine and for crypto operations.
  Both are not network related.
  Additionally, the NPE is not only ixp4xx related, but is
  also used in IXP23xx CPUs, so it could be placed in
  arch/arm/common or arch/arm/xscale ?

- The MAC is used on IXP23xx, too. So the drivers for
  both CPU familys only differ in the way they exchange
  network packets between the NPE and the kernel.
  
> 
> drivers/net/arm would probably make (some) sense if it was
> a single (or not so single) Ethernet driver.
If Queue Manager & NPE move to arch/.... , it can be a single file.

Christian Hohnstaedt

-- 
Christian Hohnstaedt
Software Engineer

Innominate Security Technologies AG  /protecting industrial networks/
tel: +49.30.6392-3285 fax: +49.30.6392-3307
Albert-Einstein-Strasse 14, D-12489 Berlin, Germany
http://www.innominate.com

Register Court: AG Charlottenburg, HR B 81603
Management Board: Joachim Fietz, Dirk Seewald
Chairman of the Supervisory Board: Edward M. Stadum
