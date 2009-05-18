Return-Path: <linux-kernel-owner+w=401wt.eu-S1759324AbZERQTK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759324AbZERQTK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 12:19:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758896AbZERQR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 12:17:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60448 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758844AbZERQRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 12:17:25 -0400
Subject: Re: iwlagn broken in next-20090514 and next-20090515
From: Dan Williams <dcbw@redhat.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Nico -telmich- Schottelius <nico-linux-next@schottelius.org>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       johannes@sipsolutions.net
In-Reply-To: <1242662635.32358.523.camel@rc-desk>
References: <20090515153733.4384db9f.sfr@canb.auug.org.au>
	 <20090515102621.GA5735@ikn.schottelius.org>
	 <20090518171505.d30d2f64.sfr@canb.auug.org.au>
	 <1242662635.32358.523.camel@rc-desk>
Content-Type: text/plain
Date: Mon, 18 May 2009 12:16:40 -0400
Message-Id: <1242663400.6530.18.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-05-18 at 09:03 -0700, reinette chatre wrote:
> On Mon, 2009-05-18 at 00:15 -0700, Stephen Rothwell wrote:
> > Add cc's
> > 
> > On Fri, 15 May 2009 12:26:21 +0200 Nico -telmich- Schottelius <nico-linux-next@schottelius.org> wrote:
> > >
> > > Kernel is not authenticating it against the AP anymore with
> > > messages like:
> > > 
> > > [16907.701634] wlan0: associate with AP 00:03:52:4e:f3:d1
> > > [16907.703669] wlan0: RX AssocResp from 00:03:52:4e:f3:d1 (capab=0x421 status=0 aid=5)
> > > [16907.703672] wlan0: associated
> > > [16907.729958] wlan0: disassociating by local choice (reason=3)
> 
> This is usually printed when your user application (wpa_supplicant,
> network manager, etc.) goes down or disassociates.

Yeah, this is normal and indicates that the supplicant called
SIOCGIWMLME, which could either be triggered internally by the
supplicant, or even more likely, because NetworkManager requests that
the supplicant disconnects nicely before switching networks or taking
the connection down.

Dan

> > > [16907.852112] wlan0: direct probe to AP 00:03:52:1b:f8:31 try 1
> > > [16908.052086] wlan0: direct probe to AP 00:03:52:1b:f8:31 try 2
> > > [16908.055331] wlan0 direct probe responded
> > > [16908.055335] wlan0: authenticate with AP 00:03:52:1b:f8:31
> > > [16908.256065] wlan0: authenticate with AP 00:03:52:1b:f8:31
> > > [16908.453689] wlan0: authenticate with AP 00:03:52:1b:f8:31
> > > [16908.656037] wlan0: authentication with AP 00:03:52:1b:f8:31 timed out
> 
> Don't know what is going on here. Could your AP be out of reach or not
> responding?
> 
> > > 
> > > Also wpa_supplicant is not happy:
> > > 
> > > + wpa_supplicant -B -Dwext -iwlan0 -c /home/user/nico/ethz/wlan/wpa_supplicant.conf
> > > ioctl[SIOCSIWENCODEEXT]: No such file or directory
> > > ioctl[SIOCSIWENCODEEXT]: No such file or directory
> > > ioctl[SIOCSIWENCODEEXT]: No such file or directory
> > > ioctl[SIOCSIWENCODEEXT]: No such file or directory
> > > 
> 
> There were some changes recently to this ioctl, but I am not familiar
> with details. Johannes will know.
> 
> Reinette
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

