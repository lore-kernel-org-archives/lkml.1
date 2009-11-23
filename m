Return-Path: <linux-kernel-owner+w=401wt.eu-S1757189AbZKWXNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189AbZKWXNz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 18:13:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756643AbZKWXNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 18:13:54 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:48393 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756413AbZKWXNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 18:13:53 -0500
Date: Mon, 23 Nov 2009 17:13:57 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
       "Andrew G. Morgan" <morgan@kernel.org>, Steve Grubb <sgrubb@redhat.com>,
       linux-security-module@vger.kernel.org,
       Kees Cook <kees.cook@canonical.com>,
       Andreas Gruenbacher <agruen@suse.de>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       George Wilson <gcwilson@us.ibm.com>, KaiGai Kohei <kaigai@kaigai.gr.jp>
Subject: Re: [PATCH] remove CONFIG_SECURITY_FILE_CAPABILITIES compile option
Message-ID: <20091123231357.GA11844@us.ibm.com>
References: <20091123222130.GA11325@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091123222130.GA11325@us.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Serge E. Hallyn (serue@us.ibm.com):
> As far as I know, all distros currently ship kernels with default
> CONFIG_SECURITY_FILE_CAPABILITIES=y.  Since having the option on
> leaves a 'no_file_caps' option to boot without file capabilities,
> the main reason to keep the option is that turning it off saves
> you (on my s390x partition) 5k.  In particular, vmlinux sizes
> came to:
> 
> without patch fscaps=n:		 	53598392
> without patch fscaps=y:		 	53603406
> with this patch applied:		53603342
> 
> with the security-next tree.
> 
> Against this we must weigh the fact that there is no simple way for
> userspace to figure out whether file capabilities are supported,
> while things like per-process securebits, capability bounding
> sets, and adding bits to pI if CAP_SETPCAP is in pE are not supported
> with SECURITY_FILE_CAPABILITIES=n, leaving a bit of a problem for
> applications wanting to know whether they can use them and/or why
> something failed.
> 
> It also adds another subtly different set of semantics which we must
> maintain at the risk of severe security regressions.
> 
> So this patch removes the SECURITY_FILE_CAPABILITIES compile
> option.  It drops the kernel size by about 50k over the stock

As Andrew points out, not 50k!  Try about 50 bytes :)  Sorry about that.

-serge
