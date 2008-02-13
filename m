Return-Path: <linux-kernel-owner+w=401wt.eu-S1765049AbYBMOQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765049AbYBMOQp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 09:16:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762590AbYBMOQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 09:16:07 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:41040 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764146AbYBMOQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 09:16:05 -0500
Date: Wed, 13 Feb 2008 16:15:59 +0200 (EET)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@kivilampi-30.cs.helsinki.fi
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
cc: jaharkes@cs.cmu.edu, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs/coda: remove static inline forward declarations
In-Reply-To: <Pine.LNX.4.61.0802130838100.4463@chaos.analogic.com>
Message-ID: <Pine.LNX.4.64.0802131554180.31652@kivilampi-30.cs.helsinki.fi>
References: <Pine.LNX.4.64.0802131417460.31652@kivilampi-30.cs.helsinki.fi>
 <Pine.LNX.4.61.0802130838100.4463@chaos.analogic.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; boundary="-696243703-2013330679-1202911883=:31652"
Content-ID: <Pine.LNX.4.64.0802131611280.31652@kivilampi-30.cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---696243703-2013330679-1202911883=:31652
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-ID: <Pine.LNX.4.64.0802131611281.31652@kivilampi-30.cs.helsinki.fi>

On Wed, 13 Feb 2008, linux-os (Dick Johnson) wrote:
> 
> On Wed, 13 Feb 2008, [iso-8859-1] Ilpo Järvinen wrote:
> 
> > They're defined later on in the same file with bodies and
> > nothingin between needs them.
> >
> > Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
> > ---
> > include/linux/coda_linux.h |    3 ---
> > 1 files changed, 0 insertions(+), 3 deletions(-)
> >
> > diff --git a/include/linux/coda_linux.h b/include/linux/coda_linux.h
> > index 1c47a34..31b7531 100644
> > --- a/include/linux/coda_linux.h
> > +++ b/include/linux/coda_linux.h
> > @@ -43,9 +43,6 @@ int coda_getattr(struct vfsmount *, struct dentry *, struct kstat *);
> > int coda_setattr(struct dentry *, struct iattr *);
> >
> > /* this file:  heloers */
> > -static __inline__ struct CodaFid *coda_i2f(struct inode *);
> > -static __inline__ char *coda_i2s(struct inode *);
> > -static __inline__ void coda_flag_inode(struct inode *, int flag);
> > char *coda_f2s(struct CodaFid *f);
> > int coda_isroot(struct inode *i);
> > int coda_iscontrol(const char *name, size_t length);
> > -- 
> > 1.5.2.2
> >
> 
> I was taught formally that all procedures must be declared
> before they are encountered in a file. This constitutes what
> is generally known as "good standards of engineering practice."
> It also guarantees a compiler diagnostic if the declaration and
> the function doesn't match.

They still are declared before they are used (the other two functions are 
similar to this randomly picked example):

$ grep "coda_i2f" include/linux/coda_linux.h 
static __inline__ struct CodaFid *coda_i2f(struct inode *);
static __inline__ struct CodaFid *coda_i2f(struct inode *inode)

I removed the first one of these. The latter is followed by the body of 
the function.

By using some fuzzy word like "encountered" you just make your point 
obscure enough so that I cannot follow what you're trying to say. If you 
refer to use of the function by "encountering", then that property is 
still maintained and we still get all the type-checking and so on (even 
after this removal). 

> You should not remove things just because you don't think they
> are necessary. They do no harm and removing them can cause
> code checking tools to issue diagnostic messages.

Do you really think so? I mean in this specific case, did you even 
bothered to check the file before hitting the send button? ...I just fail 
to see what is your point in keeping these three because they're declared
later on in the same file, though with the body at that time. Do you also 
claim that all the other ~5000+ static inlines with body in kernel headers 
(but not forward declared) are not following those "good standards" you're 
asking for (they certainly won't issue extra diagnostic messages)?


-- 
 i.
---696243703-2013330679-1202911883=:31652--
