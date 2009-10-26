Return-Path: <linux-kernel-owner+w=401wt.eu-S1754842AbZJZHZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842AbZJZHZj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 03:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754793AbZJZHZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 03:25:39 -0400
Received: from smtp.witbe.net ([81.88.96.48]:59564 "EHLO smtp.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754789AbZJZHZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 03:25:38 -0400
Date: Mon, 26 Oct 2009 08:25:25 +0100
From: Paul Rolland <rol@as2917.net>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Frans Pop <elendil@planet.nl>, Theodore Tso <tytso@mit.edu>,
       "Carlos R. Mafra" <crmafra2@gmail.com>, Eric Anholt <eric@anholt.net>,
       linux-kernel@vger.kernel.org, Keith Packard <keithp@keithp.com>,
       Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: 2.6.32 regression (bisected): Video tearing/glitching with T400
 laptops
Message-ID: <20091026082525.59d6ed6a@tux.DEF.witbe.net>
In-Reply-To: <20091019101526.5496d5ed@jbarnes-x200>
References: <20091010204106.GA8251@mit.edu>
	<20091012095438.1e82b54f@jbarnes-g45>
	<20091012184651.GA4603@Pilar.aei.mpg.de>
	<20091012120510.16bd1194@jbarnes-g45>
	<20091013023146.GA8414@mit.edu>
	<20091013100135.2b3d914f@jbarnes-g45>
	<20091013190055.GI8175@mit.edu>
	<20091013121426.35f409ff@jbarnes-g45>
	<20091014142252.009d03a5@jbarnes-g45>
	<20091015022645.GA8286@mit.edu>
	<20091015040204.GE8286@mit.edu>
	<20091019100437.22b6ea36@jbarnes-x200>
	<20091019101526.5496d5ed@jbarnes-x200>
Organization: AS2917.net
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWsjH1VRjFydFciEg3a1tJxUEM6OCB1zdsDAAACcElEQVQ4jV2Tu3LcMAxFEY7SG/KQNYlY2685Zi1rmF5kQteBNcL/f0JAacfZDUscARePK9itY3Q4Qu5vplJKIFsrvI0t7Ii/8/nmQsERtgJpHAtiGW4ggylOAwhXTxPi0xfIcxDrZIc3qhMGD/kfKdwBExZrAf6l5PeC/Al7cAGfAGD+AgvL5yckcsxegVmG+QZRPgnYXnFUMAC8DLd6QZhAxj6dRo6vT/JNkmZQmPyDtoroMkD2VlaVgHsw2QrCAf1jPM+ou2Ju1j/G8+xINfZT+zGDPDjr7H/xnKewgi6SO4D7zloYoRDafSoogmirP0t9YIOJnN2ibDEKK6zDoSEjTIFXDcYYkwizoO/AjkATm3g+JVsSXPOCZIHwj7uBo2Bi97RMOoflJ4n3b3dvS2kVXDQupjvAk7zvaMEJlu0OJDFy4SsCusRbL95jRynY0LIA/rpyxCMkJ1ie+bWoEy+MG7pzDE3k8Z2C1a5eUdxmi0adGi2mdVjyUr2uvamrW9EeuLTCY84/AUjBj40LtqYbbM23vqolA2mpj5g03gparH45DqBgmsBK2hU0x662+QQLVYJLitxTnHB7yf0es4rraS/xqKW/hF1zPg9lOijpmtIBVrWKOQ6oTSkQjh3YtnarHQc0RrtS1XjtbQnScPrLeNKM6iS+6Qz6e9mVoPvaHHPU6eP5aKu1Ifd2QQvp6EA1bLaP3VREwewXY73xgLppBR2tg4LFg9lXzegHQlusWuxwogLCaswJ+qunQ2cyfuziX6B1p0E26nQazR3Qn2jQarRXVVZT9zP3uB5FV6pNjQG+u03ugbalEsEXqo7/AjAH60VpvOMvAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, 19 Oct 2009 10:15:26 +0900
Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> On Mon, 19 Oct 2009 10:04:37 +0900
> Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> 
> > On Thu, 15 Oct 2009 00:02:04 -0400
> > Theodore Tso <tytso@mit.edu> wrote:
> > 
> > > On Wed, Oct 14, 2009 at 10:26:45PM -0400, Theodore Tso wrote:
> > > > 
> > > > If I need to live with a display glitch every 5-10 minutes or so
> > > > to get better power savings, I'll take it....
> > > > 
> > > 
> > > While mail reading and composing responses in a tty based mail
> > > reader (mutt/emacs -nw), I'm seeing display glitches every 3-5
> > > minutes.  Each time it's quite minor so it's the sort of thing
> > > which is definitely "blink at the wrong time and you'll miss it".
> > > 
> > > Being a battery lifetime freak, I'll definitely take the tradeoff,
> > > but given that it occurs even when I'm plugged into AC mains, I
> > > could see some users being annoyed by it, and I could see them
> > > wanting to be able to switch off the feature when they are on AC,
> > > if we find a complete fix.
> > 
> > Ok, hopefully this is the "correct" patch.  It works for me, can you
> > give it a try?
> 
> Here's an even more "final" patchset with some spurious hunks removed.
> 

This is also fixing the problem I had with my Vostro !:)
Thanks Frans for pointing my to this patches.

Tested-By: Paul Rolland <rol@as2917.net>

Regards,
Paul


