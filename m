Return-Path: <linux-kernel-owner+w=401wt.eu-S1753468AbYH1Gqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468AbYH1Gqq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 02:46:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbYH1Gqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 02:46:39 -0400
Received: from silene.metacarta.com ([208.80.142.18]:59433 "EHLO
	silene.metacarta.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbYH1Gqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 02:46:38 -0400
X-Greylist: delayed 1103 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Aug 2008 02:46:38 EDT
Date: Thu, 28 Aug 2008 02:28:12 -0400 (EDT)
From: Joe Malicki <jmalicki@metacarta.com>
To: David Miller <davem@davemloft.net>
Cc: andi@firstfloor.org, johnpol@2ka.mipt.ru, dada1@cosmosbay.com,
       denys@visp.net.lb, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       juhlenko@akamai.com, sammy@sammy.net
Message-ID: <21915755.1327801219904892242.JavaMail.root@ouachita>
In-Reply-To: <20080827.201020.17601834.davem@davemloft.net>
Subject: Re: loaded router, excessive getnstimeofday in oprofile
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [76.19.65.59]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- "David Miller" <davem@davemloft.net> wrote:
> 
> Every application using AF_PACKET sockets gets timestamps by
> default.  And we do know of several specific cases where the
> timestamps are unnecessary.
> 
> Even for other cases, why in the world does a DHCP client need
> accurate timestamps?  Give me a break. :)
> 

I've worked with systems where SO_TIMESTAMP has been used for
H.323 videoconferencing systems to synchronize audio and video
where remote systems' timestamps on the protocol streams proved
to be inaccurate (based off of different, unsynchronized clocks).

I can't see any other realistic use of this, but trying to get
timestamps for quasi-realtime protocols may be an important use
case - and in that case, you want the time when it hits the
interface, NOT when it hits the socket.

What utility does the time of hitting the socket get you?
