Return-Path: <linux-kernel-owner+w=401wt.eu-S1759084AbZDOIcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759084AbZDOIcQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 04:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883AbZDOIb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 04:31:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46662 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755484AbZDOIb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 04:31:56 -0400
Date: Wed, 15 Apr 2009 10:29:24 +0200
From: Jiri Pirko <jpirko@redhat.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, jgarzik@pobox.com,
       davem@davemloft.net, shemminger@linux-foundation.org,
       bridge@lists.linux-foundation.org, fubar@us.ibm.com,
       bonding-devel@lists.sourceforge.net, kaber@trash.net,
       mschmidt@redhat.com, dada1@cosmosbay.com, ivecera@redhat.com
Subject: Re: [PATCH 1/3] net: introduce a list of device addresses
	dev_addr_list
Message-ID: <20090415082924.GE21342@psychotron.englab.brq.redhat.com>
References: <20090313183303.GF3436@psychotron.englab.brq.redhat.com> <20090415081720.GA21342@psychotron.englab.brq.redhat.com> <20090415081819.GB21342@psychotron.englab.brq.redhat.com> <49E59A1C.9030108@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E59A1C.9030108@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wed, Apr 15, 2009 at 10:26:04AM CEST, lizf@cn.fujitsu.com wrote:
>> +static int __hw_addr_add_ii(struct list_head *list, unsigned char *addr,
>> +			    int addr_len, int ignore_index)
>> +{
>> +	struct netdev_hw_addr *ha;
>> +	int i = 0;
>> +
>> +	if (addr_len > MAX_ADDR_LEN)
>> +		return -EINVAL;
>> +
>> +	rcu_read_lock();
>> +	list_for_each_entry_rcu(ha, list, list) {
>> +		if (i++ != ignore_index &&
>> +		    !memcmp(ha->addr, addr, addr_len)) {
>> +			ha->refcount++;
>> +			return 0;
>
>missing rcu_read_unlock() ?
>
Sure! Thanks...
>> +		}
>> +	}
>> +	rcu_read_unlock();
