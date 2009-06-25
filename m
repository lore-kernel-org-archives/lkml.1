Return-Path: <linux-kernel-owner+w=401wt.eu-S1754443AbZFYQHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443AbZFYQHW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 12:07:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753230AbZFYQHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 12:07:11 -0400
Received: from smtp.nokia.com ([192.100.105.134]:32227 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbZFYQHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 12:07:09 -0400
Subject: Re: [PATCH]input: Change timer function to workqueue for gpio_keys
	driver
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
Reply-To: ext-phil.2.carmody@nokia.com
To: ext Alek Du <alek.du@intel.com>
Cc: "Nikula Jani.1 (EXT-Nixu/Helsinki)" <ext-jani.1.nikula@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Trilok Soni <soni.trilok@gmail.com>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       "ben-linux@fluff.org" <ben-linux@fluff.org>
In-Reply-To: <20090625234846.1b987069@dxy.sh.intel.com>
References: <20090608152420.0e76c302@dxy.sh.intel.com>
	 <5d5443650906121040n3f36c99eka01f5eb5274ee6ff@mail.gmail.com>
	 <359ed6810906250329x70cf380cy278f23e3ebc6a829@mail.gmail.com>
	 <20090625210642.432e08a5@dxy.sh.intel.com>
	 <1245936693.20530.107.camel@jani-desktop>
	 <20090625220826.1fa7413e@dxy.sh.intel.com>
	 <1245941565.20530.134.camel@jani-desktop>
	 <1245942355.20530.141.camel@jani-desktop>
	 <20090625230949.53beda65@dxy.sh.intel.com>
	 <1245944528.20530.145.camel@jani-desktop>
	 <20090625234846.1b987069@dxy.sh.intel.com>
Content-Type: text/plain
Organization: Nokia Oyj
Date: Thu, 25 Jun 2009 19:09:14 +0300
Message-Id: <1245946154.9103.742.camel@pcarmody-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Jun 2009 16:07:01.0551 (UTC) FILETIME=[F97B93F0:01C9F5AE]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-06-25 at 17:48 +0200, ext Alek Du wrote:
> On Thu, 25 Jun 2009 23:42:08 +0800
> Jani Nikula <ext-jani.1.nikula@nokia.com> wrote:
> 
> > On Thu, 2009-06-25 at 17:09 +0200, ext Alek Du wrote:
> > > On Thu, 25 Jun 2009 23:05:55 +0800
> > > Jani Nikula <ext-jani.1.nikula@nokia.com> wrote:
> > > > Actually scrap that, the input layer already ignores events with no
> > > > state changes, right?
> > > > 
> > > Yes, correct. I just want to reply your previous mail, but seems you find that. :-)
> > 
> > The point about your patch breaking debouncing is still valid, though.
> > 
> >
> How? If IRQ triggered then the delay work scheduled, after debouncing time, in work, it checks GPIO pin state again,
> if pin is active, send "1" to input layer -- key pressed, if de-active, send "0" -- no event. 
> 
> I really did test on my board, could you also try it out?

This is not a matter of testing, this error can be seen simply by
algorithm analysis - that's how Jani and I discovered the problem in the
first place.

If you stopped calling the delay after the first transition "debouncing
time" and simply called it a "delay" you might more easily see that it
does *no* debouncing at all. Imagine putting noise on the line
constantly - the original code's timer would never expire. Your timer
will expire after a delay, and while the line is still toggling
frantically - you've not debounced.

Please investigate the meaning and implications of "debouncing" before
claiming your code does it.

Phil

