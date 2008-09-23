Return-Path: <linux-kernel-owner+w=401wt.eu-S1753932AbYIWPwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbYIWPwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 11:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751766AbYIWPvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 11:51:51 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:60790 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751AbYIWPvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 11:51:50 -0400
Date: Tue, 23 Sep 2008 10:51:24 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org,
       James Morris <jmorris@redhat.com>, Andrew Morgan <morgan@kernel.org>,
       Andreas Gruenbacher <agruen@suse.de>, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 1/2] file capabilities: add no_file_caps switch (v2)
Message-ID: <20080923155124.GA2123@us.ibm.com>
References: <20080922184835.GA2826@us.ibm.com> <20080922225733.GB610@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080922225733.GB610@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Chris Wright (chrisw@sous-sol.org):
> * Serge E. Hallyn (serue@us.ibm.com) wrote:
> > --- a/kernel/capability.c
> > +++ b/kernel/capability.c
> > @@ -33,6 +33,19 @@ EXPORT_SYMBOL(__cap_empty_set);
> >  EXPORT_SYMBOL(__cap_full_set);
> >  EXPORT_SYMBOL(__cap_init_eff_set);
> >  
> > +#ifdef CONFIG_SECURITY_FILE_CAPABILITIES
> > +int file_caps_enabled = 1;
> > +
> > +static int __init file_caps_disable(char *str)
> > +{
> > +	file_caps_enabled = 0;
> > +	return 1;
> > +}
> > +__setup("no_file_caps", file_caps_disable);
> > +#else
> > +static const int file_caps_enabled = 0;
> > +#endif
> 
> > --- a/security/commoncap.c
> > +++ b/security/commoncap.c
> > @@ -27,6 +27,12 @@
> >  #include <linux/prctl.h>
> >  #include <linux/securebits.h>
> >  
> > +#ifdef CONFIG_SECURITY_FILE_CAPABILITIES
> > +extern int file_caps_enabled;
> > +#else
> > +static const int file_caps_enabled = 0;
> > +#endif
> > +
> 
> file_caps_enabled cut 'n paste mistake when !CONFIG_SECURITY_FILE_CAPABILITIES?

Oops, yup, thanks.

> Also, plan to update Documentation/kernel-parameters.txt?

Will do.

thanks,
-serge
