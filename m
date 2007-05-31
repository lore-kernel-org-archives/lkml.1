Return-Path: <linux-kernel-owner+w=401wt.eu-S1761516AbXEaT4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761516AbXEaT4o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 15:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758794AbXEaT4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 15:56:34 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:49946 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758886AbXEaT4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 15:56:33 -0400
Date: Thu, 31 May 2007 14:56:31 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: menage@google.com, dev@sw.ru, xemul@sw.ru, serue@us.ibm.com,
       vatsa@in.ibm.com, ebiederm@xmission.com, haveblue@us.ibm.com,
       svaidy@linux.vnet.ibm.com, balbir@in.ibm.com, pj@sgi.com, cpw@sgi.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, mbligh@google.com, rohitseth@google.com,
       devel@openvz.org
Subject: Re: [PATCH 05/10] Containers(V10): Add container_clone() interface
Message-ID: <20070531195631.GA16220@sergelap.austin.ibm.com>
References: <20070529130104.461765000@menage.corp.google.com> <20070529132142.795847000@menage.corp.google.com> <20070530001610.e2984b1d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070530001610.e2984b1d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew Morton (akpm@linux-foundation.org):
> On Tue, 29 May 2007 06:01:09 -0700 menage@google.com wrote:
> 
> > This patch adds support for container_clone(), a speculative interface
> > to creating new containers intended to be used for systems such as
> > namespace unsharing.
> > 
> > ...
> >
> > +
> > +static atomic_t namecnt;
> > +static void get_unused_name(char *buf)
> > +{
> > +	sprintf(buf, "node%d", atomic_inc_return(&namecnt));
> > +}
> 
> A stupid thing, but a sufficiently determined attacker could cause this to
> wrap.

Yeah, this was very consciously done as a "just make it work for now"
naming system.  If we want to stick with this naming, then I suppose we
could do a global bitmap.

But imo this naming is not very convenient - it would be nicer if we

	a) allowed users to specify a name (not sure how that would work
		logistically)
	b) made the namecnt variable for automatically named containers
		be per-directory.  I'd much rather see

		/containers/node1/node1
		/containers/node2
	than
		/containers/node1/node3
		/containers/node2

	(assuming /node2 was created between /node1 and /node1/node1 or
	/node1/node3)

thanks,
-serge
