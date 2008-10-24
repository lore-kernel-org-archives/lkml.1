Return-Path: <linux-kernel-owner+w=401wt.eu-S1756786AbYJXVeI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786AbYJXVeI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 17:34:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754708AbYJXVdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 17:33:54 -0400
Received: from ns2.suse.de ([195.135.220.15]:42636 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092AbYJXVdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 17:33:53 -0400
Date: Fri, 24 Oct 2008 14:28:04 -0700
From: Greg KH <gregkh@suse.de>
To: Elias Oltmanns <eo@nebensachen.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Bob Copeland <me@bobcopeland.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [patch 27/27] ath5k: fix suspend-related oops on rmmod
Message-ID: <20081024212804.GA15776@suse.de>
References: <20081024042023.054190751@mini.kroah.org> <20081024043530.GB30828@kroah.com> <87ej253f3r.fsf@denkblock.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87ej253f3r.fsf@denkblock.local>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2008 at 10:36:24PM +0200, Elias Oltmanns wrote:
> Greg KH <gregkh@suse.de> wrote:
> > 2.6.27-stable review patch.  If anyone has any objections, please let us 
> > know.
> >
> > ------------------
> > From: Bob Copeland <me@bobcopeland.com>
> >
> > commit 8bdd5b9c6bd53add260756b6673a0545fbdbba21 upstream
> >
> > Based on a patch by Elias Oltmanns, we call ath5k_init in resume even
> > if we didn't previously open the device.  Besides starting up the
> > device unnecessarily, this also causes an oops on rmmod because
> > mac80211 will not invoke ath5k_stop and softirqs are left running after
> > the module has been unloaded.  Add a new state bit, ATH_STAT_STARTED,
> > to indicate that we have been started up.
> >
> > Reported-by: Toralf Förster <toralf.foerster@gmx.de>
> > Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
> > Signed-off-by: Bob Copeland <me@bobcopeland.com>
> > Signed-off-by: John W. Linville <linville@tuxdriver.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> I've done some more testing and I'm ashamed to say that this patch is
> incomplete and does indeed introduce a regression itself. Having only
> just sent the fix to John, I'm afraid this patch has to be deferred for
> the next stable release since the required fix is not likely to hit
> Linus' tree in time. Anyway, I'm adding my patch and the changelog entry
> by way of explanation.

Ok, I've dropped this from the 2.6.27-stable queue now, thanks for
letting me know.

greg k-h
