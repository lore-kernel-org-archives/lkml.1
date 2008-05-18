Return-Path: <linux-kernel-owner+w=401wt.eu-S1759567AbYERBoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759567AbYERBoj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 21:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756544AbYERBo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 21:44:28 -0400
Received: from stinky.trash.net ([213.144.137.162]:55842 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755624AbYERBo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 21:44:27 -0400
Message-ID: <482F89B2.6060108@trash.net>
Date: Sun, 18 May 2008 03:43:14 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080420)
MIME-Version: 1.0
To: Ben Hutchings <bhutchings@solarflare.com>
CC: James Cammarata <jimi@sngx.net>, Eric Dumazet <dada1@cosmosbay.com>,
       linux-kernel@vger.kernel.org,
       Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: [PATCH updated] net: add ability to clear per-interface network
 statistics via procfs
References: <482DA5B6.1020606@sngx.net> <482DB46A.8020103@cosmosbay.com> <482EF192.4070707@sngx.net> <482F5113.5090703@cosmosbay.com> <482F610D.2080108@sngx.net> <20080518003104.GK28241@solarflare.com>
In-Reply-To: <20080518003104.GK28241@solarflare.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Hutchings wrote:
>> +                        dev = dev_get_by_name(net,devname);
>> +                        if (dev) {
>> +                                if (dev->get_stats) {
>> +                                        struct net_device_stats *stats =
>> +                                               dev->get_stats(dev);
>> +                                        memset(stats,0,
>> +                                               sizeof(struct 
>> net_device_stats));

This doesn't work for devices that generate the stats (for
example by reading them from the hardware) in ->get_stats().

