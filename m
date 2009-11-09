Return-Path: <linux-kernel-owner+w=401wt.eu-S1753493AbZKIDFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbZKIDFr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 22:05:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753303AbZKIDFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 22:05:47 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:46578 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715AbZKIDFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 22:05:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JrQKJMXj0bJp4G8TMnfxRnjrXjvI+1FoqpoD5z61+TmzfdTMjaMEqhXdWfEtIJGxTz
         3xrsQdz8po9x924XF631Xf7n0hNnTZqiADkbz/4fkN9k9AEvzh+ezRS3k9WcgpdHRtxT
         7lsFBGun4jZR1DFQCAMwiziiawq/YFXslq9ao=
Date: Mon, 9 Nov 2009 11:06:22 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Carmelo Amoroso <carmelo73@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Carmelo AMOROSO <carmelo.amoroso@st.com>
Subject: Re: [PATCH] modules: Allow to use depmod from a non default install
Message-ID: <20091109030622.GB2399@hack>
References: <4AF73BA4.3000501@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF73BA4.3000501@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 08, 2009 at 10:44:04PM +0100, Carmelo Amoroso wrote:
>This patch allow to specify the directory where to find the
>depmod tool other than being forced to use the module-init-tools
>installed on the host. The reason for this is explained below.
>When doing cross-compilation, it not guaranteed that the
>module-init-tools installed on the host (and used during kernel build)
>are exactly the same and compatible with those used on the target at runtime.
>For example, recent changes in how depmod writes modules.dep using
>root-less path, make older modprobe unusable on the target.
>User in ths case could install in a different path the module-init-tools
>compatible with the version used on the target and specify the path on the
>command line.
>
>Signed-off-by: Carmelo Amoroso <carmelo.amoroso@st.com>

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>


>---
> Makefile |    3 ++-
> 1 files changed, 2 insertions(+), 1 deletions(-)
>
>diff --git a/Makefile b/Makefile
>index b4c04f7..f5286c4 100644
>--- a/Makefile
>+++ b/Makefile
>@@ -316,7 +316,8 @@ OBJDUMP             = $(CROSS_COMPILE)objdump
> AWK            = awk
> GENKSYMS       = scripts/genksyms/genksyms
> INSTALLKERNEL  := installkernel
>-DEPMOD         = /sbin/depmod
>+DEPMOD_PATH    ?= /sbin
>+DEPMOD         = $(DEPMOD_PATH)/depmod
> KALLSYMS       = scripts/kallsyms
> PERL           = perl
> CHECK          = sparse
>-- 1.6.3.3
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/

-- 
Live like a child, think like the god.
 
