Return-Path: <linux-kernel-owner+w=401wt.eu-S1758120AbZBXP4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120AbZBXP4Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 10:56:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755588AbZBXP4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 10:56:16 -0500
Received: from one.firstfloor.org ([213.235.205.2]:40582 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755288AbZBXP4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 10:56:15 -0500
To: Parav Pandit <paravpandit@yahoo.com>
Cc: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Suspected sock_sendmsg() with MSG_DONTWAIT can block bug.
From: Andi Kleen <andi@firstfloor.org>
References: <74923.15071.qm@web30107.mail.mud.yahoo.com>
Date: Tue, 24 Feb 2009 16:54:30 +0100
In-Reply-To: <74923.15071.qm@web30107.mail.mud.yahoo.com> (Parav Pandit's message of "Tue, 24 Feb 2009 06:40:42 -0800 (PST)")
Message-ID: <878wnv4yq1.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parav Pandit <paravpandit@yahoo.com> writes:

> Short quick question:
> ---------------------
> If sock_sendmsg() is calls with MSG_DONTWAIT, it should send the packet without blocking the context or fail the call with error value.

It is allowed to fail with errors.

> Which means sock_sendmsg() with MSG_DONTWAIT can be called from soft-irq/ interrupt ctx.
> Is that correct?

No. It can still block for memory for example. Also there's no irq locking
in place Irq context is not allowed. MSG_DONTWAIT just means don't block
on buffer space or connection finish.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
