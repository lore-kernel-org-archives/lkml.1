Return-Path: <linux-kernel-owner+w=401wt.eu-S1751945AbZIQUAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945AbZIQUAf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 16:00:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751094AbZIQUAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 16:00:33 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47066 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbZIQUAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 16:00:32 -0400
Date: Thu, 17 Sep 2009 15:58:11 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Andrew Price <andy@andrewprice.me.uk>, Ivo van Doorn <ivdoorn@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: rt2x00dev.c:405: error: =?utf-8?Q?too_?=
	=?utf-8?Q?few_arguments_to_function_=E2=80=98rt2x00crypto=5Frx=5Finsert?=
	=?utf-8?B?X2l24oCZ?=
Message-ID: <20090917195811.GC2562@tuxdriver.com>
References: <20090917154138.GA31844@sucs.org> <20090917172358.GC2577@tuxdriver.com> <20090917181133.GA5797@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090917181133.GA5797@sucs.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 07:11:33PM +0100, Andrew Price wrote:
> On Thu, Sep 17, 2009 at 01:23:59PM -0400, John W. Linville wrote:
> > On Thu, Sep 17, 2009 at 04:41:39PM +0100, Andrew Price wrote:
> > > Hi Ivo,
> > > 
> > > Apologies if this has already been reported. Building today's mainline
> > > kernel (ab86e5) I'm seeing this error:
> > > 
> > > drivers/net/wireless/rt2x00/rt2x00dev.c: In function ‘rt2x00lib_rxdone’:
> > > drivers/net/wireless/rt2x00/rt2x00dev.c:405: warning: passing argument 3 of ‘rt2x00crypto_rx_insert_iv’ makes integer from pointer without a cast
> > > drivers/net/wireless/rt2x00/rt2x00dev.c:405: error: too few arguments to function ‘rt2x00crypto_rx_insert_iv’
> > 
> > Strange...I don't see this warning.  Are you sure you have a clean checkout?
> 
> I double-checked:
> 
> - git status returned no changes
> - git clean -fqdx
> - ccache -C
> - Retried the build
> 
> and still got the same error. Is this something to do with the second
> definition of rt2x00crypto_rx_insert_iv still having an l2pad parameter...
> 
> This (untested) patch fixes the build for me:

Oh, I see now -- thanks for the patch!  FWIW, it would seem to only
show-up when you have CONFIG_RT2500PCI but none of the other rt2x00
family drivers in your .config...

John

P.S.  Could you resubmit to linux-wireless@vger.kernel.org, following
the normal patch submission guidelines as discussed here?

	http://linux.yyz.us/patch-format.html

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
