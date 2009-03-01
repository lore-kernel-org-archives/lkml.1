Return-Path: <linux-kernel-owner+w=401wt.eu-S1757111AbZCAJtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757111AbZCAJtd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 04:49:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753456AbZCAJtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 04:49:24 -0500
Received: from n30.bullet.mail.mud.yahoo.com ([68.142.207.49]:46588 "HELO
	n30.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753343AbZCAJtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 04:49:23 -0500
X-Yahoo-Newman-Id: 553664.83202.bm@omp416.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=JpFVyKc5cJL5f/CROwMtpvbYS0v2Ifod2bPcbbA/dVzLkXOCDiTP8WoWQeE8VuCpJpy9oC3f+Azb0/RsMfm8ikvX1w6PaD1ygT/ZPb4v6G/0NA8ILcdTQZGltZRahYJ66chZA3/25BLw6VuzZIK+zeVvyTWHJt1JOEjeloKHZsc=  ;
X-YMail-OSG: LhinXvUVM1ldSC.fpPZT4vLSQj9z_rBb79UvrHuG6ng4OdNKa4XvghxWG..BCiOtDgL9j7XRkMRzji1dcJA8QPDfmVcWY1.N_FzD8328EQ4nsft7.nP5MMCn3PoRtkapbN.6hy8ihO6sPyITqcFUEecf
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Balaji Rao <balajirrao@openmoko.org>
Subject: Re: [PATCH 0/2] spi: Add support for non-blocking synchronous transfers
Date: Sun, 1 Mar 2009 01:49:19 -0800
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
       Andy Green <andy@openmoko.com>
References: <20090228081036.31964.80618.stgit@fedora.yogi> <200902281519.55341.david-b@pacbell.net> <20090301051103.GA3103@fedora.yogi>
In-Reply-To: <20090301051103.GA3103@fedora.yogi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200903010149.19845.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 28 February 2009, Balaji Rao wrote:
> > That leaves un-answered the question of what to do when
> > the SPI bus is busy performing some other transfer.  I
> > looked at your [2/2] patch, and saw it ignoring that very
> > basic issue ... this new call will just poke at the bus,
> > trashing any transfer that was ongoing.
> 
> We use s3c24xx_gpio as the master, which is a very simple gpio based
> bitbang. 
> 
> Yes, it is with this intention, interrupts are disabled around the
> actual bitbang code, so that it completes without being interrupted.
> Doesn't this guarantee atomicity ?

Atomicity isn't the issue so much as the fact that if the
bus is in the middle of some transfer to one device,
your patch lets another device trash that transmission.

I don't know how many more times I can say that your
patches introduce DATA CORRUPTION to the system, but
it's surely not many more times.




