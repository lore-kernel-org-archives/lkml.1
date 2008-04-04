Return-Path: <linux-kernel-owner+w=401wt.eu-S1754487AbYDDXVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487AbYDDXVj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 19:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbYDDXVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 19:21:32 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:59371 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbYDDXVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 19:21:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=sgsO8mRrywYPobtnq+qr/MS1CpkvAHNLDK0WR03zVV9yAmEASOa5F0OtOcLG4GvQoy5BqfS6YADVLcF653b7ECly3Q+/9Dxj7Hj3MGi19k7qeB8axPRotBgYOwNR0yCyOpmhT2wJ5sbnxh/5AJujDZxKhCTY0xZvTK/PHCRbCac=
Subject: Re: [PATCH]  jffs2 summary allocation
From: Josh Boyer <jwboyer@gmail.com>
To: David Brownell <david-b@pacbell.net>
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
       Andrew Morton <akpm@linux-foundation.org>,
       Michael Trimarchi <trimarchimichael@yahoo.it>, dwmw2@infradead.org,
       spi-devel-general@lists.sourceforge.net, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200804041609.41092.david-b@pacbell.net>
References: <713171.37644.qm@web26213.mail.ukl.yahoo.com>
	 <20080404124812.d39fa640.akpm@linux-foundation.org>
	 <200804041609.41092.david-b@pacbell.net>
Content-Type: text/plain
Date: Fri, 04 Apr 2008 18:21:22 -0500
Message-Id: <1207351282.3224.79.camel@vader.jdub.homelinux.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 (2.22.0-4.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-04-04 at 16:09 -0700, David Brownell wrote:
> On Friday 04 April 2008, Andrew Morton wrote:
> 
> > I'm assuming from the trace that the arm code tried to put that memory
> > under DMA (or at least, passed it into part of the DMA management code to
> > get the various caches sorted out) and that the arm DMA support code
> > doesn't like being given vmalloced memory.
> 
> Actually, Documentation/DMA-Mapping.txt has a section right up
> front called "What memory is DMA'able?" ... which despite its
> ungrammatical title, says clearly:
> 
>   ... This means specifically that you may _not_ use the
>   memory/addresses returned from vmalloc() for DMA.  ...
> 
> So I'm rather surprised to see *ANY* kernel code trying to do
> that.  That rule has been in effect for many, many years now.

I don't think it was intentional.  You're going through several layers
here:

JFFS2 -> mtd parts -> mtd dataflash -> atmel_spi.

Typically MTD drivers aren't doing DMAs to flash and JFFS2 has no idea
which particular chip driver is being used because it's abstracted by
MTD.

josh

