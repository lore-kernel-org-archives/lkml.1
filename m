Return-Path: <linux-kernel-owner+w=401wt.eu-S1752082AbZBZRqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbZBZRqi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 12:46:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbZBZRq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 12:46:27 -0500
Received: from kroah.org ([198.145.64.141]:42874 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751900AbZBZRq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 12:46:26 -0500
Date: Thu, 26 Feb 2009 09:35:31 -0800
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "Sachin P. Sant" <sachinp@in.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, ashwin.ganti@gmail.com
Subject: Re: [Staging/p9auth] Feb 26 Next: build failure
Message-ID: <20090226173531.GB23465@kroah.com>
References: <20090226193022.adb78235.sfr@canb.auug.org.au> <49A67892.8060006@in.ibm.com> <20090226155355.GA22194@kroah.com> <49A6CA74.7000809@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49A6CA74.7000809@oracle.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 26, 2009 at 08:59:32AM -0800, Randy Dunlap wrote:
> Greg KH wrote:
> > On Thu, Feb 26, 2009 at 04:40:10PM +0530, Sachin P. Sant wrote:
> >> Feb 26 Next tree randconfig build fails with
> >>
> >> drivers/staging/p9auth/p9auth.c: In function cap_write:
> >> drivers/staging/p9auth/p9auth.c:249: error: implicit declaration of 
> >> function current_uid
> >> drivers/staging/p9auth/p9auth.c:261: error: implicit declaration of 
> >> function prepare_creds
> >> drivers/staging/p9auth/p9auth.c:261: warning: assignment makes pointer from 
> >> integer without a cast
> >> drivers/staging/p9auth/p9auth.c:266: error: dereferencing pointer to 
> >> incomplete type
> >> drivers/staging/p9auth/p9auth.c:267: error: dereferencing pointer to 
> >> incomplete type
> >> drivers/staging/p9auth/p9auth.c:268: error: implicit declaration of 
> >> function commit_creds
> >> make[3]: *** [drivers/staging/p9auth/p9auth.o] Error 1
> > 
> > Wierd, I thought cred.h would be pulled in with the current include
> > files.
> 
> Even if it were, that's not what we want.  We want explicit #includes
> for macros or structs etc. that are used in a source file.

I agree, sorry, I didn't mean to assume otherwise.

> > With this .config, if you add:
> > 	#include <linux/cred.h>
> > to drivers/staging/p9auth/p9auth.c does it solve the build error?
> > 
> > I'll go add it just to be safe :)
> 
> It needs both cred.h and sched.h in my testing.

Ok, I'll go add both.

thanks,

greg k-h
