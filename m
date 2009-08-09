Return-Path: <linux-kernel-owner+w=401wt.eu-S1752320AbZHIREE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320AbZHIREE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 13:04:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbZHIREE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 13:04:04 -0400
Received: from bar.sig21.net ([80.81.252.164]:45473 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552AbZHIREC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 13:04:02 -0400
Date: Sun, 9 Aug 2009 19:04:01 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31-rc5 regression: ath5k broken after suspend-to-ram
Message-ID: <20090809170401.GB16332@sig21.net>
References: <20090807215155.GA17043@sig21.net>
 <b6c5339f0908090906p3d29fdd2x8473dcc6df178167@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b6c5339f0908090906p3d29fdd2x8473dcc6df178167@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-21-Score: -3.9 (---)
X-Spam-21-Report: No, score=-3.9 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.464,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 09, 2009 at 12:06:03PM -0400, Bob Copeland wrote:
> On Fri, Aug 7, 2009 at 5:51 PM, Johannes Stezenbach<js@sig21.net> wrote:
> 
> > If I use nl80211 the second ifup fails with
> > "SIOCSIFFLAGS: Input/output error" messages and the follwing
> > is in dmesg:
> >
> >   ath5k phy0: failed to wakeup the MAC Chip
> >   ath5k phy0: can't reset hardware (-5)
> 
> Ok, does this patch help the above?
> 
> http://patchwork.kernel.org/patch/38550/

Yes, it helps a lot!  The above wakeup error is gone,
and as a result I can switch to use the wpa_supplicant
nl80211 driver.  With the nl80211 driver everything works.

However, with the wpa_supplicant wext driver the issue remains
that only the frst ifup after module load works, the second
ifup shows the association problem most of the time (but not always).
So this turns out to be a mix of two problems, with the wext one
not having anything to do with suspend/resume.

If you want me to test something wext related, let me know.
Otherwise I'm fine with using nl80211.


Thanks,
Johannes
