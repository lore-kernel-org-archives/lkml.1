Return-Path: <linux-kernel-owner+w=401wt.eu-S1752594AbZI2OEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594AbZI2OEX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 10:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbZI2OEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 10:04:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698AbZI2OEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 10:04:21 -0400
Date: Tue, 29 Sep 2009 15:59:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Evgeny Polyakov <johnpol@2ka.mipt.ru>,
       Scott James Remnant <scott@ubuntu.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Matt Helsley <matthltc@us.ibm.com>,
       "David S. Miller" <davem@davemloft.net>,
       Evgeniy Polyakov <zbr@ioremap.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] connector: Fix sid connector (was: Badness at
	kernel/softirq.c:143...)
Message-ID: <20090929135959.GA6806@redhat.com>
References: <200909251123.03482.borntraeger@de.ibm.com> <fbbbe0a028fa.4ac1f1c0@2ka.mipt.ru> <20090929132415.GB4538@redhat.com> <200909291547.21528.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909291547.21528.borntraeger@de.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29, Christian Borntraeger wrote:
>
> --- linux-2.6.orig/kernel/sys.c
> +++ linux-2.6/kernel/sys.c
> @@ -1110,6 +1110,8 @@ SYSCALL_DEFINE0(setsid)
>  	err = session;
>  out:
>  	write_unlock_irq(&tasklist_lock);
> +	if (!err)
> +		proc_sid_connector(sid);

sys_setsid() returns the session nr on success, not zero.

	if (err > 0)
		proc_sid_connector(sid);

Otherwize I think the patch is fine. Not only it should fix the problem,
imho it makes the code cleaner.

If Scott still thinks daemonize() should report too, we can change it.

(I'd suggest you to CC Andrew if you are going to re-send)

Oleg.

