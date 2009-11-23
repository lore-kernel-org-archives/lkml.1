Return-Path: <linux-kernel-owner+w=401wt.eu-S1756058AbZKWWfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058AbZKWWfT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 17:35:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755883AbZKWWfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 17:35:19 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:52322 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755655AbZKWWfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 17:35:17 -0500
Message-ID: <4B0B0DDB.4070504@oracle.com>
Date: Mon, 23 Nov 2009 14:34:03 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: James Morris <jmorris@namei.org>, lkml <linux-kernel@vger.kernel.org>,
       "Andrew G. Morgan" <morgan@kernel.org>, Steve Grubb <sgrubb@redhat.com>,
       linux-security-module@vger.kernel.org,
       Kees Cook <kees.cook@canonical.com>,
       Andreas Gruenbacher <agruen@suse.de>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       George Wilson <gcwilson@us.ibm.com>, KaiGai Kohei <kaigai@kaigai.gr.jp>
Subject: Re: [PATCH] remove CONFIG_SECURITY_FILE_CAPABILITIES compile option
References: <20091123222130.GA11325@us.ibm.com>
In-Reply-To: <20091123222130.GA11325@us.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4B0B0DE0.0102:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn wrote:
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

Hi,

This is or is not the same security option that is referred to in
(new:) http://bugzilla.kernel.org/show_bug.cgi?id=14675 ?


> So this patch removes the SECURITY_FILE_CAPABILITIES compile
> option.  It drops the kernel size by about 50k over the stock
> SECURITY_FILE_CAPABILITIES=y kernel, by removing the
> cap_limit_ptraced_target() function.
> 
> Changelog:
> 	Nov 20: remove cap_limit_ptraced_target() as it's logic
> 		was ifndef'ed.
> 
> Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
> Acked-by: Andrew G. Morgan" <morgan@kernel.org>
> ---
>  include/linux/capability.h |    2 -
>  include/linux/init_task.h  |    4 --
>  kernel/capability.c        |    2 -
>  security/Kconfig           |    9 -----
>  security/commoncap.c       |   72 +------------------------------------------
>  5 files changed, 2 insertions(+), 87 deletions(-)



-- 
~Randy
