Return-Path: <linux-kernel-owner+w=401wt.eu-S1752027AbZC3MsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027AbZC3MsV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 08:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750919AbZC3MsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 08:48:07 -0400
Received: from stinky.trash.net ([213.144.137.162]:60176 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbZC3MsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 08:48:05 -0400
Message-ID: <49D0BF7F.1060305@trash.net>
Date: Mon, 30 Mar 2009 14:47:59 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Jiri Pirko <jpirko@redhat.com>
CC: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, jgarzik@pobox.com,
       shemminger@linux-foundation.org, bridge@lists.linux-foundation.org,
       fubar@us.ibm.com, bonding-devel@lists.sourceforge.net,
       mschmidt@redhat.com, dada1@cosmosbay.com
Subject: Re: [PATCH] bonding: allow bond in mode balance-alb to work	properly
 in bridge -try4
References: <20090326155205.GA28868@psychotron.englab.brq.redhat.com> <20090327.003819.234492275.davem@davemloft.net> <49CC85E9.7070903@trash.net> <20090329.135355.109115565.davem@davemloft.net> <49D0B549.3050900@trash.net> <20090330124049.GD3438@psychotron.englab.brq.redhat.com>
In-Reply-To: <20090330124049.GD3438@psychotron.englab.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Pirko wrote:
> Currently I'm thinking the way. What I have on mind:
> I would like to add a list into struct net_device to contain all mac addresses
> of the device. I would also like to use similar interface to handle them as
> currently is for uc_list and mc_list. However I do not like that these lists are
> not using standard list_head but they are propriate lists only for this purpose.
> I'm thinking about converting them to use list_head first. Or maybe ignore them
> and do the new list for macs in parallel?

Using list_heads in the address lists would require some pretty large
amount of work since you'd need to convert all the drivers. I'm all
in favour of doing this, but I wouldn't make the fix depend on that
work.

