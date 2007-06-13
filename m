Return-Path: <linux-kernel-owner+w=401wt.eu-S1758127AbXFMLe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127AbXFMLe3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 07:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757459AbXFMLeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 07:34:20 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:42882 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757406AbXFMLeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 07:34:19 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Received:Message-ID:In-Reply-To:References:Date:Subject:From:To:Cc:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Priority:Importance;
	b=nQFXv+WgIhte9w8BYeQa68Pzw8661xbIHRI72fH29WAcb1hSwSw/QMPR540UYjNuGE0KOFIeFDQegwdoNbrj+orxl7CzUOnvNaUWzWpBtpgTnB9KMgbQHYKMtd9mJYwo;
Message-ID: <38425.simon.1181734449@5ec7c279.invalid>
In-Reply-To: <Pine.LNX.4.64.0706121931390.19578@fbirervta.pbzchgretzou.qr>
References: <25ae38200706120949vaeb8e0ascd182ef2f709d0fc@mail.gmail.com>
    <adalkep85pq.fsf@cisco.com>
    <Pine.LNX.4.64.0706121931390.19578@fbirervta.pbzchgretzou.qr>
Date: Wed, 13 Jun 2007 12:34:09 +0100
Subject: Re: Patch related with Fork Bobmbing Attack
From: "Simon Arlott" <simon@fire.lp0.eu>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Cc: "Roland Dreier" <rdreier@cisco.com>,
       "Anand Jahagirdar" <anandjigar@gmail.com>, linux-kernel@vger.kernel.org,
       security@kernel.org, "Andrew Morton" <akpm@linux-foundation.org>,
       akpm@digeo.com, "Daniel Hazelton" <dhazelton@enter.net>,
       "Jens Axboe" <jens.axboe@oracle.com>, "Jiri Kosina" <jikos@jikos.cz>
User-Agent: SquirrelMail/1.4.9a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, June 12, 2007 18:32, Jan Engelhardt wrote:
> On Jun 12 2007 10:04, Roland Dreier wrote:
>> > +	/*
>> > +         * following code does not allow Non Root User to cross its process
>> > +         * limit. it alerts administrator about fork bombing attack and prevents
>> > +         * it.
>> > +         */
>> >  	if (atomic_read(&p->user->processes) >= p->signal->rlim[RLIMIT_NPROC].rlim_cur)
>> >  		if (!capable(CAP_SYS_ADMIN) && !capable(CAP_SYS_RESOURCE) &&
>> > -				p->user != &root_user)
>> > -
>> > +				p->user != &root_user) {
>> > +			if (printk_ratelimit())
>> > +                                printk(KERN_CRIT"User with uid %d is crossing its process
>> limit\n",p->user->uid);
>> >  			goto bad_fork_free;
>> > +		}

Why does this need to be KERN_CRIT? You can't assume that every time a process limit is reached that it's a
fork bomb.

-- 
Simon Arlott
