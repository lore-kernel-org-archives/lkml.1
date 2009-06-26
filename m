Return-Path: <linux-kernel-owner+w=401wt.eu-S1756700AbZFZCLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700AbZFZCLq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 22:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbZFZCLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 22:11:37 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58949
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752428AbZFZCLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 22:11:36 -0400
Date: Thu, 25 Jun 2009 19:11:41 -0700 (PDT)
Message-Id: <20090625.191141.261414015.davem@davemloft.net>
To: davidel@xmailserver.org
Cc: eric.dumazet@gmail.com, oleg@redhat.com, jolsa@redhat.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, fbl@redhat.com,
       nhorman@redhat.com, htejun@gmail.com
Subject: Re: [PATCH] net: fix race in the receive/select
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.DEB.1.10.0906251858520.9517@makko.or.mcafeemobile.com>
References: <alpine.DEB.1.10.0906251827510.9517@makko.or.mcafeemobile.com>
	<4A442B65.8040701@gmail.com>
	<alpine.DEB.1.10.0906251858520.9517@makko.or.mcafeemobile.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davide Libenzi <davidel@xmailserver.org>
Date: Thu, 25 Jun 2009 19:04:04 -0700 (PDT)

> On Fri, 26 Jun 2009, Eric Dumazet wrote:
> 
>> Adding a plain smp_mb() in tcp_poll() for example would slowdown select()/poll() with NULL
>> timeout.
> 
> Do you think of it as good design adding an MB on a subsystem, because of 
> the special locking logic of another one?
> The (eventual) slowdown, IMO can be argued sideways, by saying that 
> non-socket users will pay the price for their polls.

Perhaps every performance argument is moot since spin_unlock() used to
have the barrier :-)
