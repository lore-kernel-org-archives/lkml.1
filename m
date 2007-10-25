Return-Path: <linux-kernel-owner+w=401wt.eu-S1756242AbXJYEie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242AbXJYEie (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 00:38:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753455AbXJYEi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 00:38:26 -0400
Received: from smtp112.sbc.mail.mud.yahoo.com ([68.142.198.211]:44643 "HELO
	smtp112.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753391AbXJYEiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 00:38:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=3uYa7DWu3+c6ai0ePWrW+jGF6ucRWel08zzgw6Icbcy7KSoDqM7rPsCmRhsL7r6KSRRvwvsoXCVTi68KpqpbkG8o3BJiHqdFzriR+JDfk+Ds5u9p+GEp2WEnBVh9OqB0ywR0ODPODn/9gyYnvTB3RNAAA9V34PuqDtLU/2z3caM=  ;
X-YMail-OSG: KT2cGE4VM1lH915xnVHEXagS2iq5USPEln0sIgEbpwWg9wesJGkgPcKv6rFtj1qz5.mo6gyp5g--
From: David Brownell <david-b@pacbell.net>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [patch 2.6.24-rc1] resource_len() utility function
Date: Wed, 24 Oct 2007 21:38:22 -0700
User-Agent: KMail/1.9.6
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>
References: <200710241820.52376.david-b@pacbell.net> <200710241947.15129.david-b@pacbell.net> <4720118F.5050906@garzik.org>
In-Reply-To: <4720118F.5050906@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200710242138.23252.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 October 2007, Jeff Garzik wrote:
> >> Then a dev_iomap() analogue to pci_iomap() should be pretty 
> >> straightforward to create.
> > 
> > Another minor nit:  addressing the various resource types.
> > The platform bus code has multiple lookup schemes. 
> > 
> > Calls like resource_iomap() might be more flexible, so that
> > lookup schemes can stay flexible.
> 
> I figured that, in the absence of a true, defined BAR concept, the 
> struct device version would simply index into the discussed array of 
> struct resource.  That means any ordering or layout of resources should 
> work, presuming (the usual case) that both driver and platform agree on 
> the resource layout.

So you'd suggest having search utilities (as with platform_bus)
returning resource indices not resources?

Thing is, BARs are usually well defined, but when folk glue
resources together they use whatever order is convenient on
that particular platform.  And different platforms can have
different numbers and types of resources, etc.

- Dave

