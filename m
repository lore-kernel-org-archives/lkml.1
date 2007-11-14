Return-Path: <linux-kernel-owner+w=401wt.eu-S1762736AbXKNExY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762736AbXKNExY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 23:53:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755855AbXKNExR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 23:53:17 -0500
Received: from ex1.resilience.com ([207.47.19.6]:21840 "EHLO
	ex1.resilience.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754912AbXKNExQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 23:53:16 -0500
X-Greylist: delayed 974 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Nov 2007 23:53:16 EST
Date: Wed, 14 Nov 2007 12:35:13 +0800
From: Jerry Jiang <wjiang@resilience.com>
To: linux-kernel@vger.kernel.org
Subject: [LOCK] Is it really necessary to use a "big module lock"?
Message-Id: <20071114123513.fbff2683.wjiang@resilience.com>
Organization: Resilience
X-Mailer: Sylpheed version 2.3.0beta5 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Nov 2007 04:36:43.0953 (UTC) FILETIME=[F55CEA10:01C82677]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi all,

I came across a question when review other's module code.

something like:

int __init module_init()
{
	down_interruptible(the_big_module_sem);
	// code for init...
	up(the_big_module_sem);
}

void __exit module_exit()
{
	down_interruptible(the_big_module_sem);
	// code for exit...
	up(the_big_module_sem);
}

My question is:
 - Is the lock truly necessary?
 - If adding it into code, what happens?

Thank you
-- Jerry
