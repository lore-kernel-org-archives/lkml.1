Return-Path: <linux-kernel-owner+w=401wt.eu-S1754854AbYIQKMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854AbYIQKMf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 06:12:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbYIQKMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 06:12:25 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:51141 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460AbYIQKMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 06:12:24 -0400
Date: Wed, 17 Sep 2008 13:12:02 +0300
From: Adrian Bunk <bunk@kernel.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       Davide Libenzi <davidel@xmailserver.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, klibc@zytor.com
Subject: Re: [PATCH] linux/inotify.h: do not include <linux/fcntl.h> in
	userspace
Message-ID: <20080917101202.GA5707@cs181140183.pp.htv.fi>
References: <1221567763-17060-1-git-send-email-kirill@shutemov.name> <20080916125802.GA15951@cs181140183.pp.htv.fi> <20080916130234.GA17082@localhost.localdomain> <48CFBE51.1060200@redhat.com> <20080916160902.GF1400@cs181140183.pp.htv.fi> <20080917093240.GB4984@localhost.localdomain> <20080917100422.GC4984@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080917100422.GC4984@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2008 at 01:04:23PM +0300, Kirill A. Shutemov wrote:
> On Wed, Sep 17, 2008 at 12:32:40PM +0300, Kirill A. Shutemov wrote:
> > On Tue, Sep 16, 2008 at 07:09:02PM +0300, Adrian Bunk wrote:
> > > On Tue, Sep 16, 2008 at 07:10:25AM -0700, Ulrich Drepper wrote:
> > > > Kirill A. Shutemov wrote:
> > > > >> What is the error message?
> > > > > 
> > > > > /usr/include/asm-generic/fcntl.h:117: error: redefinition of 'struct
> > > > > flock'
> > > > 
> > > > And?  None of these programs should use <linux/inotify.h>.  There has
> > > > for the longest time been a <sys/inotify.h> header which doesn't need
> > > > any kernel headers.  In fact, <linux/inotify.h> should not be exported.
> > > 
> > > Even if userspace applications shouldn't use it directly this doesn't 
> > > sound right:
> > > 
> > > We shouldn't force all libc implementations to copy the contents into a 
> > > private header.
> > 
> > glibc and dietlibc provide <sys/inotify.h>. newlib and uclibc don't. klibc
> > provides <sys/inotify.h> but it depends on <linux/inotify.h>
> 
> Oh.. Sorry. uclibc provides <sys/inotify.h>.
> 
> So unexporting <linux/inotify.h> breaks only klibc.

klibc is actually doing the right thing.

The userspace kernel headers situation used to be a complete mess, and 
it is therefore understandable that some libc implementations are 
currently not using <linux/inotify.h>, but ideally in the long term all 
libc implementations should use <linux/inotify.h>.

Whether, and if yes when, libc implementations starts using 
<linux/inotify.h> is not our business, but we have to ensure that it 
works for the libc implementations that do use it.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

