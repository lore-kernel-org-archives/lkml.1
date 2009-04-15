Return-Path: <linux-kernel-owner+w=401wt.eu-S1757094AbZDOIZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757094AbZDOIZj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 04:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754112AbZDOIZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 04:25:18 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57773 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752923AbZDOIZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 04:25:17 -0400
Message-ID: <49E59A1C.9030108@cn.fujitsu.com>
Date: Wed, 15 Apr 2009 16:26:04 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jiri Pirko <jpirko@redhat.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, jgarzik@pobox.com,
       davem@davemloft.net, shemminger@linux-foundation.org,
       bridge@lists.linux-foundation.org, fubar@us.ibm.com,
       bonding-devel@lists.sourceforge.net, kaber@trash.net,
       mschmidt@redhat.com, dada1@cosmosbay.com, ivecera@redhat.com
Subject: Re: [PATCH 1/3] net: introduce a list of device addresses dev_addr_list
References: <20090313183303.GF3436@psychotron.englab.brq.redhat.com> <20090415081720.GA21342@psychotron.englab.brq.redhat.com> <20090415081819.GB21342@psychotron.englab.brq.redhat.com>
In-Reply-To: <20090415081819.GB21342@psychotron.englab.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static int __hw_addr_add_ii(struct list_head *list, unsigned char *addr,
> +			    int addr_len, int ignore_index)
> +{
> +	struct netdev_hw_addr *ha;
> +	int i = 0;
> +
> +	if (addr_len > MAX_ADDR_LEN)
> +		return -EINVAL;
> +
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(ha, list, list) {
> +		if (i++ != ignore_index &&
> +		    !memcmp(ha->addr, addr, addr_len)) {
> +			ha->refcount++;
> +			return 0;

missing rcu_read_unlock() ?

> +		}
> +	}
> +	rcu_read_unlock();
