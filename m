Return-Path: <linux-kernel-owner+w=401wt.eu-S1752145AbZHaLqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145AbZHaLqy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 07:46:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751178AbZHaLqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 07:46:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45468
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751105AbZHaLqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 07:46:52 -0400
Date: Mon, 31 Aug 2009 04:47:06 -0700 (PDT)
Message-Id: <20090831.044706.230442890.davem@davemloft.net>
To: nhorman@tuxdriver.com
Cc: eric.dumazet@gmail.com, xiaoguangrong@cn.fujitsu.com, yjwei@cn.fujitsu.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend] drop_monitor: fix trace_napi_poll_hit()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090831111245.GA2105@hmsreliant.think-freely.org>
References: <4A9B6963.5090207@cn.fujitsu.com>
	<4A9B6E57.7090703@gmail.com>
	<20090831111245.GA2105@hmsreliant.think-freely.org>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Neil Horman <nhorman@tuxdriver.com>
Date: Mon, 31 Aug 2009 07:12:46 -0400

> If its not going to be consistently updated, why are still carrying
> that field in dev?  Are we just waiting on someone to do the
> janitorial work to remove it?  If so, I can, and I'll fix up the
> drop monitor in the process, to use a private timestamp.

It's used only for bonding, so we only update it when a device
receives packet as part of a bond.

%99.9999 of people are not in that situation, and in that case this is
a very wasteful and expensive cacheline dirtying, so we elide it when
we can.
