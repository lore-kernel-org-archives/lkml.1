Return-Path: <linux-kernel-owner+w=401wt.eu-S1756836AbYAET0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836AbYAET0S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 14:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756331AbYAET0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 14:26:05 -0500
Received: from mu-out-0910.google.com ([209.85.134.186]:2093 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756254AbYAET0C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 14:26:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=IxyokiSoHx+WuAmmMz/wgjVh492EoxM4AzPgmRvSoxC9Ui0NMatwONraXw7JiMR8mejyYvXHsOVeb/MxAKZBWOI6TVYbejaCAa/2czNqpeqYgXeIOSnN/epWyZy9Sn+iYQu4jPmtKI/lRF6FZs7Q4gSVEhBntS14E4LM3Q1128M=
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86: little fix in 'include/asm-x86/topology.h'
Date: Sat, 5 Jan 2008 21:25:59 +0100
User-Agent: KMail/1.9.7
Cc: Miguel =?iso-8859-1?q?Bot=F3n?= <mboton.lkml@gmail.com>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de
References: <200801042304.58071.mboton@gmail.com> <20080105150944.GA9595@elte.hu>
In-Reply-To: <20080105150944.GA9595@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200801052126.00016.mboton@gmail.com>
From: Miguel =?iso-8859-1?q?Bot=F3n?= <mboton.lkml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 05 January 2008 16:09:44 Ingo Molnar wrote:
> * Miguel Botón <mboton.lkml@gmail.com> wrote:
> > Before 'topology_32.h' and 'topology_64.h' were unified, topology
> > defines in a X86_64 kernel were declared if CONFIG_SMP was enabled.
> > Now, post unification, these same defines in a X86_64 kernel are only
> > being declared if CONFIG_NUMA and CONFIG_SMP are enabled.
> >
> > This, for example, breaks 'perfmon_amd64.c' compilation.
> >
> > This patch defines ENABLE_TOPO_DEFINE if this is a X86_64 kernel and
> > we have SMP support enabled.
>
> hm, do you have a .config that fails to build?
>
> 	Ingo

I had a .config (I deleted it) that fails to build *but* using the tree from 
http://git.kernel.org/?p=linux/kernel/git/eranian/linux-2.6.git;a=summary

The problem was that CONFIG_NUMA wasn't defined so ENABLE_TOPO_DEFINE wasn't 
defined too and then we get an error about an implicit declaration 
of 'topology_physical_package_id'.

-- 
	Miguel Botón
