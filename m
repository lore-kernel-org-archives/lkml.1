Return-Path: <linux-kernel-owner+w=401wt.eu-S1760011AbXFSPmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760011AbXFSPmR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 11:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758125AbXFSPmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 11:42:04 -0400
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:29296 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757599AbXFSPmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 11:42:01 -0400
Message-ID: <4677F942.6080909@fr.ibm.com>
Date: Tue, 19 Jun 2007 17:41:54 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Herbert Poetzl <herbert@13thfloor.at>, pbadari@us.ibm.com,
       containers@lists.osdl.org, ebiederm@xmission.com, serue@us.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] create_new_namespaces: fix improper return of NULL
References: <200705090245.l492jZwD008756@shell0.pdx.osdl.net> <20070616191742.GA13434@MAIL.13thfloor.at> <20070617143830.GA379@tv-sign.ru> <20070617163004.GA553@tv-sign.ru> <20070619135129.GA27343@tv-sign.ru> <4677E28C.5050304@fr.ibm.com> <20070619142730.GA27361@tv-sign.ru>
In-Reply-To: <20070619142730.GA27361@tv-sign.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> On 06/19, Cedric Le Goater wrote:
>> Oleg Nesterov wrote:
>>> Untested.
>>>
>>> dup_mnt_ns() and clone_uts_ns() return NULL on failure. This is wrong,
>>> create_new_namespaces() uses ERR_PTR() to catch an error. This means
>>> that the subsequent create_new_namespaces() will hit BUG_ON() in
>>> copy_mnt_ns() or copy_utsname().
>> I sent one just like it :
>>
>> 	http://lkml.org/lkml/2007/6/12/142
> 
> Ah, thanks.
> 
> Your patch is more complete, it also fixes kernel/user_namespace.c (which
> I don't see in 2.6.22-rc5). I don't this this fix is urgent, so...

This patch applies on top of previous i've sent to andrew. 
kernel/user_namespace.c should be in -mm.

Thanks,

C. 
