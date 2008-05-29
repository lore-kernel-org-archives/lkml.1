Return-Path: <linux-kernel-owner+w=401wt.eu-S1756915AbYE2Q4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915AbYE2Q4u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 12:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753495AbYE2Q4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 12:56:43 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:1883 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221AbYE2Q4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 12:56:42 -0400
From: "David Schwartz" <davids@webmaster.com>
To: <linux-kernel@vger.kernel.org>
Subject: RE: Question regarding TCP behavior
Date: Thu, 29 May 2008 09:56:09 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKGEFDNAAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <fb7befa20805290829n5bf70832wc8c4129a8433d802@mail.gmail.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Thu, 29 May 2008 09:57:56 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Thu, 29 May 2008 09:57:56 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Greetings.
>
> I have a question about how linux's TCP stack behaves.
> I apologize if this is not the right place to ask this question and
> please redirect me.
>
> When a TCP end point (A) sends x bytes of data to the other end point (B),
> does B immediately ACK the received bytes or will it do so only
> when the data
> is passed to the upper layer ?
>
>
> Thanks
> Thomas

If the TCP connection was idle and there is no unacknowledged data in either
direction, the answer is neither.

Acknowledging the data immediately is wasteful. There's a very good chance
another packet is right behind this one and delaying the acknowledgement
would save a packet.

Waiting for upper layers is disastrous, it could result in the other end
timing out and retransmitting and would limit the end of slow start based on
user-space speeds.

Google "delayed ACK".
http://www.freesoft.org/CIE/RFC/1122/110.htm

DS


