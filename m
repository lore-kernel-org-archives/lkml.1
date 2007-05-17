Return-Path: <linux-kernel-owner+w=401wt.eu-S1759197AbXEQFvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759197AbXEQFvv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 01:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757072AbXEQFvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 01:51:44 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33695
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756866AbXEQFvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 01:51:44 -0400
Date: Wed, 16 May 2007 22:51:29 -0700 (PDT)
Message-Id: <20070516.225129.74748893.davem@davemloft.net>
To: ssatyam@cse.iitk.ac.in
Cc: akpm@linux-foundation.org, marcel@holtmann.org, jikos@jikos.cz,
       gregkh@suse.de, jeremy@goop.org, maxk@qualcomm.com, clg@fr.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bluetooth: fix locking in hci_sock_dev_event()
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0705171106550.9262@cselinux1.cse.iitk.ac.in>
References: <Pine.LNX.4.64.0705171106550.9262@cselinux1.cse.iitk.ac.in>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Date: Thu, 17 May 2007 11:13:36 +0530 (IST)

> [PATCH] bluetooth: fix locking in hci_sock_dev_event()
> 
> We presently use lock_sock() to acquire a lock on a socket in
> hci_sock_dev_event(), but this goes BUG because lock_sock()
> can sleep and we're already holding a read-write spinlock at
> that point. So, we must use the non-sleeping BH version,
> bh_lock_sock().
> 
> However, hci_sock_dev_event() is called from user context and
> hence using simply bh_lock_sock() will deadlock against a
> concurrent softirq that tries to acquire a lock on the same
> socket. Hence, disabling BH's before acquiring the socket lock
> and enable them afterwards, is the proper solution to fix
> socket locking in hci_sock_dev_event().
> 
> Cc: David Miller <davem@davemloft.net>
> Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
> Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>

Thanks I'll merge this in.
