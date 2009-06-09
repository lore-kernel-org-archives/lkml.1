Return-Path: <linux-kernel-owner+w=401wt.eu-S1754660AbZFIS1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660AbZFIS1q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 14:27:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751688AbZFIS1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 14:27:36 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:40381 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbZFIS1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 14:27:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nx3Q2N+JGdaxXObiWKAb5avcVcC9M5AUvONIEhEUACYL0zARo+VZHtGyaW43yK+FHr
         4D9RTS94vCtkvNxUA5+4yzmD9tDKUzV/exv4WR8Bmuk5tJUWykAGI+nVBLeDZI1mTp8d
         olNpMzgvjmGLNnJqU+WjTVnxHy96YjFrfsyyg=
Date: Tue, 9 Jun 2009 20:27:32 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       David Miller <davem@davemloft.net>, Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH RESEND] ftrace: change the export format of
	trace_kfree_skb()
Message-ID: <20090609182730.GA6057@nowhere>
References: <4A2DF91F.7030906@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A2DF91F.7030906@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 09, 2009 at 01:54:39PM +0800, Xiao Guangrong wrote:
> Use %pf instead of %p to output the function's address, use 0x%04X instead
> of %u to output the skb's protocol
> 
> Before patch:
> 
>           <idle>-0     [000] 60144.542521: kfree_skb: skbaddr=de7b8240 protocol=2048 location=c1365429
>           <idle>-0     [000] 60164.488153: kfree_skb: skbaddr=da66f900 protocol=2048 location=c1365429
>           <idle>-0     [000] 60193.493933: kfree_skb: skbaddr=deaeb480 protocol=4 location=c134ec25
>           <idle>-0     [000] 60253.118421: kfree_skb: skbaddr=de7c4900 protocol=4 location=c134ec25
>           
> After patch:
> 
>             bash-2587  [001] 97685.781173: kfree_skb: skbaddr=deb9cc00 protocol=0x0000 location=netlink_unicast
>             bash-2587  [000] 97686.501121: kfree_skb: skbaddr=df9bb840 protocol=0x0000 location=netlink_unicast
>           <idle>-0     [000] 97696.200184: kfree_skb: skbaddr=df741240 protocol=0x0800 location=ip_rcv
>           <idle>-0     [000] 97696.200198: kfree_skb: skbaddr=dfb3de40 protocol=0x0800 location=ip_rcv
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>


Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

Would you also be interested in adding the conversion from raw numeric protocol
to its name defined in include/linux/if_ether.h

I guess __print_flags() can be used for that.

Thanks,
Frederic.


> ---
> 
> Recover the file mode of include/trace/events/skb.h
> 
> ---
>  include/trace/events/skb.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
> index 1e8fabb..a58bef8 100644
> --- a/include/trace/events/skb.h
> +++ b/include/trace/events/skb.h
> @@ -30,7 +30,7 @@ TRACE_EVENT(kfree_skb,
>  		__entry->location = location;
>  	),
>  
> -	TP_printk("skbaddr=%p protocol=%u location=%p",
> +	TP_printk("skbaddr=%p protocol=0x%04X location=%pf",
>  		__entry->skbaddr, __entry->protocol, __entry->location)
>  );
>  
> -- 
> 1.6.1.2
> 

