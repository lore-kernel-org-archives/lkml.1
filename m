Return-Path: <linux-kernel-owner+w=401wt.eu-S934574AbXJQUWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934574AbXJQUWI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 16:22:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757654AbXJQUVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 16:21:52 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37197 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757054AbXJQUVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 16:21:51 -0400
Date: Wed, 17 Oct 2007 13:21:31 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: "David S. Miller" <davem@davemloft.net>, Andrew Morton <akpm@osdl.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC] remove netpoll receive code
Message-ID: <20071017132131.1992bedd@freepuppy.rosehill>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.14; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The netpoll receive code is:
1. Not used by any in-tree features, it is used by kgdb-over-ether.
2. A nice hook for people doing nasty things like private binary network stacks or rootkits.
3. Unsecured by any of the normal firewalling code.

Hopefully all distro's are smart enough to turn it off in their default config *nudge, nudge*.
Doubly true for any distribution that claims to be secure or enterprise ready.

I propose that we take out all the whole netpoll rx path. If/when kgdb gets submitted
a better and alternative receive path can be added.

-- 
Stephen Hemminger <shemminger@linux-foundation.org>
