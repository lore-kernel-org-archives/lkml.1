Return-Path: <linux-kernel-owner+w=401wt.eu-S1754800AbZCSMvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbZCSMvQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 08:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753569AbZCSMuz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 08:50:55 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:50079 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753308AbZCSMuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 08:50:54 -0400
Subject: Re: High contention on the sk_buff_head.lock
From: "Peter W. Morreale" <pmorreale@novell.com>
To: David Miller <davem@davemloft.net>
Cc: ghaskins@novell.com, vernux@us.ibm.com, andi@firstfloor.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, pmullaney@novell.com
In-Reply-To: <20090318.180355.228447835.davem@davemloft.net>
References: <49C16349.9030503@us.ibm.com>
	 <20090318.143844.173112261.davem@davemloft.net>
	 <49C16D7C.3080003@novell.com>
	 <20090318.180355.228447835.davem@davemloft.net>
Content-Type: text/plain
Organization: Linux Solutions Group
Date: Thu, 19 Mar 2009 06:50:44 -0600
Message-Id: <1237467044.6926.27.camel@hermosa>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-18 at 18:03 -0700, David Miller wrote:
> From: Gregory Haskins <ghaskins@novell.com>
> Date: Wed, 18 Mar 2009 17:54:04 -0400
> 
> > Note that -rt doesnt typically context-switch under contention anymore
> > since we introduced adaptive-locks.  Also note that the contention
> > against the lock is still contention, regardless of whether you have -rt
> > or not.  Its just that the slow-path to handle the contended case for
> > -rt is more expensive than mainline.  However, once you have the
> > contention as stated, you have already lost.
> 
> First, contention is not implicitly a bad thing.
> 
> Second, if the -rt kernel is doing adaptive spinning I see no
> reason why that adaptive spinning is not kicking in here to
> make this problem just go away.

The basic 'problem' with comparing RT adaptive spinning to non-rt
spinlocks is that if the lock owner is !oncpu, all spinners must break
and go to sleep, otherwise we (potentially) deadlock.  This does not
exist for non-rt spinners. 

Best,
-PWM


> 
> This lock is held for mere cycles, just to unlink an SKB from
> the networking qdisc, and then it is immediately released.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

