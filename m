Return-Path: <linux-kernel-owner+w=401wt.eu-S1422657AbXC2WXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422657AbXC2WXW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 18:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945894AbXC2WXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 18:23:22 -0400
Received: from smtp.osdl.org ([65.172.181.24]:41220 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422651AbXC2WXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 18:23:21 -0400
Date: Thu, 29 Mar 2007 15:23:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Helge Hafting <helgehaf@aitel.hist.no>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc5-mm2 - compile error on x86-64
Message-Id: <20070329152317.56df80d0.akpm@linux-foundation.org>
In-Reply-To: <m1mz1vem51.fsf@ebiederm.dsl.xmission.com>
References: <20070326211627.c681af3b.akpm@linux-foundation.org>
	<20070329182020.GA9223@aitel.hist.no>
	<20070329142816.5d18d89f.akpm@linux-foundation.org>
	<m1mz1vem51.fsf@ebiederm.dsl.xmission.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Mar 2007 16:10:50 -0600
ebiederm@xmission.com (Eric W. Biederman) wrote:

> Andrew Morton <akpm@linux-foundation.org> writes:
> >
> > Ah.  I assume you have CONFIG_SYSCTL=y, CONFIG_PROC_SYSCTL=n?
> >
> >
> >
> >
> > From: Andrew Morton <akpm@linux-foundation.org>
> >
> > We're using #ifdef CONFIG_SYSCTL, but we should be using CONFIG_PROC_SYSCTL,
> > so we get
> 
> I have no problem with the patch it is clearly more correct than what we
> are doing now but I didn't think it was possible to select
> CONFIG_SYSCTL and CONFIG_PROCFS without CONFIG_PROC_SYSCTL being
> selected...
> Do we have a constraint problem in Kconfig?  Or am I misremembering things?
> 

config PROC_SYSCTL
        bool "Sysctl support (/proc/sys)" if EMBEDDED
        depends on PROC_FS
        select SYSCTL
        default y

CONFIG_PROC_SYSCTL depends on CONFIG_PROC_FS
CONFIG_PROC_SYSCTL selects CONFIG_SYSCTL

So I don't see anything preventing CONFIG_SYSCTL=y, CONFIG_PROC_FS=y,
CONFIG_PROC_SYSCTL=n.  I assume we can make this combination compile, link
and run easily enough.  I dunno if it makes any actual sense though?


I'd have thought that PROC_SYSCTL should just depend on SYSCTL.  But
SYSCTL's Kconfig setup is weird.

