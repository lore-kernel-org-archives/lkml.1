Return-Path: <linux-kernel-owner+w=401wt.eu-S1757323AbXGOIsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323AbXGOIsm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 04:48:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752532AbXGOIse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 04:48:34 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:37439 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752207AbXGOIsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 04:48:33 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:X-Enigmail-Version:OpenPGP:Content-Type:Content-Transfer-Encoding;
	b=AauoYCchfM4raqwKkdQsKgc64ZoAg0B2J90zF+D4NVTXBNLQ2zZC4PsH1TO3+GCO75VF0Sy9gs0s5znCyUh+3vJrkwLhRDIiVv8AsPLC4/61gFqZQGV1O4vSSaaS8BRk;
Message-ID: <4699DF5D.9050702@simon.arlott.org.uk>
Date: Sun, 15 Jul 2007 09:48:29 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Anand Jahagirdar <anandjigar@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Patch Related with Fork Bombing Attack
References: <25ae38200707130539j3b6689eet91bff4298023aa28@mail.gmail.com>
In-Reply-To: <25ae38200707130539j3b6689eet91bff4298023aa28@mail.gmail.com>
X-Enigmail-Version: 0.95.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/07/07 13:39, Anand Jahagirdar wrote:
> This patch Warns the administrator about the fork bombing attack
> (whenever any user is crossing its process limit). I have used

> +                                printk(KERN_WARNING "User with uid %u is crossing the process limit\n",p->user->uid);

I have mentioned this before when it was KERN_CRIT, why is this
KERN_WARNING? It seems reasonable to have loglevel at KERN_WARNING, then
it'd go to all consoles. Just because a fork bomb would trigger this
doesn't mean you can assume it is one and raise its severity.

If the limit is working correctly then there is no need to print anything...


Also, users can arbitrarily lower their limit at any time and trigger
this printk:

$ ulimit -Su 0
$ uptime
bash: fork: Resource temporarily unavailable


If you really think this is needed then the message needs changing,
because they haven't actually gone over the limit. I'm not sure how best
to word it. What about the other limits? Max memory size and cpu time
sound just as important as max user processes to me.

-- 
Simon Arlott
