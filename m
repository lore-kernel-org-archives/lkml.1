Return-Path: <linux-kernel-owner+w=401wt.eu-S1756801AbYH1WiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801AbYH1WiM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 18:38:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758207AbYH1Wh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 18:37:56 -0400
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:46110 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758016AbYH1Whx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 18:37:53 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=dHoTDLrfLwCB+6nwMehM2/Os7qYCkAT6pw230UY/oWJoVoYY9WV5Jessfh178PTpfmantF+YdcK10ivGnuvPE6bAKl4rBXvpCfrnhYbj0tfLA8bkpslaVEc1jkkd8zBx7U4cwgB0CNsRLOWf+8H3/aTbmoLUXxjq5fVyROtwWN8=  ;
X-YMail-OSG: ctl.JI4VM1k1WITm35jWZMoY_522QEmJuABWvZpSrALjhlDwEWajrPTMZRcNtgLVyMVvKzSppxsnnDwtkBNWwhzihmxqdjik5S0uW87_kQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Greg KH <greg@kroah.com>, Marcel Janssen <marcel.janssen@admesy.nl>
Subject: Re: Fwd: Re: [PATCH] USB: add USB test and measurement class driver
Date: Thu, 28 Aug 2008 15:37:50 -0700
User-Agent: KMail/1.9.9
Cc: Marcel Janssen <korgull@home.nl>, Stefan Kopp <stefan_kopp@agilent.com>,
       Felipe Balbi <me@felipebalbi.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200808272342.38208.korgull@home.nl> <200808282022.54379.korgull@home.nl> <20080828203557.GB20537@kroah.com>
In-Reply-To: <20080828203557.GB20537@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808281537.50952.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > I either have not seen that happening before or I missed something when 
> > writing my firmware. I'll keep an eye on my USB analyzer though :-)
> > Although it's a good thing to keep to the spec, I also believe that in the 
> > case of a test and measurement device suspending the device may be an 
> > unwanted behaviour but perhaps I do misinterpret this part of the spec here.

For the record, the "gadgetfs" interface was originally developed with
userspace USB TMC implementations in mind.  I don't recall whether that
effort got out of the lab though.

The issue of suspend/resume explicitly came up.  The scenario which
stuck in my mind was that when the TMC device was in USB-level suspend
state, the code on the peripheral would need to know about that so
it could re-enable manual controls.  The host could no longer be
issuing commands.  (Some of these folk were on the TMC design team.)

One of the customers didn't seem to like the notion of not being able
to turn off stress tests on a $US 20,000 engine ... and watching the
device(s) under test blow up.  Accidental destruction == bad, it seems!

So I think you probably do misinterpret the spec.  That issue was not
only discussed, but proper handling for it was identified.

- Dave
