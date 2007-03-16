Return-Path: <linux-kernel-owner+w=401wt.eu-S1753459AbXCPKcE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbXCPKcE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 06:32:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753458AbXCPKcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 06:32:03 -0400
Received: from 207.47.60.4.static.nextweb.net ([207.47.60.4]:5834 "EHLO
	rpc.xensource.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753465AbXCPKcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 06:32:02 -0400
User-Agent: Microsoft-Entourage/11.2.5.060620
Date: Fri, 16 Mar 2007 10:31:49 +0000
Subject: Re: [Xen-devel] Re: [patch 21/26] Xen-paravirt_ops: Use the hvc
 console infrastructure for Xen console
From: Keir Fraser <keir@xensource.com>
To: Ingo Molnar <mingo@elte.hu>, Keir Fraser <Keir.Fraser@xensource.com>
CC: <virtualization@lists.osdl.org>, <xen-devel@lists.xensource.com>,
       Chris Wright <chrisw@sous-sol.org>, Andi Kleen <ak@muc.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>
Message-ID: <C2202295.BA49%keir@xensource.com>
Thread-Topic: [Xen-devel] Re: [patch 21/26] Xen-paravirt_ops: Use the hvc
 console infrastructure for Xen console
Thread-Index: Acdntk3HjC0cjtOpEduhtwAX8io7RQ==
In-Reply-To: <20070316095851.GB301@elte.hu>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/3/07 09:58, "Ingo Molnar" <mingo@elte.hu> wrote:

>> These mb()'s are pretty standard for lock-free producer/consumer
>> rings. Write descriptor /then/ write the updated producer. Read the
>> producer /then/ read any descriptors revealed by this new producer
>> value.
> 
> then use rmb()/wmb(). Rarely does a ring protocol truly need mb().

It's needed for writing data /after/ reading the consumer index that shows
you have space to write. Looking through xenbus_comms.c I think all the
barriers are correct except there is a spurious extra mb() in xb_read(),
where there is a later rmb() which is sufficient by itself. All the others
have a purpose.

 -- Keir

