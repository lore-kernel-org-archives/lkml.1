Return-Path: <linux-kernel-owner+w=401wt.eu-S1755957AbYBQMF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957AbYBQMF2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 07:05:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754580AbYBQMFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 07:05:17 -0500
Received: from twin.jikos.cz ([213.151.79.26]:36871 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051AbYBQMFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 07:05:16 -0500
Date: Sun, 17 Feb 2008 13:04:59 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
cc: linux-kernel@vger.kernel.org, panther@balabit.hu,
       Laszlo Attila Toth <panther@balabit.hu>,
       "David S. Miller" <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: My system stops during startup with curretn git tree of 2.6.25-rc2
In-Reply-To: <c4e36d110802170255x19755c03s33502ddf7410f324@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0802171301430.7699@twin.jikos.cz>
References: <c4e36d110802170255x19755c03s33502ddf7410f324@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Feb 2008, Zdenek Kabelac wrote:

> It looks like there is something weird as my systems stops when the swap 
> is mounted. I've played bisection game and this is the commit which 
> makes the system unusable:
> # bad: [45b503548210fe6f23e92b856421c2a3f05fd034] [RTNETLINK]: Send a
> single notification on device state changes.
> git-bisect bad 45b503548210fe6f23e92b856421c2a3f05fd034
> I've tried to reverse this commit - and it has compiled & worked.

This commit is completely broken (it, for example, breaks locking around 
dev->link_mode), as has been already mentioned by Rafael at 
http://lkml.org/lkml/2008/2/15/542

Dave, do you have a proper fix queued? Otherwise I would propose just to 
revert it completely from Linus' tree for now.

-- 
Jiri Kosina

