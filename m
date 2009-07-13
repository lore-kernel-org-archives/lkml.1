Return-Path: <linux-kernel-owner+w=401wt.eu-S1756146AbZGMPRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146AbZGMPRz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 11:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756093AbZGMPRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 11:17:54 -0400
Received: from msux-gh1-uea02.nsa.gov ([63.239.67.2]:61255 "EHLO
	msux-gh1-uea02.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755973AbZGMPRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 11:17:53 -0400
Subject: Re: [PATCH] Security/sysfs: Enable security xattrs to be set on
 sysfs files, directories, and symlinks.
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Greg KH <gregkh@suse.de>, jmorris@namei.org, sds@tycho.nsa.gov,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
In-Reply-To: <4A56B4B3.2030400@schaufler-ca.com>
References: <1247074106-23405-1-git-send-email-dpquigl@tycho.nsa.gov>
	 <4A554B95.6070709@schaufler-ca.com> <1247160404.4398.218.camel@localhost>
	 <20090709175049.GA26378@suse.de> <1247167976.4398.231.camel@localhost>
	 <4A56B4B3.2030400@schaufler-ca.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Mon, 13 Jul 2009 11:07:35 -0400
Message-Id: <1247497655.4398.248.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-09 at 20:25 -0700, Casey Schaufler wrote:
> David P. Quigley wrote:
> > On Thu, 2009-07-09 at 10:50 -0700, Greg KH wrote:
> >   
> >> On Thu, Jul 09, 2009 at 01:26:44PM -0400, David P. Quigley wrote:
> >>     
> >>> I just read over Casey's comments again and I'm pretty sure we have a
> >>> big misunderstanding here. From his initial response it seems that he
> >>> thinks that I am exposing the secids to userspace as the way for setting
> >>> the labels on files. That isn't true. We are still using the full string
> >>> based labels for the userspace interface what the secid is used for is
> >>> to allow the kernel to keep track of changes until the sysfs_dirent is
> >>> destroyed. 
> >>>       
> >> Ok, if Casey and others agree that this is the best solution, I'll take
> >> it.
> >>
> >> thanks,
> >>
> >> greg k-h
> >>     
> >
> >
> > I haven't heard from Casey since his last email so I'd hold off on
> > taking this until we come to an agreement.
> 
> Yeah. Pardon the day job.
> 
> >  It seems though from your
> > comments in another mail that putting the persistent data into the
> > sysfs_dirent is the proper approach and we just need to figure out what
> > to put there.
> >   
> 
> Now that I've really had a chance to review the patches carefully
> my worst fears have been put to rest. I don't doubt that what you've
> got will work any longer. I do object to using a secid, but I've had
> to give in on that before.
> 
> If your secid is valid at any given time you have a context (which
> is a text string) available at the same time that you can point to.
> If this were not true a call to security_xattr_to_secid() could
> not be counted on to succeed. You could define
> security_xattr_to_secctx() and have it return the Smack value for
> Smack and the context for SELinux instead of security_xattr_to_secid().
> Sure, you've got a string to maintain, but it had better not be going
> away in SELinux, because if it does the secid is going with it. Unless
> I recall incorrectly (always a possibility) it has been some time
> since the avc could really be considered a cache. I am willing to
> bet beers that you could safely point to a mapping somewhere and
> not worry much about it.
> 
> If not, you've got other performance issues in SELinux.

Sorry for the late reply but I was out of work on Friday. I'm not really
sure that I see the point of the xattr_to_secctx considering in theory
they should be the same exact thing. The patch was originally Steve's so
I don't know the full history of why it was done this way and
unfortunately he isn't around at the moment to comment on it. With your
hook what would you be storing in the sysfs_dirent? Are we back to
storing a string there?

Dave

