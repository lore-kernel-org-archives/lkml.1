Return-Path: <linux-kernel-owner+w=401wt.eu-S935161AbYEUBNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935161AbYEUBNd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 21:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932166AbYEUBNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 21:13:04 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:57121 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761918AbYEUBNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 21:13:01 -0400
X-Sasl-enc: BCmraVInzGYcuQibThOFiEm9EhL4ydNvIGzXacw0exOG 1211332379
Date: Tue, 20 May 2008 22:12:57 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
       Inaky Perez-Gonzalez <inaky@linux.intel.com>,
       =?iso-8859-1?Q?I=F1aky_P=E9rez-Gonz=E1lez?= 
	<inaky.perez-gonzalez@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 09/15] rfkill: add the WWAN radio type
Message-ID: <20080521011257.GA26427@khazad-dum.debian.net>
References: <1211136485-19878-1-git-send-email-hmh@hmh.eng.br> <1211136485-19878-10-git-send-email-hmh@hmh.eng.br> <200805201208.53740.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805201208.53740.IvDoorn@gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2008, Ivo van Doorn wrote:
> On Sunday 18 May 2008, Henrique de Moraes Holschuh wrote:
> > Unfortunately, instead of adding a generic Wireless WAN type, a technology-
> > specific type (WiMAX) was added.  That's useless for other WWAN devices,
> > such as EDGE, UMTS, X-RTT and other such radios.
> > 
> > Add a WWAN rfkill type for generic wireless WAN devices.  No keys are added
> > as most devices really want to use KEY_WLAN for WWAN control (in a cycle of
> > none, WLAN, WWAN, WLAN+WWAN) and need no specific keycode added.
> >
> > Signed-off-by: Inaky Perez-Gonzalez <inaky@linux.intel.com>
> 
> If WiMAX is a subset of the WWAN technology, shouldn't we replace WiMAX completely
> in rfkill? Otherwise people might get ideas and add the other technologies seperately as well. ;)
> 
> Other then that, the addition of WWAN is fine with me. :)

Actually, I have no reason to believe there *isn't* a device with
KEY_WIMAX... but we need the WWAN type before we bother with a WiMax
type :-)

IMO, we should fix the issue by adding a "supertype", i.e., a class.
Use that for generic grouping, and let type be more specific when there
is a reason for it.  Repeat the class as the type to get a "generic"
type, when there is no reason to bother with more specific types.

Stuff like "WiMax", "802.1a", "EDGE", "GRPS", "802.1bg" would be the
type, and class would be "WLAN", "WWAN", etc.

We would only deal with classes on rfkill-input.  Anything else more
specific should be done in userspace instead, disabling rfkill-input.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
