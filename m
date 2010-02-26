Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965671Ab0BZSTg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 13:19:36 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:36627 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965631Ab0BZSTe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 13:19:34 -0500
Date: Fri, 26 Feb 2010 12:19:30 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Greg KH <greg@kroah.com>
Cc: rsc@swtch.com, Ashwin Ganti <ashwin.ganti@gmail.com>, ericvh@gmail.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Ron Minnich <rminnich@gmail.com>, jt.beard@gmail.com
Subject: Re: [PATCH 1/8] p9auth: set fsuid
Message-ID: <20100226181930.GA17850@us.ibm.com>
References: <1266360301-30081-1-git-send-email-serue@us.ibm.com>
 <20100225232840.GB24155@kroah.com>
 <20100226040553.GA26170@us.ibm.com>
 <20100226050639.GA6115@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100226050639.GA6115@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Greg KH (greg@kroah.com):
> On Thu, Feb 25, 2010 at 10:05:53PM -0600, Serge E. Hallyn wrote:
> > Quoting Greg KH (greg@kroah.com):
> > > On Tue, Feb 16, 2010 at 04:44:54PM -0600, Serge Hallyn wrote:
> > > > From: Serge E. Hallyn <serue@us.ibm.com>
> > > > 
> > > > fsuid should always trail euid changes.  So p9auth should
> > > > set fsuid as well when it sets ruid and euid.  Whether the
> > > > suid should also be set is an open question - keeping the
> > > > old uid in suid may be useful, or may just serve to trick
> > > > lazy userspace.
> > > > 
> > > > Note that so long as we do not also set suid, the setuid_fixup()
> > > > code will not (when we later switch to setresuid()) fully
> > > > fill/clear capability sets.  So while I had previously thought
> > > > that keeping suid unchanged would be useful, I think it is
> > > > better to change all uids.
> > 
> > Hi Greg,
> > 
> > > What is your goal for the p9auth code?  Currently it is deleted in
> > > linux-next due to a lack of development.  I see you have some cleanup
> > > patches, but I can't apply them unless you get the non-staging patches
> > > accepted.
> > 
> > Sorry, what do you mean by 'the non-staging patches'?  Do you mean
> > the staging patches that were dropped, the cleanup patches (that
> > wouldn't make sense), or another set of patches?
> 
> I mean the ones that were not for the drivers/staging/p9auth/ directory.
> I can't apply patches to the staging git tree for stuff outside of
> drivers/staging/

Ah, ok, I see - I didn't realize you restricted patches to under
staging.  Makes sense obviously.

> > > If I bring the driver back from deletion, will you work to fix it up and
> > > get it merged into mainline?
> > 
> > Yes.
> 
> Great.
> 
> > > What's the word on the non-staging patches in this series being
> > > accepted?
> > 
> > Again, I'm not quite sure which you mean by the non-staging patches,
> > or what you mean by accepted - do you mean general community acceptance
> > of the base p9auth patches, or acceptance of my p9uath patches by
> > Ashwin etc?
> 
> Well. I was referring to the patches outside of the drivers/staging/
> directory, but also, it would be good to see if Ashwin has any
> objections to them.
> 
> Once you two work it out, care to resend them?

Ok, and I'll add some more cc:s to get more feedback on the
external patches.

Ashwin, Ron, Eric, (whoever else cares to take a look) I will put
up a git tree hopefully this weekend or monday... hmm, hang on, already
exists - you can take a look at
http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/sergeh/linux-cr.git;a=shortlog;h=refs/heads/p9auth.feb16.3

Please let me know if you have any comments.  I'm going to add user
namespace tags and then take another step back and do general
cleanups, but the API wouldn't change any more.

thanks,
-serge
