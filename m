Return-Path: <linux-kernel-owner+w=401wt.eu-S1759512AbZFZSQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759512AbZFZSQ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 14:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752400AbZFZSQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 14:16:16 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:54967 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbZFZSQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 14:16:15 -0400
X-AuthUser: davidel@xmailserver.org
Date: Fri, 26 Jun 2009 11:12:15 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Oleg Nesterov <oleg@redhat.com>
cc: Eric Dumazet <eric.dumazet@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
       netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       fbl@redhat.com, nhorman@redhat.com, davem@redhat.com,
       Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] net: fix race in the receive/select
In-Reply-To: <20090626145027.GA6534@redhat.com>
Message-ID: <alpine.DEB.1.10.0906261111230.16400@makko.or.mcafeemobile.com>
References: <20090625122545.GA3625@jolsa.lab.eng.brq.redhat.com> <20090625122416.GA23613@redhat.com> <alpine.DEB.1.10.0906251827510.9517@makko.or.mcafeemobile.com> <4A442B65.8040701@gmail.com> <alpine.DEB.1.10.0906251858520.9517@makko.or.mcafeemobile.com>
 <4A443033.8060401@gmail.com> <alpine.DEB.1.10.0906251947530.9517@makko.or.mcafeemobile.com> <20090626135742.GB3845@redhat.com> <alpine.DEB.1.10.0906261018580.16400@makko.or.mcafeemobile.com> <20090626145027.GA6534@redhat.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jun 2009, Oleg Nesterov wrote:

> Perhaps we can add
> 
> 	void sock_poll_wait(struct file *file, struct sock *sk, poll_table *pt)
> 	{
> 		if (pt) {
> 			poll_wait(file, sk->sk_sleep, pt);
> 			/*
> 			 * fat comment
> 			 */
> 			smp_mb(); // or smp_mb__after_unlock();
> 		}
> 	}

That'd be fine IMHO. Are DaveM and Eric OK?


- Davide


