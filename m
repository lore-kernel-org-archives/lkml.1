Return-Path: <linux-kernel-owner+w=401wt.eu-S1756074AbYABC52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074AbYABC52 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 21:57:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753015AbYABC5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 21:57:18 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:28362 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbYABC5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 21:57:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:references:subject:date:message-id:mime-version:content-type:content-transfer-encoding:x-mailer:in-reply-to:x-mimeole:thread-index;
        b=q8L/Pcx7k2a6SA6nVAEGgug3Spnrcvb7NtmKA9QviT72afuUundDDpTgKwQXjXJYN/3SjZ+OCf0nnUbGsIY0mPhK3KthaAzcgehVhfj0DZCfJsdLFqDBOu5aQZtaGvj0BLssk+PpA2XgugeFohEcruRdYK8EmnlesaD7MKPL/7g=
From: "Joonwoo Park" <joonwpark81@gmail.com>
To: "'Jay Cliburn'" <jacliburn@bellsouth.net>
Cc: <jeff@garzik.org>, <csnook@redhat.com>, <linux-kernel@vger.kernel.org>,
       <atl1-devel@lists.sourceforge.net>, <netdev@vger.kernel.org>,
       <shemminger@linux-foundation.org>
References: <1199152804-3889-1-git-send-email-jacliburn@bellsouth.net><1199152804-3889-26-git-send-email-jacliburn@bellsouth.net> <20080101121536.3df9c497@osprey.hogchain.net>
Subject: RE: [PATCH 25/26] [REVISED] atl1: add NAPI support
Date: Wed, 2 Jan 2008 11:56:36 +0900
Message-ID: <000001c84ceb$18a967c0$47e7a8c0@jason>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <20080101121536.3df9c497@osprey.hogchain.net>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Thread-Index: AchMou+zmJISjMw1TiCXm6mHQ8OAVgAQgyYg
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jay,

+	if ((work_done < budget) || !netif_running(poll_dev)) {
+quit_polling:
+		netif_rx_complete(poll_dev, napi);
+
+		if (!test_bit(__ATL1_DOWN, &adapter->flags))
+			atlx_irq_enable(adapter);
+	}

Not enough :)
If netif_running() is false, it can make problem.
The problem occurs calling netif_rx_complete with work_done == budget.
If do that, net_rx_action would do poll list double deletion.

Since we had reached a consensus on fixing it without each drivers modifications, there is no best solution for that problem for
now. I'm expecting Dave or others work for net-core.
(http://lkml.org/lkml/2007/12/20/600)

IMHO, atl1_clean should wait for work_done != budget even though netif_running is false at this time.
At least, It would not make oops.

Thanks,
Joonwoo

