Return-Path: <linux-kernel-owner+w=401wt.eu-S1755536AbZLWVsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536AbZLWVsi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 16:48:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753511AbZLWVsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 16:48:37 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53202
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753892AbZLWVsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 16:48:35 -0500
Date: Wed, 23 Dec 2009 13:48:37 -0800 (PST)
Message-Id: <20091223.134837.189694575.davem@davemloft.net>
To: jason.wessel@windriver.com
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       kdb@oss.sgi.com, mingo@elte.hu
Subject: Re: [PATCH 07/37] kgdb,sparc: Add in kgdb_arch_set_pc for sparc
From: David Miller <davem@davemloft.net>
In-Reply-To: <1261603190-5036-8-git-send-email-jason.wessel@windriver.com>
References: <1261603190-5036-6-git-send-email-jason.wessel@windriver.com>
	<1261603190-5036-7-git-send-email-jason.wessel@windriver.com>
	<1261603190-5036-8-git-send-email-jason.wessel@windriver.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wessel <jason.wessel@windriver.com>
Date: Wed, 23 Dec 2009 15:19:20 -0600

> +void kgdb_arch_set_pc(struct pt_regs *regs, unsigned long ip)
> +{
> +       regs->pc = regs->npc;
> +       regs->npc = ip;
> +}
> +

Is this right?

It should probably be something like:

> +       regs->pc = ip;
> +       regs->npc = regs->pc + 4;

and similary for sparc64.
