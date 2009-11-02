Return-Path: <linux-kernel-owner+w=401wt.eu-S1753383AbZKBA7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383AbZKBA7m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 19:59:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753064AbZKBA7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 19:59:42 -0500
Received: from mga11.intel.com ([192.55.52.93]:47331 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752992AbZKBA7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 19:59:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,662,1249282800"; 
   d="scan'208";a="742805650"
Subject: Re: [RFC 2/2] Use unified UUID/GUID definition in gfs2
From: Huang Ying <ying.huang@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, Steven Whitehouse <swhiteho@redhat.com>,
       Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20091101093545.a7a4693a.akpm@linux-foundation.org>
References: <1255501807.6047.1193.camel@yhuang-dev.sh.intel.com>
	 <20091101093545.a7a4693a.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 02 Nov 2009 08:59:43 +0800
Message-Id: <1257123583.30470.1161.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-02 at 01:35 +0800, Andrew Morton wrote: 
> On Wed, 14 Oct 2009 14:30:07 +0800 Huang Ying <ying.huang@intel.com> wrote:
> 
> > Replace u8[16] UUID definition in gfs2.
> > 
> > Signed-off-by: Huang Ying <ying.huang@intel.com>
> > ---
> >  fs/gfs2/incore.h            |    3 ++-
> >  fs/gfs2/ops_fstype.c        |    2 +-
> >  fs/gfs2/sys.c               |   14 ++++----------
> >  include/linux/gfs2_ondisk.h |    3 ++-
> >  4 files changed, 9 insertions(+), 13 deletions(-)
> > 
> > --- a/fs/gfs2/incore.h
> > +++ b/fs/gfs2/incore.h
> > @@ -15,6 +15,7 @@
> >  #include <linux/slow-work.h>
> >  #include <linux/dlm.h>
> >  #include <linux/buffer_head.h>
> > +#include <linux/uuid.h>
> >  
> >  #define DIO_WAIT	0x00000010
> >  #define DIO_METADATA	0x00000020
> > @@ -483,7 +484,7 @@ struct gfs2_sb_host {
> >  
> >  	char sb_lockproto[GFS2_LOCKNAME_LEN];
> >  	char sb_locktable[GFS2_LOCKNAME_LEN];
> > -	u8 sb_uuid[16];
> > +	uuid_be sb_uuid;
> >  };
> >  
> 
> Breaks `make headers_check':
> 
> include/linux/gfs2_ondisk.h:14: included file 'linux/uuid.h' is not exported
> 
> I don't think we want to export linux/uuid.h to userspace.  But
> fs/gfs2/incore.h _is_ shared with userspace, and needs linux/uuid.h.

When writing uuid.h, I think it should be exported to userspace. Why
should we not export it to user space?

Best Regards,
Huang Ying


