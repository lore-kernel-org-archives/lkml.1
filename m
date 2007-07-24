Return-Path: <linux-kernel-owner+w=401wt.eu-S1762390AbXGXUCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762390AbXGXUCw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 16:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756986AbXGXUCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 16:02:44 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44825 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757070AbXGXUCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 16:02:43 -0400
Date: Tue, 24 Jul 2007 11:25:45 -0700
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Morris <jmorris@namei.org>, Chris Wright <chrisw@sous-sol.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Stephen Smalley <sds@tycho.nsa.gov>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH try #3] security: Convert LSM into a static interface
Message-ID: <20070724182545.GB24070@kroah.com>
References: <Line.LNX.4.64.0707141233490.26711@d.namei> <20070724010224.bbfb82bc.akpm@linux-foundation.org> <20070724085358.GA13845@kroah.com> <20070724015846.b30d723c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070724015846.b30d723c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2007 at 01:58:46AM -0700, Andrew Morton wrote:
> On Tue, 24 Jul 2007 01:53:58 -0700 Greg KH <greg@kroah.com> wrote:
> 
> > On Tue, Jul 24, 2007 at 01:02:24AM -0700, Andrew Morton wrote:
> > > On Sat, 14 Jul 2007 12:37:01 -0400 (EDT) James Morris <jmorris@namei.org> wrote:
> > > 
> > > > Convert LSM into a static interface
> > > 
> > > allmodconfig broke
> > > 
> > > security/built-in.o: In function `rootplug_bprm_check_security':
> > > security/root_plug.c:64: undefined reference to `usb_find_device'
> > > security/root_plug.c:70: undefined reference to `usb_put_dev'
> > 
> > That's wierd, who would have disabled the exports of those functions or
> > removed the "#include <linux/usb.h>" from this file?
> > 
> 
> root_plug is linked into vmlinux and usb is modular.  I did this:
> 
> --- a/security/Kconfig~security-convert-lsm-into-a-static-interface-fix-2
> +++ a/security/Kconfig
> @@ -82,7 +82,7 @@ config SECURITY_CAPABILITIES
>  
>  config SECURITY_ROOTPLUG
>  	bool "Root Plug Support"
> -	depends on USB && SECURITY
> +	depends on USB=y && SECURITY
>  	help
>  	  This is a sample LSM module that should only be used as such.
>  	  It prevents any programs running with egid == 0 if a specific

That looks correct to me.

thanks,

greg k-h
