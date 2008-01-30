Return-Path: <linux-kernel-owner+w=401wt.eu-S1754104AbYA3BeE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104AbYA3BeE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 20:34:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751244AbYA3Bdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 20:33:53 -0500
Received: from c60.cesmail.net ([216.154.195.49]:28145 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815AbYA3Bdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 20:33:52 -0500
Subject: Re: ndiswrapper and GPL-only symbols redux
From: Pavel Roskin <proski@gnu.org>
To: Jon Masters <jonathan@jonmasters.org>
Cc: Jan Engelhardt <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Giridhar Pemmasani <pgiri@yahoo.com>
In-Reply-To: <1201654094.2271.105.camel@perihelion>
References: <1201641765.18773.35.camel@dv>
	 <1201652420.2271.91.camel@perihelion>
	 <Pine.LNX.4.64.0801300129270.14907@fbirervta.pbzchgretzou.qr>
	 <1201654094.2271.105.camel@perihelion>
Content-Type: text/plain
Date: Tue, 29 Jan 2008 20:33:50 -0500
Message-Id: <1201656830.24898.6.camel@dv>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-01-29 at 19:48 -0500, Jon Masters wrote:
> On Wed, 2008-01-30 at 01:35 +0100, Jan Engelhardt wrote:
> > On Jan 29 2008 19:20, Jon Masters wrote:
> 
> > >Another fix would be for ndiswrapper to explicitly set the taint when it
> > >loads a tainted driver? Or do we just want to go back to globally
> > >"tainting" the kernel without assigning the blame to any module?
> > 
> > I think the global taint flag is always needed because you never know
> > what the proprietary module actually did to our memory. Unloading
> > the driver and ndiswrapper should retain some sort of taintedness
> > should it oops much later.
> 
> It will. The module taint variant also sets the global taint. But it
> helps to know why you set that if you oops now and get a list of
> modules. Yeah, we know about ndiswrapper, I just mean in general.

Then we can move add_taint_module() for ndiswrapper closer to the end of
load_module(), so that it's not prevented from using GPL-only symbols.

driverloader should stay where it is, since we don't trust its license.

> Man, that'll teach me to send one-liners without checking the entire
> history of LWN stories beforehand. I'm going to the gym to escape :)

I'm actually so relieved that it has been mistake, just like it was the
last time.  Good luck!

-- 
Regards,
Pavel Roskin
