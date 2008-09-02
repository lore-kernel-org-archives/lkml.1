Return-Path: <linux-kernel-owner+w=401wt.eu-S1754322AbYIBUur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322AbYIBUur (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 16:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754049AbYIBUug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 16:50:36 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:61243 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbYIBUue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 16:50:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iwRrfZsNw901Mg1kxuxHpsK3iC5EhgjFFSecREOCTXC+93GfAc5DWuzROlCigs0dRg
         UgMwAGuEbBlkybaIbOF1V8p7P6eqrOCdaiIDsdhnC4TM/qkhXkFzM15R0nrXLFSA75ek
         P12Xjd5IfeVv2sP6ofr4FGT+SlaEPOJwyLV5I=
Date: Tue, 2 Sep 2008 23:50:23 +0300
From: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
To: Jouni Malinen <j@w1.fi>
Cc: Dan Williams <dcbw@redhat.com>, Johannes Berg <johannes@sipsolutions.net>,
       Zhu Yi <yi.zhu@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, reinette.chatre@intel.com,
       linux-wireless@vger.kernel.org,
       Jan-Espen Pettersen <sigsegv@radiotube.org>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: new: regression iwl3945/mac80211 endless after suspend
	associate/deassociate loop
Message-ID: <20080902205022.GA8230@google.com>
References: <20080901160658.GA11063@google.com> <1220319536.28282.128.camel@debian.sh.intel.com> <4b0be9b641de902cb7de4ad50686f6e1.squirrel@secure.sipsolutions.net> <20080902130429.GB19172@google.com> <1220362201.3176.4.camel@borkbork.foobar.com> <20080902145840.GE19172@google.com> <1220368238.8041.4.camel@borkbork.foobar.com> <20080902172409.GJ17345@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080902172409.GJ17345@jm.kir.nu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2008 at 08:24:09PM +0300, Jouni Malinen wrote:
> On Tue, Sep 02, 2008 at 11:10:38AM -0400, Dan Williams wrote:
> > On Tue, 2008-09-02 at 17:58 +0300, Michael S. Tsirkin wrote:
> > > On Tue, Sep 02, 2008 at 09:30:01AM -0400, Dan Williams wrote:
> > > > On Tue, 2008-09-02 at 16:04 +0300, Michael S. Tsirkin wrote:
> 
> > > > > On Tue, Sep 02, 2008 at 08:10:09AM +0200, Johannes Berg wrote:
> > > > > > "by local choice" means wext requested this, not a kernel bug.
> 
> Well.. The disassociation part not, but what is trickering that
> (association/authentication timeout) may still be ;-).
> 
> 
> > > I put up a (sanitized) -dd output here
> > > http://bugzilla.kernel.org/show_bug.cgi?id=11476
> 
> Would it be possible to get unsanitized version and with -t (i.e.,
> timestamps)? If you don't want to post it publicly, feel free to send
> one directly to me. The one attached to that bug removed quite a bit of
> information that would have been useful in figuring out what happened.

Could you tell me which bits are needed, and don't include
security info? I wouldn't want to post the PSK, etc.

> > Logs seem to indicate a normal failure of the 4 way handshake; are you
> > sure your PSK is correct?  It actually looks like the AP doesn't ever
> > get message #2 from your machine, and just retransmits message #1 of the
> > handshake.  I'm pretty sure that if
> > 8ab65b03b7893da4a49009e7e356e36e27b0c407 had anything to do with it, you
> > wouldn't be getting this far and the AP would have denied association in
> > the first place.
> 
> There are more than one different types of issues shown in the log. I'm
> not sure which one would be the key one here. Anyway, I would agree that
> the commit that removed an empty ext. supp rates IE has nothing to do
> with this.
> 
> 
> As far as suspend is concerned, which distro is used here?

ubuntu gutsy

> Does it
> unload the driver (i.e., remove the netdev) on suspend? If yes, you will
> need to update wpa_supplicant 0.6.4 which handles that disappearing and
> reappearing interface.

Hmm, since it manages to reassociate with -rc4 I would guess not.
In any case killing wpa_supplicant after reboot and restarting it does not
seem to help.

> If this is something else, I would need to get
> more complete debug log from wpa_supplicant..
> 
> -- 
> Jouni Malinen                                            PGP id EFC895FA
