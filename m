Return-Path: <linux-kernel-owner+w=401wt.eu-S1753802AbZFXG6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802AbZFXG6l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 02:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751915AbZFXG6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 02:58:35 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49227
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750720AbZFXG6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 02:58:34 -0400
Date: Tue, 23 Jun 2009 23:58:38 -0700 (PDT)
Message-Id: <20090623.235838.129947362.davem@davemloft.net>
To: nhorman@tuxdriver.com
Cc: xiaoguangrong@cn.fujitsu.com, mingo@elte.hu, fweisbec@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       rostedt@goodmis.org
Subject: Re: [PATCH v2] ftrace: change the export format of
 trace_kfree_skb()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090618103538.GA8978@hmsreliant.think-freely.org>
References: <20090610072618.GA6016@nowhere>
	<4A39B3E4.6060004@cn.fujitsu.com>
	<20090618103538.GA8978@hmsreliant.think-freely.org>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


FWIW there are parts I don't like about this change.

It's just the show_protocol_name() bit, it's designed to always be
out of date.

Nobody is going to look at trace/events/skb.h when they add a new
ETH_P_* value.

We could make some include/linux/eth_protos.def file, that has
lines like:

ETHERNET_PROTOCOL(ETH_P_FOO, N)

then headers that want to instantiate something like the usual
ETH_P_FOO defines or this symbolic printing table define
"ETHERNET_PROTOCOL" to a suitable macro and then include
linux/eth_protos.def to make the expansions.
