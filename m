Return-Path: <linux-kernel-owner+w=401wt.eu-S932958AbXIQVSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932958AbXIQVSj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 17:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932809AbXIQVRa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 17:17:30 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34920 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760990AbXIQVR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 17:17:28 -0400
Date: Mon, 17 Sep 2007 14:16:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [2.6.23-rc4-mm1][Bug] kernel BUG at
 include/linux/netdevice.h:339!
Message-Id: <20070917141622.330b27b8.akpm@linux-foundation.org>
In-Reply-To: <46EE7026.2070203@linux.vnet.ibm.com>
References: <46EE7026.2070203@linux.vnet.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Sep 2007 17:46:38 +0530
Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:

> Kernel Bug is hit with 2.6.23-rc4-mm1 kernel on ppc64 machine.
> 
> kernel BUG at include/linux/netdevice.h:339!

(please cc netdev@vger.kernel.org on networking-related matters)

You died here:

static inline void napi_complete(struct napi_struct *n)
{
        BUG_ON(!test_bit(NAPI_STATE_SCHED, &n->state));

The NAPI changes have had a few problems and hopefully things have
been fixed up since then.  I'll try to get rc6-mm1 out this evening,
so please retest that?
