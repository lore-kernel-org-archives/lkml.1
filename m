Return-Path: <linux-kernel-owner+w=401wt.eu-S1757604AbYCCIyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604AbYCCIyR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 03:54:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753548AbYCCIyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 03:54:00 -0500
Received: from sacred.ru ([62.205.161.221]:46513 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753505AbYCCIx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 03:53:59 -0500
Message-ID: <47CBBC61.1010605@openvz.org>
Date: Mon, 03 Mar 2008 11:52:49 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Alexey Dobriyan <adobriyan@openvz.org>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] Fix /proc/net in presence of net namespaces
References: <47C6D743.1050802@openvz.org>	<m1y794514k.fsf@ebiederm.dsl.xmission.com> <47C7B779.808@openvz.org> <m1ve453lkp.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1ve453lkp.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Mon, 03 Mar 2008 11:52:44 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Pavel Emelyanov <xemul@openvz.org> writes:
> 
>> I could use the struct net pointer values (obtained with sprintf(id, "%p", net))
>> instead, but exporting internal kernel addresses seemed even uglier.
> 
> Agreed.
> 
>>> Can you try this approach by capturing a struct pid instead of an id
>>> in a new global namespace? 
>> This is a bad approach. When task, that created the namespace dies, his
>> pid is removed from the pidmap and can be reused, so we can get another
>> net with the same id.
> 
> It takes a little updating of how we use pids.  The easiest method
> is to add an extra counter.  So we know when someone besides the hash
> chains is using the pid as an id.  However it might make sense to actually
> have a net namespace pointer in the pid.

No, please, no. I'm strongly opposed to making pids provide identification
for anything we need in the kernel.

>> This net's id is not supposed to be used to address any net in the kernel.
>> And I see no problems with migration - you can change the net's id safely
>> during checkpoint/restart - tasks will always see this one via the /proc/net
>> symlink, which is dynamic.
> 
> So you are really talking about a hidden id.  There are just enough
> ways for something like that to slip out I'm not especially
> comfortable with the idea.
> 
> I really think we need something clean that we can live with, and be
> proud of.  However we implement the enhancement to /proc/net this has
> to be maintained for decades.
> 
> Eric
> 

