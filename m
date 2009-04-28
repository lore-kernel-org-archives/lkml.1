Return-Path: <linux-kernel-owner+w=401wt.eu-S1757365AbZD1Uy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365AbZD1Uy3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 16:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756774AbZD1UyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 16:54:17 -0400
Received: from n14.bullet.mail.mud.yahoo.com ([68.142.206.41]:41857 "HELO
	n14.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756175AbZD1UyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 16:54:15 -0400
X-Yahoo-Newman-Id: 63570.34852.bm@omp415.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=IhVKFRAAxSFVMuQiOcvUhs4ZyPDM/vFJucYTnU8pVkSd05IeXHBqmMsud9K8fPgiipa2+JJAGj9tXmv+zsOQvLSKYdMU3NYG1sBgKXRCyZF3ZinovVOnfbQin5D2dRRrTO1mlKEjGTL7hiRYClBb6Gdqaa9/eB4UbHe4pHGiTa0=  ;
X-YMail-OSG: uEbPHaoVM1kMGUc.xeHkivaVuFXZTvi11RWNTmxEsAO5WevxcEfJXHfb3WZ7JK_SIl4MI3AcC48_XgP.V2Ot6EGUMvUTaQVsWPBNHN3qRSjja9Z8CSDZ_kIB1ejpB_t5S2tF37CruxgbzlM0amFlnbJYdZEop6l5nJ4rqnWlYGw._N0pvM2l5dKZmmFKAbaLi1l.TcnSZQ4Fh5VhfCeYF.jQI59NjV4ut0o.gwQqxOWeniRC4QbZJDjl_xCQppEnKNxFamfthhAI5oWC0mLARoXSnhyjfOU1nCxMvXCiRaCqUxSgHDoA1IXGyhGdOUQCYdIgqpj2zCYjPK5zteQCsJfn1Yo-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Florian Fainelli <florian@openwrt.org>
Subject: Re: [spi-devel-general] [PATCH v2] spi: Add support for the OpenCores SPI controller.
Date: Tue, 28 Apr 2009 13:54:11 -0700
User-Agent: KMail/1.9.10
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <200904041227.54687.david-b@pacbell.net> <20090428122011.GB6325@avionic-design.de> <200904281541.21238.florian@openwrt.org>
In-Reply-To: <200904281541.21238.florian@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904281354.12192.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 April 2009, Florian Fainelli wrote:
> > > Is this the http://www.opencores.org/?do=project&who=spi core?
> >
> > Yes, it is.
> >
> > > Its summary says "Variable length of transfer word up to 32 bits";
> > > does that mean "configurable when core is synthesized" instead of
> > > truly "variable"?
> 
> This is indeed configured at synthesis time.

Now I'm confused again.  Thierry says (below) that the number of bits
can be set per-"transfer".

Now, I can easily understand that a *maximum* would be configured
at synthesis time ... if there's a 32-bit CPU or DMA engine, it'd
make very limited sense to interact using 128-bit I/O words.

Is there both a configurable maximum, *and* a word-size setting that
can be changed on the fly?  That's what I would expect; it's what
most other designs do.  The only time I've seen fixed "you must use
N-bit words" designs is on cost-eradicated 8-bit microcontrollers.

- Dave


> > That summary seems out-dated. The variable length of transfer word is
> > actually the maximum length of a single transfer and is 128 bits in the
> > latest version. So you get 4 registers, each 32 bits wide into which you
> > program the data you want to transfer. Then you set the number of bits of
> > that transfer so the core knows which registers and what bits of those
> > registers to shift out serially.



