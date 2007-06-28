Return-Path: <linux-kernel-owner+w=401wt.eu-S1757534AbXF1NrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534AbXF1NrU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 09:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753352AbXF1NrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 09:47:05 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:35211 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996AbXF1NrC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 09:47:02 -0400
Date: Thu, 28 Jun 2007 08:47:02 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Andrew Morgan <morgan@kernel.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Chris Wright <chrisw@sous-sol.org>,
       Andrew Morgan <agm@google.com>, casey@schaufler-ca.com,
       Andrew Morton <akpm@google.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       KaiGai Kohei <kaigai@kaigai.gr.jp>, James Morris <jmorris@namei.org>,
       linux-security-module@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] file capabilities: get_file_caps cleanups
Message-ID: <20070628134702.GB29641@sergelap.austin.ibm.com>
References: <20070628002041.GA10429@sergelap.austin.ibm.com> <468350D1.9010902@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <468350D1.9010902@kernel.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew Morgan (morgan@kernel.org):
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> This contains a typo:
> 
> Serge E. Hallyn wrote:
> >>From 588755d9498c87c4e963527ba0f49c11107de354 Mon Sep 17 00:00:00 2001
> > From: Serge E. Hallyn <serue@us.ibm.com>
> > Date: Wed, 27 Jun 2007 19:55:27 -0400
> > Subject: [PATCH 1/1] file capabilities: get_file_caps cleanups
> > 
> > Two cleanups relating to set_file caps.
> [...]
> > @@ -187,12 +186,21 @@ out:
> >  	dput(dentry);
> >  	if ((void *)dcaps != (void *)&v1caps)
> >  		kfree(dcaps);
> Move this two lines down (rc defaults to 0 in goto above):
> from here-->
> > +clear_caps:
> > +	if (rc) {
> to here-->

Hmm?  But if we succeeded we still want to free dcaps if we
kmalloc()'d it.

If we didn't kmalloc it, dcaps==v1caps and it won't be freed.

thanks,
-serge

> > +		cap_clear (bprm->cap_inheritable);
> > +		cap_clear (bprm->cap_permitted);
> > +		cap_clear (bprm->cap_effective);
> > +	}
> >  	return rc;
> 
> Cheers
> 
> Andrew
> 
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.2.6 (GNU/Linux)
> 
> iD8DBQFGg1DNQheEq9QabfIRApNqAJ99rNMF4VU/FPOolDLHlXbbQ2MRMwCeO3Fy
> 8ze7XhlBuBKdHElbZmWFJ5Y=
> =gAEK
> -----END PGP SIGNATURE-----
