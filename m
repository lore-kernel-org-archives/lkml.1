Return-Path: <linux-kernel-owner+w=401wt.eu-S1754820AbYJQP3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbYJQP3f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 11:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756301AbYJQP3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 11:29:11 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:39836 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756253AbYJQP3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 11:29:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=usYnN2u9v8BHnGG5zoAq90QsKveBnpg0kHEeBnqu9YZF7VcKBeQlQBHFvA32J38/YyiWNuPk9bBZThnLNc6B0pPZgsTbLPRXBlhl/9oIPvpLkcdaa8HWB9ll/duAUvWJXYLj9vAJk+AJBsVwTkvuEPyuy1MOyrfc3ORNok7QufM=  ;
X-YMail-OSG: 6PyFC84VM1kSz4kPPzRFsx3prJyX8v9zavSMrFrK7GH1wMwP2x_hZre7cJfRLMjAsRWjZzQpOBujUYfcXJ9nmbDPhin6S0293iT2X9ZLRAXUmhAJBe_pCwSH23Da6NOFVAzltZNy9ZPgyQVTkWTzlIr1_4AR59mNo9DID2A-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Jackson <mpfj@mimc.co.uk>
Subject: Re: [PATCH] Add Dallas DS1390 RTC chip
Date: Fri, 17 Oct 2008 08:29:06 -0700
User-Agent: KMail/1.9.9
Cc: Alessandro Zummo <alessandro.zummo@towertech.it>,
       rtc-linux@googlegroups.com, lkml <linux-kernel@vger.kernel.org>,
       spi-devel-general@lists.sourceforge.net
References: <48F452BE.2030901@mimc.co.uk> <20081014101703.1ded0259@i1501.lan.towertech.it> <48F8467C.5010902@mimc.co.uk>
In-Reply-To: <48F8467C.5010902@mimc.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200810170829.06699.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 October 2008, Mark Jackson wrote:
> >> +    /* Can tx_buf and rx_buf be equal? The doc in spi.h is not sure... */
> >> +    xfer.tx_buf = chip->tx_buf;
> >> +    xfer.rx_buf = chip->rx_buf;
> > 
> >  you use the same buffer a few functions below. either
> >  one way or the other. please investigate with the spi subsystem maintainer.
> 
> David,
> 
> Just to double check (as per Alessandro's suggestion), is this okay use of the 
> spi buffers ?

Yes.  That comment deserves to be updated.

SPI does bi-directional I/O, and the underlying controller
should be able to just replace the contents of a buffer
with a spi_transfer that uses the same rx and tx buffers.

- Dave
