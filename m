Return-Path: <linux-kernel-owner+w=401wt.eu-S933092AbXCESmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933092AbXCESmL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 13:42:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932419AbXCESmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 13:42:11 -0500
Received: from smtp112.sbc.mail.mud.yahoo.com ([68.142.198.211]:38324 "HELO
	smtp112.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933092AbXCESmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 13:42:10 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=2GKSyDPmAsuYZFcDeWzoNREHrwUVj2Um3jJKg4pYiF/Duod3P+sIROspXvUZa8GFrnWpNv0b7IMd0WnLkk5/3EkZ1YrLQnSS3qHPzDtPdUm6jsUoiLme5671qIUDOl9NXaJOwmM+hCbYzvw00xztqK0Qpn3GHuN718IZesm0zwg=  ;
X-YMail-OSG: yeYPZbQVM1kfDZnI3GwLQznMiIYEsmgANk2NUpdpKGli0eePoLH41_hsJ2JE5ppyBNv3p0SiAF80vJ0vCBzKh_d2HTlKVDFj3QMyKGBRpKrM1OspLxDKWe0LGU78EX1C0Jg.PwNY4BJ2M1I-
From: David Brownell <david-b@pacbell.net>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: 2.6.21-rc2-mm1: drivers/usb/host/ohci-ssb.c doesn't compile
Date: Mon, 5 Mar 2007 10:42:05 -0800
User-Agent: KMail/1.7.1
Cc: greg@kroah.com, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>, linville@tuxdriver.com,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
References: <20070302030026.5eef0c92.akpm@linux-foundation.org> <200703051157.16822.mb@bu3sch.de> <200703051226.46402.mb@bu3sch.de>
In-Reply-To: <200703051226.46402.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703051042.06802.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 March 2007 3:26 am, Michael Buesch wrote:

> > Actually, it seems like I will run into other kinds of nasty problems
> > due to stupid design of the HCD code. The OHCI code #includes
> > the various drivers, which have a module_init each. So if you
> > compile PCI and SSB support, you have two module_init for one
> > OHCI module. Not sure how to fix this. Any idea?
> 
> A real problem is that the HCD core seems to have the assumption
> built-in that there can only be one OHCI driver per machine/arch.

What ancient version of the driver are you referring to??

CURRENT code has one module_init, and can hook up to several
different kinds of bus glue.  There *is* only one OHCI driver.
It can hook up through several different kinds of bus glue; a
few platforms support more than one way to connect to various
implementations of OHCI.


> That's not the case for SSB, where we can have both PCI and SSB
> bus enabled, so both ohci drivers compiled.
> Any idea? Greg perhaps?

This already works in the current code ...

- Dave
