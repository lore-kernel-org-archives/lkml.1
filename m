Return-Path: <linux-kernel-owner+w=401wt.eu-S1754945AbXLAUVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945AbXLAUVm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 15:21:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753283AbXLAUVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 15:21:16 -0500
Received: from rtr.ca ([76.10.145.34]:2796 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753091AbXLAUVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 15:21:14 -0500
Message-ID: <4751C238.6010609@rtr.ca>
Date: Sat, 01 Dec 2007 15:21:12 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>, Greg KH <greg@kroah.com>,
       Tejun Heo <htejun@gmail.com>,
       Linux Containers <containers@lists.osdl.org>, netdev@vger.kernel.org,
       cornelia.huck@de.ibm.com, stern@rowland.harvard.edu,
       kay.sievers@vrfy.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: namespace support requires network modules to say "GPL"
References: <m163zi9425.fsf@ebiederm.dsl.xmission.com>	<47515D39.9030900@rtr.ca> <20071201111736.297dd99a@freepuppy.rosehill>	<20071201192341.6750fbdb@the-village.bc.nu>	<20071201113815.5df0960a@freepuppy.rosehill> <m13aum5g1x.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m13aum5g1x.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Stephen Hemminger <shemminger@linux-foundation.org> writes:
> 
>> Actually, the whole mess would go away if the api for dev_get_by_XXXX hadn't
>> been changed in the namespace transition. IMHO the interface to
>> dev_get_by_name()
>> should not have added a namespace parameter, of the callers in the tree, only
>> two use a different namespace. So it would have been better to to introduce
>> dev_get_by_name_ns() with the extra parameter.
> 
> As a general rule if you are calling dev_get_by_name and taking an &init_net
> parameter that means you code has not yet been converted to actually support
> network namespaces.
> 
> Not everything can be safely changed at once so we take it by steps.  When
> the code fully supports network namespaces practically nothing will take
> an &init_net parameter.  The network namespace parameter will come in
> some form from userspace.  Either from current or from the network
> socket.
> 
> Except for boot time initialization I don't know of any cases using
> dev_get_by_XXXX that won't need to be modified before the network
> namespace work is complete.
> 
> I believe I mentioned that this getting the fully network namespace
> support was going to take a while and a bunch of patches at the
> outset.
> 
>> Can we get this resolved before 2.6.24 is released? Going back and forth
>> on API's is just needless frottage.
> 
> Sure.  We keep the updated dev_get_by_XXXX that takes a network
> namespace parameter.
..

And what should code be passing in when "# CONFIG_NET_NS is not set" ?
