Return-Path: <linux-kernel-owner+w=401wt.eu-S1758016AbXJXVBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016AbXJXVBA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 17:01:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753749AbXJXVAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 17:00:50 -0400
Received: from atlrel9.hp.com ([156.153.255.214]:51730 "EHLO atlrel9.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753427AbXJXVAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 17:00:48 -0400
Message-ID: <471FB260.8090503@hp.com>
Date: Wed, 24 Oct 2007 17:00:16 -0400
From: Vlad Yasevich <vladislav.yasevich@hp.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: David Stevens <dlstevens@us.ibm.com>
Cc: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, netdev-owner@vger.kernel.org
Subject: Re: [2.6 patch] unexport icmpmsg_statistics
References: <OF03E20988.736A2E51-ON8825737E.007067FE-8825737E.0071B902@us.ibm.com>
In-Reply-To: <OF03E20988.736A2E51-ON8825737E.007067FE-8825737E.0071B902@us.ibm.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Stevens wrote:
> My bad -- I see what it's doing, and it looks ok after all.
> 
> I thought I saw an INMSGS (but didn't).  These are ICMP errors that
> went through icmp_rcv() and were counted correctly before getting
> to the protocol error handlers. These are failures due mostly to not
> having enough, or the right protocol info in the error packet being
> handled. I'm not sure I'd count those as ICMP errors, since the
> ICMP header itself is correct, but ok...
> 
> SCTP doesn't look so bad, though I think the references are
> still questionable (but debatable) as ICMP errors.
> 
> sctp_v4_err is incrementing ICMP_MIB_INERRORS if there
> isn't enough IP header to find the ports, I see. I'm not sure
> that counts as an ICMP error, but it's not so terrible.
> 
> It's doing the same thing if a lookup fails to match "vtag" from
> the encapsulated error packet. Again, I don't know that those
> are ICMP errors (which normally are something wrong with
> the ICMP header).

This particular case is the one that bugs the most, but that
error matches best.

Seems like all ULPs treat socket lookup error as ICMP_MIB_INERRORS
(tcp, udp, sctp, dccp).

SCTP is a little special in that in needs to check one one piece
of data (the 'vtag') to correctly identify the connection.
If that piece doesn't match, we treat that as the same error.

-vlad
