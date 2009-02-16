Return-Path: <linux-kernel-owner+w=401wt.eu-S1754911AbZBPQ0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911AbZBPQ0R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 11:26:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751421AbZBPQZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 11:25:58 -0500
Received: from stinky.trash.net ([213.144.137.162]:62601 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbZBPQZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 11:25:57 -0500
Message-ID: <49999393.3040105@trash.net>
Date: Mon, 16 Feb 2009 17:25:55 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: netdev@vger.kernel.org,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] SNAT sometimes allows packets to pass through unchanged
References: <Pine.LNX.4.44L0.0902161112360.15521-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0902161112360.15521-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Mon, 16 Feb 2009, Patrick McHardy wrote:
> 
>>> I tried adding a rule to log these unaccounted-for packets.  Nothing 
>>> showed up, even when I could see the packets being sent.
>> Where (table/chain/position) did you add this rule?
> 
> In the first position of the POSTROUTING chain in the nat table.  I
> don't remember exactly what rules I used, but at one point I tried
> something very much like this:
> 
> iptables -t nat -I POSTROUTING 1 -s 10.0.0.0/8 -p tcp ! --syn
> 
> The counter for this rule remained at 0 even after packets with private 
> source addresses were sent through the public interface.

The NAT table only sees the first packet of every connection
and never INVALID packets. The mangle table should work fine.

You can also enable conntrack-internal logging of invalid packets:

echo 255 >/proc/sys/net/netfilter/nf_conntrack_log_invalid

>> Sorry, there were quite a few patches and I don't remember which
>> ones exactly are related.
> 
> I tried using 2 6.27 kernel but the problem remained.  Building a later 
> version won't be easy because of the need to create the proper config.  
> Can you remember in which version these bugs got fixed?

Sorry, no.
