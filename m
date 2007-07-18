Return-Path: <linux-kernel-owner+w=401wt.eu-S1762105AbXGRVIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762105AbXGRVIf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 17:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757728AbXGRVHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 17:07:22 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:48850 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755016AbXGRVHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 17:07:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=ApA975lW4OKuIxQSH9aU5J68nyP47zKehNJb37ab5SI1syU0Njhsr6uNmHX9f1m228uv8TbJZcAx1V0qpKd009+TLWcoQvbHeCFoea8ATcsVaX4GUyauow15gGe+uUjGdYWtMZz/fvPf2ikvuOUnlD8XDBvAoS3fLJG8yCSzi24=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: compile error if CONFIG_BLOCK not enabled related to linux/ide.h include
Date: Wed, 18 Jul 2007 22:44:40 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-ide@vger.kernel.org
References: <Pine.LNX.4.64.0707172353050.29097@blarg.am.freescale.net> <200707181247.26262.bzolnier@gmail.com> <162F0B67-44AB-4955-873A-150224C128CB@kernel.crashing.org>
In-Reply-To: <162F0B67-44AB-4955-873A-150224C128CB@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707182244.40282.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 July 2007, Kumar Gala wrote:
> 
> On Jul 18, 2007, at 5:47 AM, Bartlomiej Zolnierkiewicz wrote:
> 
> >
> > Hi,
> >
> > On Wednesday 18 July 2007, Kumar Gala wrote:
> >> M:      bzolnier@gmail.com
> >> L:      linux-ide@vger.kernel.org
> >>
> >> We get the following compile error if CONFIG_BLOCK isn't enabled:
> >>
> >>   CC      arch/powerpc/kernel/setup_32.o
> >> In file included from arch/powerpc/kernel/setup_32.c:14:
> >> include/linux/ide.h:558: error: expected specifier-qualifier-list  
> >> before 'request_queue_t'
> >> include/linux/ide.h:696: warning: 'struct request' declared inside  
> >> parameter list
> >> include/linux/ide.h:696: warning: its scope is only this  
> >> definition or declaration, which is probably not what you want
> >> include/linux/ide.h:820: warning: 'struct request' declared inside  
> >> parameter list
> >> include/linux/ide.h:853: error: field 'wrq' has incomplete type
> >> include/linux/ide.h:1205: error: expected ')' before '*' token
> >> make[1]: *** [arch/powerpc/kernel/setup_32.o] Error 1
> >> make: *** [arch/powerpc/kernel] Error 2
> >
> > include/linux/ide.h is exclusively for IDE subsystem
> >
> >> What I'm trying to figure out is if include/linux/ide.h should be  
> >> wrapped
> >> in a #if defined(CONFIG_IDE) || defined(CONFIG_IDE_MODULE) or if  
> >> there is
> >> some other desired way to handle this.
> >
> > Plese remove <linux/ide.h> include, there doesn't seem to be any  
> > piece of
> > code in arch/powerpc/kernel/setup_32.c which needs it anyway.
> 
> Its needed for:
> 
> struct ide_machdep_calls ppc_ide_md;
> 
> which gets defined in asm/ide.h which needs linux/ide.h for the defn  
> of ide_init_hwif.

Ah, this is a PPC special case.

In this case I think the best solution for now is to just add #ifdefs
(the proper/clean solution would be adding IDE host drivers for PPC
platforms needing special handling).

Thanks,
Bart
