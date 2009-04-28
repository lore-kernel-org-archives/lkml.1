Return-Path: <linux-kernel-owner+w=401wt.eu-S1757945AbZD1JkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757945AbZD1JkH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 05:40:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755375AbZD1Jjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 05:39:53 -0400
Received: from n71.bullet.mail.sp1.yahoo.com ([98.136.44.36]:35741 "HELO
	n71.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751693AbZD1Jjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 05:39:52 -0400
X-Greylist: delayed 407 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Apr 2009 05:39:52 EDT
X-Yahoo-Newman-Id: 296095.3729.bm@omp409.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=jOPdnkb6gRR4nbfcg6rJpQdvc9sHSL7hbT/hlV7LZrppFhk6Lw1Ay7JToDtTu+Np+jUa0JgnEIqks5lnmPZOHY5Rw5zvDWS1NqdUA0M4MnJ8O0wsk9TLbJV/+RnQehaYIgB9EMsSs6YRm+uE1lfA8pFt7oOhvXu3JFQxL5exn6o=  ;
X-YMail-OSG: HCM0fzAVM1nxagUa8oJufV0NqsYSIPgzQ5m2QrmQulX8Un0LoZ1MJzNyv6KVLD2tYaPVcr4Pj0He6OqMaHFyj8cy2Q2bZlqs83W211vWYDbehRF38eR9E7g0tQpAu0bDaiyZ0jaCCwUiCi56ufiYUntsENR.kUMuoiOacdl0d09fS3H81HoVHt8OQf1ak9vfO.dI5QbiNI9.TIHLhoNGddmIK4MHpIbkVr8cS2asSLLEqKI176o.Xus053APMAc7WNOx_jk_Odl5fN4qG.xZ0qyoas_atpCNK9Sh6GWA.liQ37dU62SY
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] regulator core: fix double-free in regulator_register() error path
Date: Tue, 28 Apr 2009 02:32:56 -0700
User-Agent: KMail/1.9.10
Cc: Paul Walmsley <paul@pwsan.com>, linux-omap@vger.kernel.org,
       lrg@slimlogic.co.uk, linux-kernel@vger.kernel.org
References: <alpine.DEB.2.00.0904250526210.28378@utopia.booyaka.com> <200904272008.50268.david-b@pacbell.net> <20090428081646.GC20027@rakim.wolfsonmicro.main>
In-Reply-To: <20090428081646.GC20027@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200904280232.56329.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 April 2009, Mark Brown wrote:
> > For the record, that "incomplete constraints" message is bogus.
> > On that board, VAUX3 has a complete set of constraints:  it may
> > only emit 2.8V.
> 
> It's not VAUX3 that it's saying has incomplete constraints, it's the
> board as a whole - if the constraints for the board were fully specified

No; driver support != constraint.  Only one of the
issues is packaged as a "constraint".


> (and the core had been told about it) then it would power off VAUX3 at
> that point.
>
> > Mark and/or Liam ... you might want to fix that diagnostic, to
> > avoid leading more developers astray!
> 
> Probably shove a "board has" in there or something I guess.

How about:  "VAUX3 board support is incomplete".
That's accurate.

A comment there might suggest constraints and
driver support as two common issues ... I'd not
be surprised to see a few more idioms pop up.

- Dave

