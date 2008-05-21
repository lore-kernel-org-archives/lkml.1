Return-Path: <linux-kernel-owner+w=401wt.eu-S935366AbYEUOH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935366AbYEUOH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 10:07:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762892AbYEUOHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 10:07:43 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:39467 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759103AbYEUOHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 10:07:42 -0400
X-Sasl-enc: i35DhK7q/XjQV1IVCqnayDAtxI7cbb7UjTOG7ilxxKw0 1211378860
Date: Wed, 21 May 2008 11:07:39 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Inaky Perez-Gonzalez <inaky@linux.intel.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-kernel@vger.kernel.org,
       Thomas Renninger <trenn@suse.de>,
       "John W. Linville" <linville@tuxdriver.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 09/15] rfkill: add the WWAN radio type
Message-ID: <20080521140739.GA3677@khazad-dum.debian.net>
References: <1211136485-19878-1-git-send-email-hmh@hmh.eng.br> <200805202035.20529.inaky@linux.intel.com> <20080521034213.GE26427@khazad-dum.debian.net> <200805202348.39807.inaky@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805202348.39807.inaky@linux.intel.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2008, Inaky Perez-Gonzalez wrote:
> On Tuesday 20 May 2008, Henrique de Moraes Holschuh wrote:
> > On Tue, 20 May 2008, Inaky Perez-Gonzalez wrote:
> > > > Stuff like "WiMax", "802.1a", "EDGE", "GRPS", "802.1bg" would be the
> > > > type, and class would be "WLAN", "WWAN", etc.
> > > > 
> > > > We would only deal with classes on rfkill-input.  Anything else more
> > > > specific should be done in userspace instead, disabling rfkill-input.
> > > 
> > > How would this apply to the case where I want to use the HW key to switch
> > > one off and turn the other one off (say I have both a WiMAX and EDGE
> > > cards in my machine); how could we do it to distinguish which key is which?
> > > I might be missing something.
> > 
> > I don't understand.  Switch one off and turn the other one off?  Isn't
> > that the same thing?
> 
> -EOPERATORISDUMB, sorry; I meant turn one off and the other on. 

Then here's what you'd have with (class, type):

EITHER

1. rfkill-input would manipulate based on class for a given input event.
Therefore we would remove KEY_WIMAX from rfkill-input.

OR...

2. rfkill-input would be teached to manipulate for classes (all switches
in a class), and for (class,type) (hunt down all rfkill switches of that given
type and class)...   and it does mean KEY_WIMAX would only affect WiMAX
switches, while WWAN would affect EDGE, GPRS, *WIMAX*, etc.

And if you need anything different, you'd have to do it in userspace as
you want, and disable rfkill-input entirely, or for the switches you
want to override (using user_claim).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
