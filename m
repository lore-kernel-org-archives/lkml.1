Return-Path: <linux-kernel-owner+w=401wt.eu-S1755779AbZGBWDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779AbZGBWDU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 18:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755032AbZGBWDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 18:03:13 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56835 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754423AbZGBWDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 18:03:12 -0400
Date: Fri, 3 Jul 2009 00:03:07 +0200
From: Pavel Machek <pavel@ucw.cz>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, tridge@samba.org,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, john.lanza@linux.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
Message-ID: <20090702220307.GG1485@ucw.cz>
References: <19013.8005.541836.436991@samba.org> <20090630063102.GB1351@ucw.cz> <19019.16217.291678.588673@samba.org> <4A4B4D1D.8070308@panasas.com> <1246463087.3894.51.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246463087.3894.51.camel@mulgrave.site>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-07-01 10:44:47, James Bottomley wrote:
> On Wed, 2009-07-01 at 14:48 +0300, Boaz Harrosh wrote:
> > On 07/01/2009 01:50 PM, tridge@samba.org wrote:
> > > Hi Pavel,
> > > 
> > > We did of course consider that, and the changes to the patch to
> > > implement collision avoidance are relatively simple. We didn't do it
> > > as it would weaken the legal basis behind the patch. I'll leave it to
> > > John Lanza (the LF patent attorney) to expand on that if you want more
> > > information.
> > > 
> > 
> > You completely lost me here. And I thought I did understand the patent
> > and the fix.
> > 
> > what is the difference between.
> > 
> > short_name = rand(sid);
> > and
> > short_name = sid++;
> > 
> > Now if you would do
> > short_name = MD5(long_name);
> > 
> > That I understand since short_name is some function of long_name
> > but if I'm just inventing the short_name out of my hat. In what legal
> > system does it matter what is my random function I use?
> 
> We're sort of arguing moot technicalities here.  If you look at the way
> the filename is constructed, given the constraints of a leading space
> and a NULL, the need for a NULL padded leading slash extension and the
> need to put control characters in the remaining bytes, we've only got 30
> bits to play with, we're never going to avoid collisions in a space of
> up to 31 bits.  Technically, a random function is at least as good at
> collision avoidance as any deterministic solution ... and it's a lot
> easier to code.

You could be deterministic and restrict maximum number of entries in
directory?

You could do random function but check if duplicate exists, and return
-EPERM if it does?

								Pavel 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
