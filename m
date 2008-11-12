Return-Path: <linux-kernel-owner+w=401wt.eu-S1754796AbYKLVmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796AbYKLVmw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 16:42:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbYKLVmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 16:42:44 -0500
Received: from smtp127.sbc.mail.sp1.yahoo.com ([69.147.65.186]:31625 "HELO
	smtp127.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752176AbYKLVmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 16:42:43 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Date:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=Jykyxxsa/KKLEWq9M/D6CUmjTZwuwfqFftqC6X7kYT1elOf43l5myPusPfx7ntB2r9tw3tX7dv6/zD5p+G3WKeB6I7n8sNPLaE3Ew52gTGGdOo+omJJDQsDcSGfZn6B7dgQyhBLsuv6XOrhdhoFCUClGZhYGMvJCqWJhvgBEVUA=  ;
X-YMail-OSG: GSuWS7kVM1mX5WhB3C0u_anIhh0WMsjn9YXnwTS2TyXW_qq9X68SNSIf2k7XZARVnDTxCcFkl9yZtM_9MSyl775f0x9qccRcVsWsjuSdalrs9O6gvCyaA7F28CAGA9lWR9v3htwVQci96CzQvdnrPy4cHVP6SZmOavP.vKA-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@sirena.org.uk>
Subject: Re: [patch 2.6.28-rc3] regulator: add REGULATOR_MODE_OFF
User-Agent: KMail/1.9.10
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>
References: <200811091531.46003.david-b@pacbell.net> <200811102056.20008.david-b@pacbell.net> <20081112112525.GA8767@sirena.org.uk>
In-Reply-To: <20081112112525.GA8767@sirena.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
Date: Wed, 12 Nov 2008 13:42:35 -0800
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200811121342.36117.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 November 2008, Mark Brown wrote:
> On Mon, Nov 10, 2008 at 08:56:19PM -0800, David Brownell wrote:

> > > I'm also wondering if part of what we need to do is add separate out the
> > > reporting paths for the actual and requested status?  At the minute we
> > > only report the actual status and there's no indication of the logical
> > > status which does create some confusion here.
> 
> > Makes sense.  Record "requested_mode" in "struct regulator_dev"
> > and expose a new sysfs attribute for it.  Should I update
> > the $SUBJECT patch to do that too?
> 
> It should be a separate patch, I'd say.

So you think I should split my "v2" patch in two chunks?
One distinguishing requested-vs=actual mode, and the other
allowing the actual mode to include OFF.  (Possibly by just
reporting mode 0 ...)


> Thinking about it I'm not sure if the hardware or logical state should
> be the primary.  In terms of debugging power consumption and so on the
> physical state is probably the more important one but from the point of
> view of Linux it's the logical state that matters most since that's what
> Linux is actually doing (IYSWIM).

If there are both "requested opmode" and "opmode" attributes
in sysfs, I don't see how one would be "primary"!

The difference is that one needs to be reported by hardware,
and the other is trivially remembered by framework software.

- Dave
