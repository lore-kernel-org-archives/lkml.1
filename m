Return-Path: <linux-kernel-owner+w=401wt.eu-S1765409AbZFQLfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765409AbZFQLfm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 07:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752604AbZFQLfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 07:35:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47142
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751850AbZFQLfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 07:35:31 -0400
Date: Wed, 17 Jun 2009 04:35:34 -0700 (PDT)
Message-Id: <20090617.043534.259824726.davem@davemloft.net>
To: mingo@elte.hu
Cc: eric.dumazet@gmail.com, tglx@linutronix.de, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, kaber@trash.net
Subject: Re: [bug] __nf_ct_refresh_acct(): WARNING: at lib/list_debug.c:30
 __list_add+0x7d/0xad()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090617110803.GA10175@elte.hu>
References: <20090617092152.GA17449@elte.hu>
	<4A38C2F3.3000009@gmail.com>
	<20090617110803.GA10175@elte.hu>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Wed, 17 Jun 2009 13:08:03 +0200

> 
> * Eric Dumazet <eric.dumazet@gmail.com> wrote:
> 
>> IPS_CONFIRMED_BIT is set under nf_conntrack_lock (in __nf_conntrack_confirm()),
>> we probably want to add a synchronisation under ct->lock as well,
>> or __nf_ct_refresh_acct() could set ct->timeout.expires to extra_jiffies,
>> while a different cpu could confirm the conntrack.
>> 
>> Following patch as RFC
> 
> A quick test suggests that it seems to works here - thanks Eric!

Patrick, please take a quick look at Eric's fix.  I'd like to
apply it quickly if it looks good to you.

Thanks!
