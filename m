Return-Path: <linux-kernel-owner+w=401wt.eu-S1756481AbYDJIXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481AbYDJIXV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 04:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752789AbYDJIXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 04:23:13 -0400
Received: from sacred.ru ([62.205.161.221]:37413 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752418AbYDJIXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 04:23:13 -0400
Message-ID: <47FDD267.80700@openvz.org>
Date: Thu, 10 Apr 2008 12:40:07 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>, Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Alexey Dobriyan <adobriyan@openvz.org>
CC: Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/10] Make bsd process accounting work in pid namespaces
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Thu, 10 Apr 2008 12:15:17 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After I fixed access to task->tgid in kernel/acct.c, Oleg
pointed out some bad side effects with this accounting vs
pid namespaces interaction.

So here is the approach to make this accounting work with
pid namespaces properly.

The idea is simple - when task dies it accounts itself in
each namespace it is visible from. That was the summary,
the details are in patches.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
