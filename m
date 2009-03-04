Return-Path: <linux-kernel-owner+w=401wt.eu-S1756274AbZCDNfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274AbZCDNfS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 08:35:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbZCDNfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 08:35:04 -0500
Received: from zwopi.Informatik.Uni-Oldenburg.DE ([134.106.11.77]:57583 "EHLO
	overload-mx.Informatik.Uni-Oldenburg.DE" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752778AbZCDNfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 08:35:03 -0500
X-Greylist: delayed 1285 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Mar 2009 08:35:03 EST
Date: Wed, 4 Mar 2009 14:13:33 +0100
From: Philipp Matthias Hahn <pmhahn@titan.lahn.de>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: /proc/sys/net/ip*/conf/all/* does not actually affect
	interfaces
Message-ID: <20090304131333.GA16070@wi-ol.de>
Mail-Followup-To: linux kernel mailing list <linux-kernel@vger.kernel.org>
References: <20090302122718.GA3906@piper.oerlikon.madduck.net> <20090303070025.GA5042@pmhahn.de> <20090303192747.GA16226@piper.oerlikon.madduck.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090303192747.GA16226@piper.oerlikon.madduck.net>
Organization: UUCP-Freunde Lahn e.V.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Martin!

On Tue, Mar 03, 2009 at 08:27:47PM +0100, martin f krafft wrote:
> also sprach Philipp Matthias Hahn <pmhahn@titan.lahn.de> [2009.03.03.0800 +0100]:

> > Putting a new value in "all" doesn't change the value you read
> > from "$interface", but it only gets computed and used internally.
> 
> Hm, that clears it up... kinda. It does *not* explain by the RAs
> were still accepted (ipv6.conf.all.accept_ra and .autoconf where
> both 0), so unless those values are (wrongly) OR'd, I will need to
> investigate this.

I took another look at
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=include/linux/inetdevice.h;hb=HEAD#l102

102 #define IN_DEV_RX_REDIRECTS(in_dev) \
103         ((IN_DEV_FORWARD(in_dev) && \
104           IN_DEV_ANDCONF((in_dev), ACCEPT_REDIRECTS)) \
105          || (!IN_DEV_FORWARD(in_dev) && \
106           IN_DEV_ORCONF((in_dev), ACCEPT_REDIRECTS)))

"accept_redirect" depends on "forwarding": If forwarding is enabled,
it's ANDed, if it's disabled, it's ORed.

> > "all" on the other hand allways gets applied in addition to the current
> > setting, but it depends on the exact setting, if its ORed, ANDed, or
> > whatevered:
> [...]
> 
> Oh wow. This is very underdocumented.

Yes, I only can agree with you.

BYtE
Phhilipp Hahn
-- 
  / /  (_)__  __ ____  __ Philipp Hahn
 / /__/ / _ \/ // /\ \/ /
/____/_/_//_/\_,_/ /_/\_\ pmhahn@titan.lahn.de
