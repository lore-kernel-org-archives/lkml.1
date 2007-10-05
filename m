Return-Path: <linux-kernel-owner+w=401wt.eu-S1763666AbXJEPsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763666AbXJEPsf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 11:48:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757929AbXJEPs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 11:48:27 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:34091 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762869AbXJEPs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 11:48:26 -0400
Date: Fri, 5 Oct 2007 21:29:35 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Luciano Rocha <strange@nsk.no-ip.org>, linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, dhaval@linux.vnet.ibm.com
Subject: Re: can't change euid 0 to uid != running user
Message-ID: <20071005155935.GA8148@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20071005142541.GA9224@bit.office.eurotux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071005142541.GA9224@bit.office.eurotux.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2007 at 03:25:43PM +0100, Luciano Rocha wrote:
> I have the following problem:
> $ sudo -u ie -s # or sudo su ie
> unable to change to runas uid: Resource temporarily unavailable
> 
> Works:
> $ sudo su, followed by su ie
> 
> The first sudo also worked while I had a shell under user ie.
> 
> When I exited, it stopped working, but it is now working every time I
> trie it.
> 
> dmesg shows:
> 
> [82602.729330] kobject_add failed for 504 with -EEXIST, don't try to
>                register things with the same name in the same directory.
> [82602.729365]  [<c04b9195>] kobject_shadow_add+0x16e/0x1a0
> [82602.729383]  [<c04b9480>] kobject_set_name+0x29/0x92
> [82602.729504]  [<c04238ea>] user_kobject_create+0x6a/0x90
> [82602.729520]  [<c0423cce>] alloc_uid+0x18f/0x1d7
> [82602.729530]  [<c0427030>] set_user+0x1c/0x8f
> [82602.729539]  [<c0428b5f>] sys_setresuid+0xd5/0x162
> [82602.729552]  [<c0403e6a>] syscall_call+0x7/0xb
> [82602.729575]  =======================

This seems to be similar to the problem Ingo reported
(http://marc.info/?l=linux-kernel&m=119125007102969). We have sent a fix
for it subsequently (http://marc.info/?l=linux-kernel&m=119143193812026).

Can you resync to Ingo's latest cfs-devel tree (which will remove the
bad patch you have), then apply the patch at
http://marc.info/?l=linux-kernel&m=119143193812026 and verify if the
problem goes away?


-- 
Regards,
vatsa
