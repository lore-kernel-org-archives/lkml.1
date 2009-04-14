Return-Path: <linux-kernel-owner+w=401wt.eu-S1753872AbZDNKRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbZDNKRY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 06:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752087AbZDNKRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 06:17:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33626 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965AbZDNKRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 06:17:10 -0400
Date: Tue, 14 Apr 2009 12:15:13 +0200
From: Jiri Pirko <jpirko@redhat.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, jgarzik@pobox.com,
       davem@davemloft.net, bridge@lists.linux-foundation.org,
       fubar@us.ibm.com, bonding-devel@lists.sourceforge.net, kaber@trash.net,
       mschmidt@redhat.com, dada1@cosmosbay.com, ivecera@redhat.com
Subject: Re: [PATCH 3/4] net: bridge: use device address list instead of
	dev_addr
Message-ID: <20090414101512.GA3999@psychotron.englab.brq.redhat.com>
References: <20090313183303.GF3436@psychotron.englab.brq.redhat.com> <20090413083729.GA23734@psychotron.englab.brq.redhat.com> <20090413084407.GD23734@psychotron.englab.brq.redhat.com> <20090413075400.34604e72@nehalam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090413075400.34604e72@nehalam>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mon, Apr 13, 2009 at 04:54:00PM CEST, shemminger@vyatta.com wrote:
>> +static int another_port_has_addr(const struct net_bridge_port *p,
>> +				 struct net_bridge_fdb_entry *f)
>> +{
>> +	struct net_bridge *br = p->br;
>> +	struct net_bridge_port *op;
>> +
>> +	list_for_each_entry(op, &br->port_list, list) {
>> +		if (op != p && is_dev_addr(op->dev, f->addr.addr)) {
>> +			f->dst = op;
>> +			return 1;
>> +		}
>> +	}
>> +	return 0;
>> +}
>
>Forwarding database is hot path, people sometimes run lots of devices
>on single bridge, doesn't this scale worse?
>
This only puts the original loop code to the function, so if compiler decides to
inline this there might be no difference.
