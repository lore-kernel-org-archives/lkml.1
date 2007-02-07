Return-Path: <linux-kernel-owner+w=401wt.eu-S1030511AbXBGJcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030511AbXBGJcH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 04:32:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030600AbXBGJcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 04:32:06 -0500
Received: from mail2.domainserver.de ([213.83.41.143]:2260 "EHLO
	smtp.domainserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030511AbXBGJcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 04:32:05 -0500
Envelope-to: linux-kernel@vger.kernel.org
Delivery-date: Wed, 07 Feb 2007 10:32:05 +0100
From: Daniel Kabs <dkabs@mobotix.com>
Organization: MOBOTIX AG
To: David Miller <davem@davemloft.net>
Subject: Re: Problem with unix sockets: SOCK_DGRAM ignores MSG_TRUNC
Date: Wed, 7 Feb 2007 10:31:57 +0100
User-Agent: KMail/1.7.2
Cc: linux-kernel@vger.kernel.org
References: <200701291259.50155.dkabs@mobotix.com> <20070204.165235.26305735.davem@davemloft.net>
In-Reply-To: <20070204.165235.26305735.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702071031.58463.dkabs@mobotix.com>
X-AUTH: - 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 February 2007 01:52, David Miller wrote:
> What UDP is doing is different, it's returning the full packet length
> when the packet is larger then the given buffer size, but it does this
> irregardless of whether you set MSG_TRUNC in the recvmsg() passed-in
> flags.  UDP itself sets the MSG_TRUNC flag when it detects this
> situation.

I hope that I am researching the appropriate kernel source tree, but if I 
am not mistaken, this behaviour was introduced with change 1.66 according 
to bitkeeper:
  http://linux.bkbits.net:8080/linux-2.6/net/ipv4/udp.c?PAGE=history

I think the bitkeeper comment on that change (1.66) is misleading:
  "[UDP]: Return true length if user specifies MSG_TRUNC."

As you said, this is wrong. The true length is returned, regardless 
whether the user specified MSG_TRUNC.

Exploring this topic I learned a lot about browsing and reading kernel 
source code, e.g. that commit statements have to be taken with a grain of 
salt :-)

Cheers
Daniel
