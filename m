Return-Path: <linux-kernel-owner+w=401wt.eu-S1756401AbYDGJKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401AbYDGJKw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 05:10:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755048AbYDGJKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 05:10:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53003 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754245AbYDGJKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 05:10:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Romano Giannetti <romanol@upcomillas.es>
Subject: Re: 2.6.25-rc6 regression - hang on resume [Bug 10319]
Date: Mon, 7 Apr 2008 11:10:39 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Soeren Sonnenburg <kernel@nn7.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bugme-daemon@bugzilla.kernel.org, Jesse Barnes <jesse.barnes@intel.com>,
       suspend-devel@lists.sourceforge.net
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik> <1207290689.4511.1.camel@localhost> <1207552602.26185.13.camel@pern>
In-Reply-To: <1207552602.26185.13.camel@pern>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804071110.39933.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 7 of April 2008, Romano Giannetti wrote:
> 
> On Fri, 2008-04-04 at 08:31 +0200, Soeren Sonnenburg wrote:
> > On Fri, 2008-04-04 at 01:22 +0200, Rafael J. Wysocki wrote:
>>
> > Yes. The machine resumes and display stays black using s2ram -f -p
> > (blindly typing reboot etc on keyboard does what is expected). However
> > display comes back on 2.6.24.
> 
> I can add that on my laptop (toshiba U305, Intel 945GM chipset), s2ram
> -f -p -m which used to work ok, in X and console, in 2.6.24 stopped to
> work (I tested -rc8, but I think it's like that since a long time).
> Machine resumes but the screen stays off after that, although machine is
> working (exactly as Soeren said).

Your graphics adapter is different from the Soeren's one and the fact that
"echo mem > /sys/power/state" works for you now is probably a result of the
recent changes in the i915 driver that is now supposed to handle suspend
and resume.

That said, there had to be a change that affected both of your systems
between 2.6.24 and .25-rc8.  Moreover, I'm suspecting ACPI or something
generic in the DRM core.

As far as ACPI is concerned, one commit related to backlight has just been
reverted, so Soeren, can you please test the current Linus' tree?
