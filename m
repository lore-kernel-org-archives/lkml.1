Return-Path: <linux-kernel-owner+w=401wt.eu-S1760758AbZAHUnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760758AbZAHUnR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 15:43:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752351AbZAHUnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 15:43:03 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:53197 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167AbZAHUnB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 15:43:01 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pierre Ossman <drzeus@drzeus.cx>
Subject: Re: [Regression] hald segfaults at startup on Toshiba Portege R500 x86_64 (bisected)
Date: Thu, 8 Jan 2009 21:42:25 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rjw; KDE/4.1.3; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       " =?iso-8859-15?q?=C9ric?= Piel" <eric.piel@tremplin-utc.net>
References: <200901080827.02882.rjw@sisk.pl> <20090108093407.3efd0938@mjolnir.drzeus.cx>
In-Reply-To: <20090108093407.3efd0938@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901082142.26285.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 January 2009, Pierre Ossman wrote:
> On Thu, 8 Jan 2009 08:27:02 +0100
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > Hi,
> > 
> > Unfortunately the following commit:
> > 
> > commit 35ff8554d12ecc80a46ea0d9bce34fe28733ff38
> > Author: Éric Piel <eric.piel@tremplin-utc.net>
> > Date:   Sat Nov 22 19:29:29 2008 +0100
> > 
> >     sdhci: activate led support also when module
> > 
> >     CONFIG_LEDS_CLASS is defined only if led-class is built-in, otherwise
> >     when it is a module the option is called CONFIG_LEDS_CLASS_MODULE. Led
> >     support should also be activated in this case.
> > 
> >     Signed-off-by: Eric Piel <eric.piel@tremplin-utc.net>
> >     Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>
> > 
> > causes hald to segfault at startup (not always, but sufficiently often for
> > bisection) on my Toshiba Portege R500 w/ x86_64 kernel/userland.
> > 
> 
> I have trouble seeing a user space application crashing as a kernel
> bug. Do you have a backtrace or strace of hald to see exactly where it
> crashes?

No, I don't.  I'll try to get one later.

> > While it doesn't revert cleanly, I have applied the appended patch (which is
> > a revert of the commit above) and hald doesn't segfault any more here.
> > 
> 
> Is CONFIG_LEDS_CLASS defined in your config, or are you essentially
> turning of the LED functionality?

I have CONFIG_LEDS_CLASS=m (so I guess the patch just makes the led support
in sdhci active).

Thanks,
Rafael
