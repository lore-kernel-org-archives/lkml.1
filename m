Return-Path: <linux-kernel-owner+w=401wt.eu-S1755909AbXFSO2D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909AbXFSO2D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 10:28:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751997AbXFSO1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 10:27:52 -0400
Received: from mail.screens.ru ([213.234.233.54]:56539 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753523AbXFSO1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 10:27:51 -0400
Date: Tue, 19 Jun 2007 18:27:30 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Cedric Le Goater <clg@fr.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Herbert Poetzl <herbert@13thfloor.at>, pbadari@us.ibm.com,
       containers@lists.osdl.org, ebiederm@xmission.com, serue@us.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] create_new_namespaces: fix improper return of NULL
Message-ID: <20070619142730.GA27361@tv-sign.ru>
References: <200705090245.l492jZwD008756@shell0.pdx.osdl.net> <20070616191742.GA13434@MAIL.13thfloor.at> <20070617143830.GA379@tv-sign.ru> <20070617163004.GA553@tv-sign.ru> <20070619135129.GA27343@tv-sign.ru> <4677E28C.5050304@fr.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4677E28C.5050304@fr.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19, Cedric Le Goater wrote:
>
> Oleg Nesterov wrote:
> > Untested.
> > 
> > dup_mnt_ns() and clone_uts_ns() return NULL on failure. This is wrong,
> > create_new_namespaces() uses ERR_PTR() to catch an error. This means
> > that the subsequent create_new_namespaces() will hit BUG_ON() in
> > copy_mnt_ns() or copy_utsname().
> 
> I sent one just like it :
> 
> 	http://lkml.org/lkml/2007/6/12/142

Ah, thanks.

Your patch is more complete, it also fixes kernel/user_namespace.c (which
I don't see in 2.6.22-rc5). I don't this this fix is urgent, so...

Andrew, please ignore this patch.

Oleg.

