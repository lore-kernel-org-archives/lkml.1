Return-Path: <linux-kernel-owner+w=401wt.eu-S1760135AbYFTP2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760135AbYFTP2f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 11:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758654AbYFTP2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 11:28:16 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:42295 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758545AbYFTP2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 11:28:15 -0400
Subject: Re: "r/o bind mounts" patch in 2.6.26-rc6 changes (breaks?) error
	behaviour
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1213971466.7512.17.camel@nimitz>
References: <485B8361.6010708@LiPPERTEmbedded.de>
	 <1213971466.7512.17.camel@nimitz>
Content-Type: text/plain
Date: Fri, 20 Jun 2008 08:28:09 -0700
Message-Id: <1213975689.7512.36.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-06-20 at 07:17 -0700, Dave Hansen wrote:
> On Fri, 2008-06-20 at 12:16 +0200, Jens Rottmann wrote:
> > 
> > I noticed the following change in the error behaviour when attempting
> > to delete nonexisting files/dirs from R/O-mounted directories:
> > 
> > Linux 2.6.25.7:
> > rm /RO_mounted_path/nonexisting_file
> > ==> "No such file or directory"
> > 
> > Linux 2.6.26-rc6-git6:
> > rm /RO_mounted_path/nonexisting_file
> > ==> "Read-only file system"
> 
> We looked at this way back in the beginning when I started to work on
> the patches.  It was decided that the error codes weren't horribly
> important.  We did have a case a bit ago where it really mattered, and
> Al fixed that up.
> 
> I know this changed behavior a bit, but userspace can surely work around
> it with read-only operations (stat) when it is really important to get
> the error to the user just right.

Also, there are some nice benefits to the new way of doing it.  To
figure out if there is a file in that location also requires a path
walk.  Now, that isn't the most expensive thing in the world, but it is
a heck of a lot more expensive than just doing a read-only look at a
variable in the mount (in mnt_want_write()).

Don't you *want* warnings when an 'rm -f' runs into a r/o filesystem? ;)

-- Dave

