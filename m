Return-Path: <linux-kernel-owner+w=401wt.eu-S1756307AbYKQBv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307AbYKQBv5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 20:51:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754747AbYKQBvf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 20:51:35 -0500
Received: from relay1.sgi.com ([192.48.179.29]:37935 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754667AbYKQBve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 20:51:34 -0500
Message-ID: <4920CE21.1090202@sgi.com>
Date: Sun, 16 Nov 2008 17:51:29 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Yinghai Lu <yinghai@kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparse_irq aka dyn_irq v13
References: <491434FB.2050904@kernel.org> <20081107124957.GA21709@elte.hu>	 <49168BD3.5010204@kernel.org> <20081109073813.GA17180@elte.hu>	 <86802c440811090003g5ac53822y852a4c1096228f8b@mail.gmail.com>	 <20081110094033.GL22392@elte.hu>	 <20081110015511.453a801e.akpm@linux-foundation.org>	 <4918065A.6050402@kernel.org> <20081110100329.GA19970@elte.hu>	 <491A9F87.8040403@kernel.org> <20081112120814.GG11352@elte.hu>	 <491C8B38.9060901@kernel.org>	 <20081113131850.d94fb229.akpm@linux-foundation.org> <1226869137.7178.175.camel@pasglop> <4920B069.5020203@kernel.org> <4920B15E.6090200@zytor.com>
In-Reply-To: <4920B15E.6090200@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Yinghai Lu wrote:
>> 2. make irq number is bus/devfn/idx, and every dev func will use 12bit range, irq number is relatively fixed not like current MSI irq creating is some kind of floating from NR_IRQS too. 
> 
> 2 is *STILL WRONG*, dammit!
> 
> You keep bringing this one up, but our PCI addressing is
> *DOMAIN*/bus/devfn -- it falls flat on its face when you have more than
> 16 PCI domains.  CAN WE PLEASE STOP WITH THIS FOOLISHNESS NOW!
> 
> 	-hpa

Hmm, I was going to bring this up as well... ;-)

X was changed quite a while ago to domain/bus/dev/func, which was a lot easier to
deal with than trying to "offset" the bus with domain * some large number + bus.
Currently max nodes is 512 so it deserves it's own field. ;-)

Btw, are you suggesting combining device and function?  That might be inadvertently
squeezing something that shouldn't be.

Thanks,
Mike
