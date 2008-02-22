Return-Path: <linux-kernel-owner+w=401wt.eu-S1765604AbYBVTL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765604AbYBVTL7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 14:11:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762999AbYBVTLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 14:11:43 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:2253 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755526AbYBVTLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 14:11:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=BfBYS0MPXmBPOJCswK1P6AgopfODMUttDEMsDInlDwgakNr1w1xN7b6ROP+oruaAIsmyUAxKcDn3A9/y9rVSpt9nLM8qQY41MZ8Js/V/u2gZouBAa9ygA7jYVyG1OxawJQDbOts88hJ1syzu/PdRj5hkkT4ythckMXxAg7VAWaE=
To: chris2553@googlemail.com
Subject: Re: [Rt2400-devel] 2.6.25-rc2 regression in rt61pci wireless driver
Date: Fri, 22 Feb 2008 20:11:15 +0100
User-Agent: KMail/1.9.7
Cc: Chris Vine <chris@cvine.freeserve.co.uk>, Dan Williams <dcbw@redhat.com>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       rt2400-devel@lists.sourceforge.net
References: <c6b1100b0802160406l24fed9dcje1dbfc8907fd7a16@mail.gmail.com> <1203636027.3186.5.camel@boulder.homenet> <200802220739.15366.chris2553@googlemail.com>
In-Reply-To: <200802220739.15366.chris2553@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802222011.16225.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 February 2008, Chris Clayton wrote:
> On Thursday 21 February 2008, Chris Vine wrote:
> > On Thu, 2008-02-21 at 23:04 +0000, Chris Clayton wrote:
> > > On Thursday 21 February 2008, Ivo van Doorn wrote:
> > > > On Thursday 21 February 2008, Chris Vine wrote:
> > [snip]
> > > > > This probably explains the problem another user reported with rt61.
> > > > 
> > > > Perhaps something similar like:
> > > > http://bugzilla.kernel.org/show_bug.cgi?id=10058
> > > > in there a reference is made to the following patch:
> > > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc2/2.6.25-rc2-mm1/broken-out/revert-send-a-single-notification-on-device-state-changes.patch
> > > > 
> > > > Does applying that help?
> > > 
> > > I'm afraid not, Ivo. The test I ran last night was against 2.6.25.-rc2-git4 and
> > > that already has this patch applied. Furthermore, I have another card that uses
> > > the rtl8180 driver and that works reliably. I, therefore, suspect that my problem
> > > lies within the rt61pci driver or the rt2x00 infrastructure.
> > 
> > Does the same happen with 2.0.14 under kernel 2.6.24?
> 
> Unfortunately, a 2.6.24.2 tree with the drivers/net/wireless/rt2x00 directory replaced with that from 2.6.25-rc2-git4 doesn't build:

You need the mac80211 compat  module from Intel. That allows new mac80211 versions to run
on older kernels. When you use that you need to grab the rt2x00 cvs tarball from:
http://rt2x00.serialmonkey.com/wiki/index.php/Downloads

which allows rt2x00 to be compiled outside of the kernel.

> In file included from drivers/net/wireless/rt2x00/rt2x00dev.c:29:
> drivers/net/wireless/rt2x00/rt2x00.h:942: warning: `struct ieee80211_bss_conf' declared inside parameter list
> drivers/net/wireless/rt2x00/rt2x00.h:942: warning: its scope is only this definition or declaration, which is probably not what you want
> 
> [...]
> 
> drivers/net/wireless/rt2x00/rt2x00dev.c: In function `rt2x00lib_configuration_scheduled':
> drivers/net/wireless/rt2x00/rt2x00dev.c:484: error: storage size of `bss_conf' isn't known
> drivers/net/wireless/rt2x00/rt2x00dev.c:494: error: `BSS_CHANGED_ERP_PREAMBLE' undeclared (first use in this function)
> drivers/net/wireless/rt2x00/rt2x00dev.c:494: error: (Each undeclared identifier is reported only once
> drivers/net/wireless/rt2x00/rt2x00dev.c:494: error: for each function it appears in.)
> drivers/net/wireless/rt2x00/rt2x00dev.c:484: warning: unused variable `bss_conf'
> drivers/net/wireless/rt2x00/rt2x00dev.c: In function `rt2x00lib_beacondone_scheduled':
> drivers/net/wireless/rt2x00/rt2x00dev.c:511: warning: passing arg 2 of `ieee80211_beacon_get' makes integer from pointer without a cast

Ivo
