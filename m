Return-Path: <linux-kernel-owner+w=401wt.eu-S1760485AbYETCex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760485AbYETCex (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 22:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756129AbYETCep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 22:34:45 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48866
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755057AbYETCeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 22:34:44 -0400
Date: Mon, 19 May 2008 19:34:39 -0700 (PDT)
Message-Id: <20080519.193439.31663045.davem@davemloft.net>
To: benh@kernel.crashing.org
Cc: geoffrey.levand@am.sony.com, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, paulus@samba.org
Subject: Re: [patch v2] LMB: Add basic spin locking to lmb
From: David Miller <davem@davemloft.net>
In-Reply-To: <1211250778.8297.159.camel@pasglop>
References: <48322191.6060909@am.sony.com>
	<20080519.192215.193701293.davem@davemloft.net>
	<1211250778.8297.159.camel@pasglop>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Mon, 19 May 2008 22:32:58 -0400

> I think the core memory hotplug is... However, we used to not change the
> LMB when doing so (afaik, I'm travelling and not looking at the code
> right now). However, things like PS3 memory hotplug tries to keep LMB is
> sync for the sake of /dev/mem or similar and that happens before the
> memory is added to the core.

But if the memory hotplug is synchronized, so are changes to the LMB
tables.

And if there are LMB read side access concernes outside of the hotplug
event, ideally we should use the synchronization mechanism that
hotplug uses instead of adding a new one.
