Return-Path: <linux-kernel-owner+w=401wt.eu-S1755906AbZF3JEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906AbZF3JEn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 05:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753080AbZF3JEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 05:04:35 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:42604 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbZF3JEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 05:04:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SpPR7UKuBocCht95vbVGQM4lj71SoZ3hLRDTLpkD1/J2bN05ip13pJRQRHkLTgNe11
         eFZuMjz/34h67CmR9Znku+g5Y0ESL5d4f9Z4fWp6pTpKaLi9/Ku7+ACQMFkIAy8aXsgR
         9eDG/KZvFee1bfVCS8/un+YJ8Y5g/QSP/pUQU=
Date: Tue, 30 Jun 2009 17:06:39 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, sam@ravnborg.org
Subject: Re: [Patch] kbuild: finally remove the obsolete variable $TOPDIR
Message-ID: <20090630090639.GA5873@cr0.nay.redhat.com>
References: <20090619074241.6646.42298.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090619074241.6646.42298.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 19, 2009 at 03:40:26AM -0400, Amerigo Wang wrote:
>
>TOPDIR is obsolete, it can be finally removed now.
>
>Signed-off-by: WANG Cong <amwang@redhat.com>
>Cc: Sam <sam@ravnborg.org>

ping Sam...


>
>---
>diff --git a/Makefile b/Makefile
>index 46e1c9d..6e41628 100644
>--- a/Makefile
>+++ b/Makefile
>@@ -140,15 +140,13 @@ _all: modules
> endif
> 
> srctree		:= $(if $(KBUILD_SRC),$(KBUILD_SRC),$(CURDIR))
>-TOPDIR		:= $(srctree)
>-# FIXME - TOPDIR is obsolete, use srctree/objtree
> objtree		:= $(CURDIR)
> src		:= $(srctree)
> obj		:= $(objtree)
> 
> VPATH		:= $(srctree)$(if $(KBUILD_EXTMOD),:$(KBUILD_EXTMOD))
> 
>-export srctree objtree VPATH TOPDIR
>+export srctree objtree VPATH
> 
> 
> # SUBARCH tells the usermode build what the underlying arch is.  That is set
>diff --git a/drivers/scsi/cxgb3i/Kbuild b/drivers/scsi/cxgb3i/Kbuild
>index 25a2032..70d060b 100644
>--- a/drivers/scsi/cxgb3i/Kbuild
>+++ b/drivers/scsi/cxgb3i/Kbuild
>@@ -1,4 +1,4 @@
>-EXTRA_CFLAGS += -I$(TOPDIR)/drivers/net/cxgb3
>+EXTRA_CFLAGS += -I$(srctree)/drivers/net/cxgb3
> 
> cxgb3i-y := cxgb3i_init.o cxgb3i_iscsi.o cxgb3i_pdu.o cxgb3i_offload.o cxgb3i_ddp.o
> obj-$(CONFIG_SCSI_CXGB3_ISCSI) += cxgb3i.o
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
