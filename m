Return-Path: <linux-kernel-owner+w=401wt.eu-S1753677AbYKQQV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677AbYKQQV7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 11:21:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbYKQQVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 11:21:50 -0500
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:30001 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752193AbYKQQVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 11:21:50 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:Reply-To:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=X2Oh5DYjvIAJkkz5xABrRYLPRSCnw9Lf2ZcyugxJdOu8+yLxv3w788AHOozVkE9Pr8zZo0ykcZ+9mM8QKvgc50ZgoH5zcJLEkyyIngaXONNKvsr+33ZLhGds5koen2guZSDIrsfyHzKGDEYRpCv3mGKuPElNEi8iTq0xiX7plIg=  ;
X-YMail-OSG: DCzXMU8VM1nABmGryLL16vXwThTCj4qUpbfqmqytKKjWWSg6prVn_2F1_WjZ.kmUpUyWBFHr7x3UJXGTHdozm10cLgJjQZl44QuW8v7zxlKZCaufNsso1aSMotLmz7SCaIw-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
Reply-To: dbrownell@users.sourceforge.net
To: Mark Brown <broonie@sirena.org.uk>
Subject: Re: [patch 2.6.28-rc5] regulator: enable/disable refcounting
Date: Mon, 17 Nov 2008 08:21:47 -0800
User-Agent: KMail/1.9.10
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>
References: <200811161144.46582.david-b@pacbell.net> <20081117151636.GG1559@sirena.org.uk>
In-Reply-To: <20081117151636.GG1559@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811170821.47582.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 November 2008, Mark Brown wrote:
> On Sun, Nov 16, 2008 at 11:44:46AM -0800, David Brownell wrote:
> 
> > +	mutex_lock(&rdev->mutex);
> > +	if (regulator->enabled == 1) {
> > +		ret = _regulator_disable(rdev);
> > +		if (ret == 0)
> > +			regulator->uA_load = 0;
> 
> Why clear the load here?  I'd expect to be able to enable and disable
> the regulator while preserving the configuration.

That clear was in the original code.  Didn't make much sense
to me either, but I was just caring it forward...

