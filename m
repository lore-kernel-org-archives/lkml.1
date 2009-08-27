Return-Path: <linux-kernel-owner+w=401wt.eu-S1752708AbZH0Nf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708AbZH0Nf1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 09:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbZH0NfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 09:35:24 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40737 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644AbZH0NfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 09:35:22 -0400
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Li_Xin2@emc.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: TCP keepalive timer problem
From: Andi Kleen <andi@firstfloor.org>
References: <0939B589FC103041945B9F13274963E303B1A9D4@CORPUSMX90A.corp.emc.com>
	<4A93E36C.8070502@gmail.com>
	<0939B589FC103041945B9F13274963E303B1AD89@CORPUSMX90A.corp.emc.com>
	<4A967FCE.3000807@gmail.com>
Date: Thu, 27 Aug 2009 15:35:22 +0200
In-Reply-To: <4A967FCE.3000807@gmail.com> (Eric Dumazet's message of "Thu, 27 Aug 2009 14:45:02 +0200")
Message-ID: <87skfdl6qt.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet <eric.dumazet@gmail.com> writes:
>
> Now, 7200 seconds might be inappropriate for special needs, and considering
> there is no way to change tcp_retries2 for a given socket (only choice being the global
> tcp_retries2 setting), I would vote for a change in our stack, to *relax* RFC,
> and get smaller keepalive timers if possible.

I think the better fix would be to just to only do that when
tcp_retries2 > keep alive time. So keep the existing behaviour
with default keep alive, but switch when the user defined
a very short keep alive.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
