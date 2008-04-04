Return-Path: <linux-kernel-owner+w=401wt.eu-S1753143AbYDDX6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143AbYDDX6x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 19:58:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751680AbYDDX6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 19:58:43 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:34449 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751544AbYDDX6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 19:58:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=0pkk+JC+UzlTizSfXRIZvvAmG1+Alo4xb/oOhdp+zL9HvE3gzAhitfP0puoxJfa5kiHHfQ9dyemMlGxp0KtwF71hIZjSAXGSFgQ1Ju2rAV4nHeEE2YvXyqKANGfm7gZs1e8zg2h52XZ0+Ih3Q8mYdPV8WKmMowmRRSlNYkY3z5E=  ;
X-YMail-OSG: PimQd6IVM1nC1Y9VvyM1gBLTzxPhtU5q0BRzG6lgmJyfN177g.jl5svWE_GyBe2VELPtOG4_cA--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Josh Boyer <jwboyer@gmail.com>
Subject: Re: [PATCH]  jffs2 summary allocation
Date: Fri, 4 Apr 2008 16:58:38 -0700
User-Agent: KMail/1.9.6
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Trimarchi <trimarchimichael@yahoo.it>, dwmw2@infradead.org,
       spi-devel-general@lists.sourceforge.net, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
References: <713171.37644.qm@web26213.mail.ukl.yahoo.com> <200804041609.41092.david-b@pacbell.net> <1207351282.3224.79.camel@vader.jdub.homelinux.org>
In-Reply-To: <1207351282.3224.79.camel@vader.jdub.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200804041658.38499.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 04 April 2008, Josh Boyer wrote:
> 
> >   ... This means specifically that you may _not_ use the
> >   memory/addresses returned from vmalloc() for DMA.  ...
> > 
> > So I'm rather surprised to see *ANY* kernel code trying to do
> > that.  That rule has been in effect for many, many years now.
> 
> I don't think it was intentional.  You're going through several layers
> here:
> 
> JFFS2 -> mtd parts -> mtd dataflash -> atmel_spi.
> 
> Typically MTD drivers aren't doing DMAs to flash and JFFS2 has no idea
> which particular chip driver is being used because it's abstracted by
> MTD.

That's true ... although I can imagine using DMA to
avoid dcache trashing if its setup cost is low enough,
with either NAND or NOR chips.

Still:  in this context vmalloc() is wrong.

- Dave
