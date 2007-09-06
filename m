Return-Path: <linux-kernel-owner+w=401wt.eu-S1754491AbXIFRID@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491AbXIFRID (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 13:08:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755963AbXIFRHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 13:07:44 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:11371 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755478AbXIFRHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 13:07:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=hOENJEQlRN1KKgZowCiKX9v+gBVK4tPhFP9AHd06hL2jX9mtoGIXiSRGLomWw3adv4WZsvC8dQRlD+PBsTQWYGX3Ti93Pi5GwF6VavaYsxNLMJAH8huXs1B19NEWYr6kH0tlSSSXy5vXaDdkLrH3/ajnSC3pmEBQrEKfF+SK/m8=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH 0/3] build system: section garbage collection for vmlinux
Date: Thu, 6 Sep 2007 18:07:33 +0100
User-Agent: KMail/1.9.1
Cc: sam@ravnborg.org, linux-kernel@vger.kernel.org
References: <200709051443.21522.vda.linux@googlemail.com> <200709061157.44080.vda.linux@googlemail.com> <1189091630.8490.1.camel@imap.mvista.com>
In-Reply-To: <1189091630.8490.1.camel@imap.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709061807.33740.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 September 2007 16:13, Daniel Walker wrote:
> On Thu, 2007-09-06 at 11:57 +0100, Denys Vlasenko wrote:
> > On Wednesday 05 September 2007 20:46, Daniel Walker wrote:
> > > On Wed, 2007-09-05 at 20:49 +0100, Denys Vlasenko wrote:
> > > 
> > > > What does "it" stand for in this sentence?
> > > 
> > > "it" is your patches, and I think we got to bottom of it .. "it" (i.e.
> > > your patches) don't actually work with modules, which is what you
> > > originally contended ..
> > 
> > Kernel builds, loads and runs with my patches, and modules load just fine.
> 
> Ok, so I guess we're not clear on this point .. In your last email you
> said that module exports might get removed? Is that what you intended to
> say or not?

I said this:

On Wednesday 05 September 2007 20:14, Denys Vlasenko wrote:
> On Wednesday 05 September 2007 19:38, Daniel Walker wrote:
> > > > You version doesn't work with CONFIG_MODULES right?
> > > 
> > > It works with CONFIG_MODULES.
> > 
> > Really? Take a look at this version,
> > 
> > http://lkml.org/lkml/2006/6/4/169
> > 
> > Marcello had to implement a two pass build to add back symbol used in
> > modules which got removed from the main kernel.. You don't appear to do
> > that. Marcelo also claims better size reduction than you.
> 
> This will discard EXPORT_SYMBOLs potentially used by
> out-of-tree modules.
> 
> I also saw ~10% size reductions, but then at run-time test modules
> failed to load, they didn't find needed symbols.

A bit extended version:

In the process in making it work I saw ~10% vmlinux size reductions
(which basically matches what Marcelo says) when I wasn't retaining
sections needed for EXPORT_SYMBOLs, but module loading didn't work.

Thus I fixed that by adding KEEP() directives so that EXPORT_SYMBOLs
are never discarded. This was just one of many fixes until kernel
started to actually boot and work.

I did that before I posted patches to lkml.
IOW: posted patches are not broken versus module loading.
--
vda
