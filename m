Return-Path: <linux-kernel-owner+w=401wt.eu-S1757924AbYA2X47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924AbYA2X47 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 18:56:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753981AbYA2X4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 18:56:49 -0500
Received: from c60.cesmail.net ([216.154.195.49]:60857 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306AbYA2X4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 18:56:48 -0500
Subject: Re: ndiswrapper and GPL-only symbols redux
From: Pavel Roskin <proski@gnu.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Giridhar Pemmasani <pgiri@yahoo.com>
In-Reply-To: <20080129224529.4b8016c3@core>
References: <1201641765.18773.35.camel@dv>  <20080129224529.4b8016c3@core>
Content-Type: text/plain
Date: Tue, 29 Jan 2008 18:56:46 -0500
Message-Id: <1201651006.23553.8.camel@dv>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-29 at 22:45 +0000, Alan Cox wrote:
> > - it's a fair game to taint the kernel in some way if ndiswrapper has
> > been loaded at some point, since tainting per se is just an indicator
> > that the kernel has been used in an unsupportable way
> 
> That's all the patch appears to do. Se the taint flag.

There are two taint flags.  Let's see:

        if (strcmp(mod->name, "ndiswrapper") == 0)
-               add_taint(TAINT_PROPRIETARY_MODULE);
+               add_taint_module(mod, TAINT_PROPRIETARY_MODULE);

And that's add_taint_module():

static inline void add_taint_module(struct module *mod, unsigned flag)
{
        add_taint(flag);
        mod->taints |= flag;
}

The module taint is set before the symbols are resolved.  Therefore, the
GPL-only symbols won't be resolved.

> > - if this change stands, ndiswrapper will be renamed, which would only
> > create more confusion and would thus defeat the purpose of tainting
> 
> Not a productive approach. It will only harm support for everyone.

I know.  But ndiswrapper is a maintained program, which is regularly
updated to work with the latest kernels.  If the author fails to make
the necessary updates for the next kernel for whatever reason, somebody
will fork it and make such updates.

-- 
Regards,
Pavel Roskin
