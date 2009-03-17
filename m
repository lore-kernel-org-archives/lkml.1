Return-Path: <linux-kernel-owner+w=401wt.eu-S1758056AbZCQSP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056AbZCQSP0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 14:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754608AbZCQSPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 14:15:11 -0400
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:24497 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753539AbZCQSPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 14:15:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=GnhJYoGsLXoBGmD85KjY7Ezf62v4bry3wWRMF2irxsZ8w1GQSVCb+kG+hUkTk86NesHxxiz0Bd+kB1JnWQFrFt4upR43LqnLqNa9ACS4KGE+oRPfeXJLy2yBEQQyE0L4FRju3EAqPkNxT994U6mmbxlIL+4hQ0wBWCq/6gIV8NI=  ;
X-YMail-OSG: zQuBNpYVM1l6LvjTHihVpKJCT4Ta1xhthpYS725d1uyzmD5xVwCXFM_VOcr8TdcXuLSBxf3BpFeevoFwaCoP77hpspY9yBPmqVhLsad_7GiZkCV72N97BOiNQ2bUtqub9anKiUQe3oVcdz0dMny80yACmAuuBtCYo8fd2EfcePK6mSJr0DvNrErdR3GJ
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@sirena.org.uk>
Subject: Re: [patch 2.6.29-rc8 regulator-next] regulator: init fixes (v4)
Date: Tue, 17 Mar 2009 11:15:06 -0700
User-Agent: KMail/1.9.10
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>,
       OMAP <linux-omap@vger.kernel.org>
References: <200903111743.34708.david-b@pacbell.net> <200903142105.29382.david-b@pacbell.net> <20090316215422.GA6433@sirena.org.uk>
In-Reply-To: <20090316215422.GA6433@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903171115.06685.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 March 2009, Mark Brown wrote:
> On Sat, Mar 14, 2009 at 09:05:29PM -0700, David Brownell wrote:
> 
> > was called.  It's not exactly hard to check if it was enabled, then
> > act accordingly, in the typical "single consumer of the regulator"
> > case.
> 
> How typical that is depends very much on the devices you're looking at.

I'd have said "systems you're looking at" ... but so long
as the boot_on flag exists, then this issue can appear with
absolutely any regulator, used for anything.

The basic issue addressed by $SUBJECT patch just restores
internal consistency to the framework, in the face of such
flags (or equivalent actions by the boot loader).


> Devices that need to do things like set voltages are fairly likely to
> own the regulator but with devices that just need to ensure that they
> have their supplies enabled it's much more likely that the supplies will
> be shared.

Right.  Do you have a model how such shared supplies would
coexist with the "enabled at boot time" model, and still
support being disabled?

My first thought is that the system designer should avoid
such boot_on modes.  But that's not always going to work.

- Dave

