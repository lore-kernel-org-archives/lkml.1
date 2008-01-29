Return-Path: <linux-kernel-owner+w=401wt.eu-S1761834AbYA2NJI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761834AbYA2NJI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 08:09:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762247AbYA2NIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 08:08:16 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:45367 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761292AbYA2NIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 08:08:13 -0500
Date: Tue, 29 Jan 2008 07:08:25 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: Matt LaPlante <kernel1@cyberdogtech.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: "Default Linux Capabilities" default in 2.6.24
Message-ID: <20080129130825.GD28931@sergelap.austin.ibm.com>
References: <20080124191201.324cf1a0.kernel1@cyberdogtech.com> <20080128201041.e0ac76d5.kernel1@cyberdogtech.com> <Xine.LNX.4.64.0801291347460.29383@us.intercode.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Xine.LNX.4.64.0801291347460.29383@us.intercode.com.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting James Morris (jmorris@namei.org):
> On Mon, 28 Jan 2008, Matt LaPlante wrote:
> 
> > On Thu, 24 Jan 2008 19:12:01 -0600
> > Matt LaPlante <kernel1@cyberdogtech.com> wrote:
> > 
> > > 
> > > I'm doing a make oldconfig with the new 2.6.24 kernel.  I came to the prompt for "Default Linux Capabilities" which defaults to No:
> > > 
> > > ---
> > >  Default Linux Capabilities (SECURITY_CAPABILITIES) [N/y/?] (NEW) ?
> > > ---
> > > 
> > > However the help text recommends saying Yes.
> > > 
> > > ---
> > >  This enables the "default" Linux capabilities functionality.
> > >  If you are unsure how to answer this question, answer Y.
> > > ---
> > > 
> > > Does this seem incongruous?  Also, what's the "question"? :)
> > > 
> > > Thanks, 
> > > Matt LaPlante
> > 
> > Anyone?
> 
> I think this should be default y.

True, it was made the default when CONFIG_SECURITY=n a few years ago,
and switching it off when toggling CONFIG_SECURITY is probably unsafe
for unsuspecting users/testers.

Thanks Matt.

-serge

>From 0528f582de5534b972abddbb3294a3fb11435a21 Mon Sep 17 00:00:00 2001
From: sergeh@us.ibm.com <hallyn@kernel.(none)>
Date: Tue, 29 Jan 2008 05:04:43 -0800
Subject: [PATCH 1/1] security: compile capabilities by default

Capabilities have long been the default when CONFIG_SECURITY=n,
and its help text suggests turning it on when CONFIG_SECURITY=y.
But it is set to default n.

Default it to y instead.

Signed-off-by: Serge Hallyn <serue@us.ibm.com>
---
 security/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/security/Kconfig b/security/Kconfig
index 8086e61..389e151 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -76,6 +76,7 @@ config SECURITY_NETWORK_XFRM
 config SECURITY_CAPABILITIES
 	bool "Default Linux Capabilities"
 	depends on SECURITY
+	default y
 	help
 	  This enables the "default" Linux capabilities functionality.
 	  If you are unsure how to answer this question, answer Y.
-- 
1.5.1

