Return-Path: <linux-kernel-owner+w=401wt.eu-S1753333AbYJTMj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbYJTMj0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 08:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751518AbYJTMjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 08:39:18 -0400
Received: from ns0.motion-twin.com ([213.186.50.39]:46458 "EHLO
	mail.motion-twin.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbYJTMjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 08:39:18 -0400
Message-ID: <48FC7BEE.1020701@motion-twin.com>
Date: Mon, 20 Oct 2008 14:39:10 +0200
From: Nicolas Cannasse <ncannasse@motion-twin.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: swivel@shells.gnugeneration.com
CC: linux-kernel@vger.kernel.org
Subject: Re: poll() blocked / packets not received ?
References: <48FC4066.9060303@motion-twin.com> <20081020101549.GH2811@fc6222126.aspadmin.net> <48FC61A0.7010003@motion-twin.com> <20081020113942.GJ2811@fc6222126.aspadmin.net>
In-Reply-To: <20081020113942.GJ2811@fc6222126.aspadmin.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> TCP being reliable can block indefinitely, you can employ TCP keepalive
> to change indefinite to quite a long time.

Ok, funny thing is that we just found what is occurring...

We had a process that was on a regular basis doing the following :

conntrack -F

This was done in order to prevent the table to grow too big, because we 
were reaching the maximum size as told by :

/proc/sys/net/ipv4/netfilter/ip_conntrack_max
   and
/proc/sys/net/ipv4/netfilter/ip_conntrack_count

Seems like when there are active connections, this will break netfilter 
and stop delivering packets to the socket.

At least I will have nice sleep tonight.

Best,
Nicolas
