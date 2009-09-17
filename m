Return-Path: <linux-kernel-owner+w=401wt.eu-S1753447AbZIQUYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbZIQUYi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 16:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753149AbZIQUYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 16:24:37 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:57027 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123AbZIQUYg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 16:24:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=UhOr3svapWx8xX6tdNV3LAie54py8blixqMLhj1A7nrFCniOHHnNt5dgEcukr9LnkB
         2po3gGNK0Kkrb+KE7vG7bAFk8B2ocLcVS1Rx4iXZOkVgGZ62TDff3aERrGj8esAe0Lx8
         2YYIPN92kdFZUtWmLdpUu7HJjlfvv1vWnKdX4=
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: rt2x00dev.c:405: error: too few arguments to function =?utf-8?q?=E2=80=98rt2x00crypto=5Frx=5Finsert=5Fiv=E2=80=99?=
Date: Thu, 17 Sep 2009 22:24:37 +0200
User-Agent: KMail/1.9.10
Cc: Andrew Price <andy@andrewprice.me.uk>, linux-kernel@vger.kernel.org
References: <20090917154138.GA31844@sucs.org> <20090917181133.GA5797@sucs.org> <20090917195811.GC2562@tuxdriver.com>
In-Reply-To: <20090917195811.GC2562@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200909172224.37798.IvDoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 September 2009, John W. Linville wrote:
> On Thu, Sep 17, 2009 at 07:11:33PM +0100, Andrew Price wrote:
> > On Thu, Sep 17, 2009 at 01:23:59PM -0400, John W. Linville wrote:
> > > On Thu, Sep 17, 2009 at 04:41:39PM +0100, Andrew Price wrote:
> > > > Hi Ivo,
> > > > 
> > > > Apologies if this has already been reported. Building today's mainline
> > > > kernel (ab86e5) I'm seeing this error:
> > > > 
> > > > drivers/net/wireless/rt2x00/rt2x00dev.c: In function ‘rt2x00lib_rxdone’:
> > > > drivers/net/wireless/rt2x00/rt2x00dev.c:405: warning: passing argument 3 of ‘rt2x00crypto_rx_insert_iv’ makes integer from pointer without a cast
> > > > drivers/net/wireless/rt2x00/rt2x00dev.c:405: error: too few arguments to function ‘rt2x00crypto_rx_insert_iv’
> > > 
> > > Strange...I don't see this warning.  Are you sure you have a clean checkout?
> > 
> > I double-checked:
> > 
> > - git status returned no changes
> > - git clean -fqdx
> > - ccache -C
> > - Retried the build
> > 
> > and still got the same error. Is this something to do with the second
> > definition of rt2x00crypto_rx_insert_iv still having an l2pad parameter...
> > 
> > This (untested) patch fixes the build for me:
> 
> Oh, I see now -- thanks for the patch!  FWIW, it would seem to only
> show-up when you have CONFIG_RT2500PCI but none of the other rt2x00
> family drivers in your .config...

Ah yes, that patch looks correct, indeed this is only triggered when only
CONFIG_RT2400PCI and/or CONFIG_RT2500PCI are selected without the
other drivers (which support HW crypto).

Ivo
