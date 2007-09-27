Return-Path: <linux-kernel-owner+w=401wt.eu-S1755016AbXI0IZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016AbXI0IZv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 04:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752980AbXI0IZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 04:25:44 -0400
Received: from sacred.ru ([62.205.161.221]:42316 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752956AbXI0IZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 04:25:42 -0400
Message-ID: <46FB682B.2000100@openvz.org>
Date: Thu, 27 Sep 2007 12:22:03 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: sukadev@us.ibm.com
CC: "Serge E. Hallyn" <serue@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH 1/5] The config option itself
References: <46FA7D4D.8040808@openvz.org> <46FA7E20.80207@openvz.org> <20070926163432.GA23435@sergelap.austin.ibm.com> <20070926170621.GB23435@sergelap.austin.ibm.com> <20070927023024.GA24004@us.ibm.com>
In-Reply-To: <20070927023024.GA24004@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Thu, 27 Sep 2007 12:24:27 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

sukadev@us.ibm.com wrote:
> Serge E. Hallyn [serue@us.ibm.com] wrote:
> | Quoting Serge E. Hallyn (serue@us.ibm.com):
> | > Quoting Pavel Emelyanov (xemul@openvz.org):
> | > > The option is called NAMESPACES. It can be selectable only
> | > > if EMBEDDED is chosen (this was Eric's requisition). When
> | > > the EMBEDDED is off namespaces will be on automatically.
> | > > 
> | > > One more option (NAMESPACES_EXPERIMENTAL) was added by 
> | > > Serge's request to move there all the namespaces that are 
> | > > not finished yet. Currently only the user and the network
> | > > namespaces are such.
> | > > 
> | > > Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
> | > > 
> | > > ---
> | > > 
> | > > diff --git a/init/Kconfig b/init/Kconfig
> | > > index 684ccfb..05a71d7 100644
> | > > --- a/init/Kconfig
> | > > +++ b/init/Kconfig
> | > > @@ -369,6 +360,23 @@ config RELAY
> | > > 
> | > >  	  If unsure, say N.
> | > > 
> | > > +config NAMESPACES
> | > > +	bool "The namespaces support" if EMBEDDED
> | > > +	default !EMBEDDED
> | > > +	help
> | > > +	  Provides the way to make tasks work with different objects using
> | > > +	  the same id. For example same IPC id may refer to different objects
> | > > +	  or same user id or pid may refer to different tasks when used in
> | > > +	  different namespaces.
> | > > +
> | > > +config NAMESPACES_EXPERIMENTAL
> | > > +	bool "Add the experimantal namespaces support" if EMBEDDED
> | > 
> | > Hi Pavel,
> | > 
> | > Overall this patchset looks good.
> | > 
> | > However the NAMESPACES_EXPERIMENTAL option should not have the
> | > 'if EMBEDDED', right?  This is about EXPERIMENTAL, not about
> | > EMBEDDED, unlike the plain NAMESPACES option.
> | > 
> | > -serge
> | 
> | Actually that doesn't seem to work either.  Even though
> | SECURITY_NAMESPACES=y, the config system seems to infer that
> | since NAMESPACES is not user-selectable, NAMESPACES_EXPERIMENTAL
> | shouldn't be either.  So we end up with NAMESPACES_EXPERIMENTAL
> | being on and not un-selectable if !EMBEDDED.
> 
> Yes. Given that NAMESPACES depends on EMBEDDED, NAMESPACES_EXPERIMENTAL
> can simply depend on NAMESPACES and EXPERIMENTAL with a default of N.

Nope. The intention is that the NAMESPACES and NAMESPACES_EXPERIMENTAL
must not be selectable if EMBEDDED=n, but if we make NS_EXPERIMENTAL
depend on NAMESPACES only we'll have to make a choice in !EMBEDDED.

> BTW, does the position of 'config NAMESPACES' in init/Kconfig file
> matter ?  If it is dependent on EMBEDDED, should it not come later
> in the file, after 'config EMBEDDED' ?
> 
> | 
> | > > +	depends on NAMESPACES && EXPERIMENTAL
> | > > +	default !EMBEDDED
> | > > +	help
> | > > +	  Also include the support for the namespaces that are not fnished
> | > > +	  or well developed yet
> | > > +
> | > >  config BLK_DEV_INITRD
> | > >  	bool "Initial RAM filesystem and RAM disk (initramfs/initrd) support"
> | > >  	depends on BROKEN || !FRV
> | _______________________________________________
> | Containers mailing list
> | Containers@lists.linux-foundation.org
> | https://lists.linux-foundation.org/mailman/listinfo/containers
> 

