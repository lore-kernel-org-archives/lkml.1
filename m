Return-Path: <linux-kernel-owner+w=401wt.eu-S1754043AbXFXWJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbXFXWJp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 18:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751903AbXFXWJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 18:09:37 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:41843 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222AbXFXWJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 18:09:36 -0400
Date: Sun, 24 Jun 2007 15:09:03 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: James Morris <jmorris@namei.org>
Cc: linux-security-module@vger.kernel.org,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Chris Wright <chrisw@sous-sol.org>, Andrew Morgan <agm@google.com>,
       Andrew Morton <akpm@google.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       lkml <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
       Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH][RFC] security: Convert LSM into a static interface
Message-ID: <20070624220903.GB3723@sequoia.sous-sol.org>
References: <20070617135239.GA17689@sergelap> <4676007F.7060503@kernel.org> <20070618044017.GW3723@sequoia.sous-sol.org> <20070620171037.GA28670@sergelap.ibm.com> <20070620174613.GF3723@sequoia.sous-sol.org> <20070621160011.GB9913@sergelap.austin.ibm.com> <467CD63B.4000703@kernel.org> <20070624155100.GA5167@vino.hallyn.com> <Line.LNX.4.64.0706241158320.12660@localhost.localdomain> <Line.LNX.4.64.0706241653490.14183@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Line.LNX.4.64.0706241653490.14183@localhost.localdomain>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* James Morris (jmorris@namei.org) wrote:
> -module_param_named(disable, capability_disable, int, 0);
> -MODULE_PARM_DESC(disable, "To disable capabilities module set disable = 1");
> +
> +static int __init capability_disable_setup(char *str)
> +{
> +	capability_disable = simple_strtol(str, NULL, 0);
> +	return 1;
> +}
> +__setup("capability_disable=", capability_disable_setup);

This changes the command line argument.  Other than that and a some
sanity testing I'll take this.

thanks,
-chris
