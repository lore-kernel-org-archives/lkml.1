Return-Path: <linux-kernel-owner+w=401wt.eu-S1757659AbYGKXZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757659AbYGKXZq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 19:25:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753580AbYGKXZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 19:25:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36269 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753295AbYGKXZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 19:25:39 -0400
Date: Fri, 11 Jul 2008 16:24:57 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bridge: send correct MTU value in PMTU
Message-ID: <20080711162457.76afddd7@extreme>
In-Reply-To: <20080711171935.GA25603@hrz.tu-chemnitz.de>
References: <20080711124735.GA16996@hrz.tu-chemnitz.de>
	<20080711083423.64b67c0c@extreme>
	<20080711171935.GA25603@hrz.tu-chemnitz.de>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2008 19:19:35 +0200
Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de> wrote:

> On Fri, Jul 11, 2008 at 08:34:23AM -0700, Stephen Hemminger wrote:
> > On Fri, 11 Jul 2008 14:47:35 +0200
> > Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de> wrote:
> > 
> > > [...]
> > 
> > 
> > port should always be non-null so the existing fake_rtable can
> > just go away no?
> 
> I wondered about that too. But since bridge_parent() is also checking port
> for NULL, and the code calling this is carefully checking these cases, i
> assumed that this is quite possible. If you can assert that port is
> non-NULL, we can remove this, but i have to admit that i don't get the
> whole picture to be sure about this.

bridge_parent can only be NULL if the bridge is process of deletion (via RCU).
So if bridge_parent() returns NULL, code should not bother with further processing
and return (dropping skb if this function does that).

