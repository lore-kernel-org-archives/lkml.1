Return-Path: <linux-kernel-owner+w=401wt.eu-S1752383AbYJYUs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383AbYJYUs5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 16:48:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751098AbYJYUst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 16:48:49 -0400
Received: from kroah.org ([198.145.64.141]:50702 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750854AbYJYUst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 16:48:49 -0400
Date: Sat, 25 Oct 2008 13:28:17 -0700
From: Greg KH <greg@kroah.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [patch 11/27] dm exception store: refactor zero_area
Message-ID: <20081025202817.GA31625@kroah.com>
References: <20081024042023.054190751@mini.kroah.org> <20081024043423.GL30828@kroah.com> <20081024053639.GA17405@kroah.com> <Pine.LNX.4.64.0810242125001.5826@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0810242125001.5826@hs20-bc2-1.build.redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2008 at 09:40:04PM -0400, Mikulas Patocka wrote:
> 
> 
> On Thu, 23 Oct 2008, Greg KH wrote:
> 
> > On Thu, Oct 23, 2008 at 09:34:23PM -0700, Greg KH wrote:
> > > 2.6.27-stable review patch.  If anyone has any objections, please let us 
> > > know.
> > > 
> > > ------------------
> > > From: Alasdair G Kergon <agk@redhat.com>
> > > 
> > > commit 7c9e6c17325fab380fbe9c9787680ff7d4a51abd upstream
> > > 
> > > Use a separate buffer for writing zeroes to the on-disk snapshot
> > > exception store, make the updating of ps->current_area explicit and
> > > refactor the code in preparation for the fix in the next patch.
> > > 
> > > No functional change.
> > > 
> > > Signed-off-by: Alasdair G Kergon <agk@redhat.com>
> > > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > > 
> > > ---
> > >  drivers/md/dm-exception-store.c |  103 ++++++++++++++++++++++++++--------------
> > >  1 file changed, 69 insertions(+), 34 deletions(-)
> > 
> > Oops, this patch causes a build error:
> > 
> > drivers/md/dm-exception-store.c:235: error: implicit declaration of function 'area_location'
> > drivers/md/dm-exception-store.c:241: error: 'area' undeclared (first use in this function)
> > drivers/md/dm-exception-store.c:241: error: (Each undeclared identifier is reported only once
> > drivers/md/dm-exception-store.c:241: error: for each function it appears in.)
> > 
> > I'll drop this one, and the follow-on dm-exception-store.c patch as
> > well, as that was the only reason this patch was added.
> > 
> > If you want to redo these two patches, and get them into the
> > 2.6.27-stable tree, please do so and send them to stable@kernel.org.
> > 
> > thanks,
> > 
> > greg k-h
> 
> You should apply this one patch before:
> ftp://ftp.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-exception-store-introduce-area_location-function.patch

Hm, so we need 2 "cleanup" patches to get one tiny fix in a third patch?
Is it worth it?  If so, care to resend these three to stable@kernel.org
or possibly, just backport what you really need in the third one, with
the needed first 2 patches merged into it in one patch to get it all in
a simpler way?

thanks,

greg k-h
