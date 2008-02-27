Return-Path: <linux-kernel-owner+w=401wt.eu-S1756353AbYB0Qsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353AbYB0Qsl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 11:48:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754860AbYB0Qsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 11:48:30 -0500
Received: from hu-out-0506.google.com ([72.14.214.224]:12073 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327AbYB0Qs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 11:48:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=I/UBKj9kKK2IAuOncsZj8+LxRngLc1K6hFqMO+VESeXl+Ysygd0MG7MJc7MOjkdn+nWTZKIwGRZJF5HAk+uqRbTaBTN/pWV7yzCXRSJCq34gqHGRWwC/yZIFBkg7IbuZmtSUb7VSqFyGb+cvMZ0ZS0cAhG2FvTurWpSin/eAF3E=
Date: Wed, 27 Feb 2008 18:45:35 +0200
To: Paul Moore <paul.moore@hp.com>
Cc: Chris Wright <chrisw@sous-sol.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
       Casey Schaufler <casey@schaufler-ca.com>,
       David Woodhouse <dwmw2@infradead.org>,
       linux-security-module@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm 1/4] LSM: Introduce inode_getsecid and ipc_getsecid
	hooks
Message-ID: <20080227164535.GA27965@ubuntu>
References: <20080226232229.GA12059@ubuntu> <20080226232411.GB12059@ubuntu> <200802271104.57815.paul.moore@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802271104.57815.paul.moore@hp.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Wed, Feb 27, 2008 at 11:04:57AM -0500, Paul Moore wrote:
> On Tuesday 26 February 2008 6:24:11 pm Ahmed S. Darwish wrote:
> > Introduce inode_getsecid(inode, secid) and ipc_getsecid(ipcp, secid)
> > LSM hooks.
> >
> > This hooks will be used instead of similar exported SELinux
> > interfaces.
> >
> > Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> > Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
> > ---
> >
> >  include/linux/security.h |   18 ++++++++++++++++++
> >  security/dummy.c         |   12 ++++++++++++
> >  security/security.c      |   12 ++++++++++++
> >  3 files changed, 42 insertions(+)
> >
...
> ...
> 
> > +static inline void security_ipc_getsecid(struct kern_ipc_perm *ipcp,
> > u32 *secid)
> > +{ } 
> 
> Should these both do a  "*secid = 0;"?
> 

Yes, this will also lead to consistency in the interface espcially 
after changing task_getsecid to do the same (in patch #3).

> > diff --git a/security/dummy.c b/security/dummy.c
> > index 6a0056b..c2f4c52 100644
> > --- a/security/dummy.c
> > +++ b/security/dummy.c
> > @@ -422,6 +422,11 @@ static int dummy_inode_listsecurity(struct inode
> > *inode, char *buffer, size_t bu return 0;
> >  }
> >
> > +static void dummy_inode_getsecid(const struct inode *inode, u32
> > *secid)
> > +{ 
> > +	return;
> > +}
> 
> ...
> 
> > +static void dummy_ipc_getsecid(struct kern_ipc_perm *ipcp, u32
> > *secid)
> > +{ 
> > +	return;
> > +}
> 
> Same question.
> 

Both will be changed to *secid = 0 in the comming send. Thanks!

-- 

"Better to light a candle, than curse the darkness"

Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com

