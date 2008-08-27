Return-Path: <linux-kernel-owner+w=401wt.eu-S1758057AbYH0P3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758057AbYH0P3g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 11:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755676AbYH0P3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 11:29:25 -0400
Received: from cantor.suse.de ([195.135.220.2]:43475 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755583AbYH0P3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 11:29:24 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs / Novell
To: "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [patch] file capabilities: Add no_file_caps switch
Date: Wed, 27 Aug 2008 17:29:18 +0200
User-Agent: KMail/1.9.9
Cc: "Andrew G. Morgan" <morgan@kernel.org>, linux-kernel@vger.kernel.org
References: <200808262057.51606.agruen@suse.de> <20080827135206.GA12919@us.ibm.com>
In-Reply-To: <20080827135206.GA12919@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808271729.18220.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 27 August 2008 15:52:06 Serge E. Hallyn wrote:
> Quoting Andreas Gruenbacher (agruen@suse.de):
> > Hello,
> >
> > here is a patch allowing to disable file capabilities via a kernel
> > command line option (once compiled in with
> > CONFIG_SECURITY_FILE_CAPABILITIES).
> >
> > We would like to ship our next round of products with file capabilities
> > compiled in, yet we feel that too many system utilities are still file
> > capabilitiy unaware, and so we would like to turn them off by default
> > initially. File capabilities can be used to grant privileges to binaries
> > which otherwise look "harmless", which is a security risk until utilities
> > like rpm have learned how to install and verify capabilities, etc.
> >
> > Any objections?
>
> Hi Andreas,
>
> No objections in general - if it makes you more comfortable shipping
> kernels with CONFIG_SECURITY_FILE_CAPABILITIES=y then it's worthwhile.
> However, can you elaborate on your concerns?

We don't have the time left for developing the few missing pieces and properly 
integrating file capabilities into our products (use in various packages, 
support in rpm, system management, manuals, release notes), and so I would 
like to have a way to turn them off by default for now.

> In particular, if as you say above the concern is really just that a
> file might have capabilities accidentally (or maliciously) enabled, then
> we should be able to just check for file_caps_enabled() at
> get_file_caps(), refusing to fill in the file capabilities.

My main concern is accidental granting of capabilities because of admin 
unawareness / lack of tool support. This could be taken care of by not 
loading the capabilities from disk.

> The other changes which you are canceling out confuscate the code but
> actually make no difference.

Well, the other difference is that with CONFIG_SECURITY_FILE_CAPABILITIES=y 
you currently lose the ability to pass on capabilities to other processes. Do 
you have good arguments why this feature is unnecessary? I don' think that 
having this feature was a good idea in the first place, but taking it away 
now after several years may break current users which may not have gotten 
converted, yet.

Thanks,
Andreas
