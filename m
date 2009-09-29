Return-Path: <linux-kernel-owner+w=401wt.eu-S1752748AbZI2OQE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748AbZI2OQE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 10:16:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752507AbZI2OQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 10:16:04 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:34371 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454AbZI2OQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 10:16:02 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
Organization: IBM
To: Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: [PATCH] connector: Fix sid connector (was: Badness at kernel/softirq.c:143...)
Date: Tue, 29 Sep 2009 16:15:38 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-release; KDE/4.3.1; i686; ; )
Cc: Oleg Nesterov <oleg@redhat.com>, Evgeny Polyakov <johnpol@2ka.mipt.ru>,
       Scott James Remnant <scott@ubuntu.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Matt Helsley <matthltc@us.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <200909251123.03482.borntraeger@de.ibm.com> <200909291547.21528.borntraeger@de.ibm.com> <20090929140718.GA23858@ioremap.net>
In-Reply-To: <20090929140718.GA23858@ioremap.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909291615.38457.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 29 September 2009 16:07:18 schrieb Evgeniy Polyakov:
> Your patch breaks assumption that task_session(current->group_leader) is
> not equal to new session id, but to check task_session() we need either
> rcu or task lock. Also setsid() return value is not zero or negative
> error, but new session ID or negative error,

Right.

> so I believe attached patch is a proper fix, although it looks rather ugly.
> 
> Also proc_sid_connector() uses GFP_KERNEL allocation which is way too
> wrong to use under any locks.
> 
> Something like this (not tested :)

Patch compiles and seems to work.

Christian
