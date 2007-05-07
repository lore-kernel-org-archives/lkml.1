Return-Path: <linux-kernel-owner+w=401wt.eu-S933463AbXEGMA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933463AbXEGMA1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 08:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933354AbXEGMA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 08:00:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933388AbXEGMAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 08:00:25 -0400
Subject: Re: Please pull 'libertas' branch of wireless-2.6
From: Dan Williams <dcbw@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeff Garzik <jeff@garzik.org>, "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, marcelo@kvack.org,
       linux-kernel@vger.kernel.org, akpm@osdl.org
In-Reply-To: <20070507104117.GA31601@infradead.org>
References: <20070227205649.GH5826@tuxdriver.com>
	 <45E8CF5E.5090305@garzik.org> <20070303052140.GA31075@infradead.org>
	 <20070507104117.GA31601@infradead.org>
Content-Type: text/plain
Date: Mon, 07 May 2007 08:03:43 -0400
Message-Id: <1178539423.3032.24.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-07 at 11:41 +0100, Christoph Hellwig wrote:
> On Sat, Mar 03, 2007 at 05:21:40AM +0000, Christoph Hellwig wrote:
> > Umm, I can't remember the updated driver ever beeig posted for review.
> > And to be honest I'd be surprised if it's in a good shape already.
> 
> Of course it's not anywhere near good shape.  Almost all items from my
> review were completely ignored, and we have another totoally substandard
> wireless driver with crappy thread handling, a huge number of broken private
> ioctls and partially absymal codingstyle.

 - things like 11d.[ch] don't have business of being in a driver,
   this should be somewhere in common code.

There is no common code for this.  mac80211 will eventually grow a
utility library that libertas will hopefully be able to attach to.

 - please get rid of the ENTER/LEAVE macros

People have said that many drivers do this, and it's quite useful for
debugging.

 - please get rid of all your private ioctls and iwpriv stuff
   (should I add !!!! here)

Any ioctls that have equivalents in WEXT or ethtool can certainly be
removed.  Mesh ones like fwt_reset, bt_reset, mesh_get_ttl, etc have no
current equivalents and will need to stick around.  I've already removed
all the ones that were relevant for WPA and moved them to standard WEXT
calls.

 - most of types.h should not be there but you should be using
   the types from include/linux/*80211*

I've already updated libertas-2.6 git with a ton of updates for this.

In any case, lets push off any merge until 2.6.23 so the rest of the
comments can be dealt with:

 - the __le* annotation issue you mentioned in the mail is important.
 - there shouldn't be a LICENSE file in individual driver directories,
   especially if it's just plain old GPLv2.
 - please get rid of setting -DFOO flags in the Makefile, just use
   these directly as config symbols.
 - there shouldn't be a README file in the driver directory, this
   should be in Documentation/
 - please don't use wlan_* foo types.  a) this should be structs, not
   typedefs, and b) wlan is an utterly generic name for beeing inside
   a driver.
 - there seems to be lots of tabs vs spaces messups
 - there's an awful lot of headers without clear divided
responsibilities,
   there should be only a few ones left (internal interfaces and hw
   interface basically)
 - having lowercase names for lots of hw commands is a very bad idea
   for readability
 - etc

Dan

> And I didn't even get a reply to my mail addressing the concerns above.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

