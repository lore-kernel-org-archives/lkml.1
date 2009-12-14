Return-Path: <linux-kernel-owner+w=401wt.eu-S932533AbZLNTYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932533AbZLNTYX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 14:24:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932556AbZLNTYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 14:24:10 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38533
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932504AbZLNTYE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 14:24:04 -0500
Date: Mon, 14 Dec 2009 11:24:06 -0800 (PST)
Message-Id: <20091214.112406.149143587.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: john.dykstra1@gmail.com, lists@nerdbynature.de,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Badness at net/ipv4/inet_connection_sock.c:293
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B269065.5000601@gmail.com>
References: <1260817033.9141.8.camel@merlyn>
	<20091214.111105.224947761.davem@davemloft.net>
	<4B269065.5000601@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 14 Dec 2009 20:22:13 +0100

> Le 14/12/2009 20:11, David Miller a écrit :
>> From: John Dykstra <john.dykstra1@gmail.com>
>> Date: Mon, 14 Dec 2009 18:57:13 +0000
>> 
>>> That test was changed to match a change in the return values of
>>> tcp_ack().  No logic change was intended.
>> 
>> As Eric pointed out, changing tcp_ack()'s behavior effects state
>> transitions out of SYN_ACK, so this commit is very likely the culprit.
>> 
>> I usually see 2 or 3 three of these bug triggers in the first ten
>> minutes after bootup and I haven't seen one yet in 20 minutes
>> with the commit reverted.
>> 
>> This change is definitely wrong.
> 
> Hmm, I didnt yet spotted the problem, just gave some hints ...

You did point out that tcp_ack's behavior could influence
TCP_SYN_* state behavior, and that's all I claimed.

My "definitely wrong" conclusion was based upon not triggering
the warning for several minutes (which turned out to be a fluke),
not your analysis.
