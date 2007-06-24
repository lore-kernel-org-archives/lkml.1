Return-Path: <linux-kernel-owner+w=401wt.eu-S1753248AbXFXWhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbXFXWhz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 18:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751409AbXFXWhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 18:37:48 -0400
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:44797 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbXFXWhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 18:37:47 -0400
Date: Sun, 24 Jun 2007 18:37:44 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@localhost.localdomain
To: Chris Wright <chrisw@sous-sol.org>
cc: linux-security-module@vger.kernel.org,
       "Serge E. Hallyn" <serue@us.ibm.com>, Andrew Morgan <agm@google.com>,
       Andrew Morton <akpm@google.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       lkml <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
       Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH][RFC] security: Convert LSM into a static interface
In-Reply-To: <20070624220903.GB3723@sequoia.sous-sol.org>
Message-ID: <Line.LNX.4.64.0706241836270.14363@localhost.localdomain>
References: <20070617135239.GA17689@sergelap> <4676007F.7060503@kernel.org>
 <20070618044017.GW3723@sequoia.sous-sol.org> <20070620171037.GA28670@sergelap.ibm.com>
 <20070620174613.GF3723@sequoia.sous-sol.org> <20070621160011.GB9913@sergelap.austin.ibm.com>
 <467CD63B.4000703@kernel.org> <20070624155100.GA5167@vino.hallyn.com>
 <Line.LNX.4.64.0706241158320.12660@localhost.localdomain>
 <Line.LNX.4.64.0706241653490.14183@localhost.localdomain>
 <20070624220903.GB3723@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Jun 2007, Chris Wright wrote:

> * James Morris (jmorris@namei.org) wrote:
> > -module_param_named(disable, capability_disable, int, 0);
> > -MODULE_PARM_DESC(disable, "To disable capabilities module set disable = 1");
> > +
> > +static int __init capability_disable_setup(char *str)
> > +{
> > +	capability_disable = simple_strtol(str, NULL, 0);
> > +	return 1;
> > +}
> > +__setup("capability_disable=", capability_disable_setup);
> 
> This changes the command line argument.  Other than that and a some
> sanity testing I'll take this.

Do you mean the name change, or the logic?

The name needs to change because kernel parameters are in a global 
namespace.

If the logic has changed, I'm missing something :-)


-- 
James Morris
<jmorris@namei.org>
