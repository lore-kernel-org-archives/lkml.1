Return-Path: <linux-kernel-owner+w=401wt.eu-S1753309AbXDMJcG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309AbXDMJcG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 05:32:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753367AbXDMJcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 05:32:06 -0400
Received: from 207.47.60.4.static.nextweb.net ([207.47.60.4]:30583 "EHLO
	rpc.xensource.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753309AbXDMJcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 05:32:05 -0400
User-Agent: Microsoft-Entourage/11.3.3.061214
Date: Fri, 13 Apr 2007 10:31:49 +0100
Subject: Re: [PATCH 0/4] i386 - pte update optimizations
From: Keir Fraser <keir@xensource.com>
To: Zachary Amsden <zach@vmware.com>, "H. Peter Anvin" <hpa@zytor.com>
CC: Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Chris Wright <chrisw@sous-sol.org>,
       David Rientjes <rientjes@google.com>, Hugh Dickins <hugh@veritas.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <C2450C95.D3F6%keir@xensource.com>
Thread-Topic: [PATCH 0/4] i386 - pte update optimizations
Thread-Index: Acd9ro+UzhQNXOmhEdu6zAAX8io7RQ==
In-Reply-To: <461EE9E5.6060403@vmware.com>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/4/07 03:24, "Zachary Amsden" <zach@vmware.com> wrote:

>> You do know that P6 and higher don't do locked bus references as long
>> as the value is in the cache, right?
> 
> Yes.  Even then, last time I clocked instructions, xchg was still slower
> than read / write, although I could be misremembering.  And it's not
> totally clear that they will always be in cached state, however, and for
> SMP, we still want to drop the implicit lock in cases where the
> processor might not know they are cached exclusive, but we know there
> are no other racing users.  And there are plenty of old processors out
> there to still make it worthwhile.

LOCKed instruction suck really badly on the netburst microarchitecture (like
factor of 10x, or not far off). I think it's probably because of their side
effect of serialising memory accesses, causing horrible pipeline stalls.

 -- Keir

