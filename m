Return-Path: <linux-kernel-owner+w=401wt.eu-S1755985AbXFYBir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985AbXFYBir (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 21:38:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752347AbXFYBij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 21:38:39 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:44431 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752303AbXFYBii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 21:38:38 -0400
Date: Sun, 24 Jun 2007 18:38:18 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: James Morris <jmorris@namei.org>
Cc: Chris Wright <chrisw@sous-sol.org>, linux-security-module@vger.kernel.org,
       "Serge E. Hallyn" <serue@us.ibm.com>, Andrew Morgan <agm@google.com>,
       Andrew Morton <akpm@google.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       lkml <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
       Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH][RFC] security: Convert LSM into a static interface
Message-ID: <20070625013818.GC3723@sequoia.sous-sol.org>
References: <20070618044017.GW3723@sequoia.sous-sol.org> <20070620171037.GA28670@sergelap.ibm.com> <20070620174613.GF3723@sequoia.sous-sol.org> <20070621160011.GB9913@sergelap.austin.ibm.com> <467CD63B.4000703@kernel.org> <20070624155100.GA5167@vino.hallyn.com> <Line.LNX.4.64.0706241158320.12660@localhost.localdomain> <Line.LNX.4.64.0706241653490.14183@localhost.localdomain> <20070624220903.GB3723@sequoia.sous-sol.org> <Line.LNX.4.64.0706241836270.14363@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Line.LNX.4.64.0706241836270.14363@localhost.localdomain>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* James Morris (jmorris@namei.org) wrote:
> On Sun, 24 Jun 2007, Chris Wright wrote:
> 
> > * James Morris (jmorris@namei.org) wrote:
> > > -module_param_named(disable, capability_disable, int, 0);
> > > -MODULE_PARM_DESC(disable, "To disable capabilities module set disable = 1");
> > > +
> > > +static int __init capability_disable_setup(char *str)
> > > +{
> > > +	capability_disable = simple_strtol(str, NULL, 0);
> > > +	return 1;
> > > +}
> > > +__setup("capability_disable=", capability_disable_setup);
> > 
> > This changes the command line argument.  Other than that and a some
> > sanity testing I'll take this.
> 
> Do you mean the name change, or the logic?
> 
> The name needs to change because kernel parameters are in a global 
> namespace.

Sorry, I mean it's currently capability.disable (and the only reason it
matters is that at one point I know there were users of it).

thanks,
-chris
