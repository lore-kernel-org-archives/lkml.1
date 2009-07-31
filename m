Return-Path: <linux-kernel-owner+w=401wt.eu-S1751649AbZGaL4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649AbZGaL4Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 07:56:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751023AbZGaL4Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 07:56:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59494 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978AbZGaL4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 07:56:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arnaud Faucher <arnaud.faucher@gmail.com>
Subject: Re: [PATCH 1/1] acer-wmi: switch driver to dev_pm_ops
Date: Fri, 31 Jul 2009 13:56:56 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc4-rjw; KDE/4.2.4; x86_64; ; )
Cc: Carlos Corbacho <carlos@strangeworlds.co.uk>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Frans Pop <elendil@planet.nl>, Manuel Lauss <manuel.lauss@gmail.com>,
       Erik Ekman <erik@kryo.se>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
References: <1248527091-18246-1-git-send-email-arnaud.faucher@gmail.com> <1248908025.3998.15.camel@green> <1248991509.4901.9.camel@green>
In-Reply-To: <1248991509.4901.9.camel@green>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907311356.57529.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 31 July 2009, Arnaud Faucher wrote:
> On Wed, Jul 29, 2009 at 18:53 -0400, Arnaud Faucher wrote :
> > As of today, acer_platform_freeze() does not stop/reset any device, so,
> > I agree with Rafael that for acer-wmi, .thaw() can be skipped. I had
> > also tested this configuration and it was working like the non-patched
> > code.
> > 
> > Carlos, do you think that any acer-specific hardware could be switched
> > off or reset inside acer_platform_freeze() ? If this was the case, we
> > would have to wire .thaw()...
> > 
> 
> Should I send a new patch with only .freeze() and .restore() wired ?

Just for clarification.

If you need .freeze(), then you need .suspend() as well (they can both point
to the same function).  Similarly, if you .restore(), then .resume() is needed
as well.

Otherwise the driver is going to break suspend to RAM (or resume).

Best,
Rafael
