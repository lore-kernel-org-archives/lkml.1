Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495Ab0BELqp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 06:46:45 -0500
Received: from darkstar.wilibox.com ([195.14.175.138]:36243 "EHLO
	darkstar.wilibox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126Ab0BELqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 06:46:44 -0500
Message-ID: <4B6C051F.3080702@gmail.com>
Date: Fri, 05 Feb 2010 13:46:39 +0200
From: Paulius Zaleckas <paulius.zaleckas@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
Newsgroups: gmane.linux.network,gmane.linux.kernel
To: Li Zefan <lizf@cn.fujitsu.com>
CC: David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 11/13] net: irda: use seq_list_foo() helpers
References: <4B6B77FE.5000104@cn.fujitsu.com> <4B6B78AD.1030809@cn.fujitsu.com>
In-Reply-To: <4B6B78AD.1030809@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2010 03:47 AM, Li Zefan wrote:
[...]
>   /* Return entry after v, and increment pos */
> @@ -1148,14 +1137,7 @@ static void *irlan_seq_next(struct seq_file *seq, void *v, loff_t *pos)
>   {
>   	struct list_head *nxt;

you should remove nxt declaration.

> -	++*pos;
> -	if (v == SEQ_START_TOKEN)
> -		nxt = irlans.next;
> -	else
> -		nxt = ((struct irlan_cb *)v)->dev_list.next;
> -
> -	return (nxt ==&irlans) ? NULL
> -		: list_entry(nxt, struct irlan_cb, dev_list);
> +	return seq_list_next(v,&irlans, pos);
>   }
[...]
