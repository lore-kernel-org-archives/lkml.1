Return-Path: <linux-kernel-owner+w=401wt.eu-S1757989AbZAVSZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989AbZAVSZO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 13:25:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754244AbZAVSY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 13:24:59 -0500
Received: from ns.suse.de ([195.135.220.2]:35924 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753237AbZAVSY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 13:24:58 -0500
Date: Thu, 22 Jan 2009 10:22:14 -0800
From: Greg KH <gregkh@suse.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org, Inaky Perez-Gonzalez <inaky@linux.intel.com>,
       Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/5] debugfs: introduce stub for
	debugfs_create_size_t() when DEBUG_FS=n
Message-ID: <20090122182214.GA11328@suse.de>
References: <20090121051855.GA3665@kroah.com> <1232515197-3974-4-git-send-email-gregkh@suse.de> <20090122174152.de6cc08e.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090122174152.de6cc08e.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2009 at 05:41:52PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> On Tue, 20 Jan 2009 21:19:56 -0800 Greg Kroah-Hartman <gregkh@suse.de> wrote:
> >
> > From: Inaky Perez-Gonzalez <inaky@linux.intel.com>
> > 
> > Toralf Förster <toralf.foerster@gmx.de> reported a build failure in
> > the WiMAX stack when CONFIG_DEBUG_FS=n
> > 
> > http://linuxwimax.org/pipermail/wimax/2009-January/000449.html
> > 
> > This is due to debugfs_create_size_t() missing an stub that returns
> > -ENODEV when the DEBUGFS subsystem is not configured in (like the rest
> > of the debugfs API).
> > 
> > This patch adds said stub.
> > 
> > Reported-by: Toralf Förster <toralf.foerster@gmx.de>
> > Signed-off-by: Inaky Perez-Gonzalez <inaky@linux.intel.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > ---
> >  include/linux/debugfs.h |    7 +++++++
> >  1 files changed, 7 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/linux/debugfs.h b/include/linux/debugfs.h
> > index 23936b1..0f5c33b 100644
> > --- a/include/linux/debugfs.h
> > +++ b/include/linux/debugfs.h
> > @@ -162,6 +162,13 @@ static inline struct dentry *debugfs_create_x32(const char *name, mode_t mode,
> >  	return ERR_PTR(-ENODEV);
> >  }
> >  
> > +struct dentry *debugfs_create_size_t(const char *name, mode_t mode,
> 
> This needs to be "static inline".  See my other email about linux-next
> breakage due to this.

This is now resolved in my tree, sorry about this.

thanks,

greg k-h
