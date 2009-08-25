Return-Path: <linux-kernel-owner+w=401wt.eu-S1755009AbZHYOEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755009AbZHYOEz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 10:04:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754642AbZHYOEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 10:04:54 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59651 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869AbZHYOEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 10:04:54 -0400
To: <Li_Xin2@emc.com>
Cc: <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: TCP keepalive timer problem
From: Andi Kleen <andi@firstfloor.org>
References: <0939B589FC103041945B9F13274963E303B1A9D4@CORPUSMX90A.corp.emc.com>
Date: Tue, 25 Aug 2009 16:04:54 +0200
In-Reply-To: <0939B589FC103041945B9F13274963E303B1A9D4@CORPUSMX90A.corp.emc.com> (Li Xin2's message of "Tue, 25 Aug 2009 04:32:45 -0400")
Message-ID: <87fxbgf0qh.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<Li_Xin2@emc.com> writes:

[cc netdev]

> Greetings,
>
> I found one problem in Linux TCP keepalive timer processing, after
> searching on google, I found Daniel Stempel reported the same problem in
> 2007 (http://lkml.indiana.edu/hypermail/linux/kernel/0702.2/1136.html),
> but got no answer. So I have to reraise it.
>
> Can anyone help answer this two-years long question?

I think the idea behind the tcp_keepalive_timer check referrenced in the 
other mail is: when there are outstanding non acked packets then 
the normal retransmit timer will do keep alive because it will
retransmit and retransmit in exponential backoff and eventually notice 
something is wrong.

The obvious hole is that if the keepalive is shorter than the worst
case retransmit timeout then you'll have to wait for the longer
timeout.  I presume that's what is happening for you? You set the 
keep alive timeout very low and expect the timeout to be very low,
but it's 30+mins (default retransmit timeout)?

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
