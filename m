Return-Path: <linux-kernel-owner+w=401wt.eu-S1753387AbZAIMDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387AbZAIMDm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 07:03:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754043AbZAIMD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 07:03:29 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:57824 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753188AbZAIMD2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 07:03:28 -0500
Message-ID: <49673D02.6000002@garzik.org>
Date: Fri, 09 Jan 2009 07:03:14 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
CC: Tejun Heo <tj@kernel.org>, "Justin P. Mattock" <justinmattock@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jgarzik@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] libata: use WARN_ON_ONCE on hot paths
References: <b6fcc0a0901081202m30be591fse66e7f38477e0c0c@mail.gmail.com>	 <20090108221753.78648cd6@daedalus.pq.iki.fi>	 <20090108125317.648397d2@infradead.org> <49667C36.4080300@gmail.com>	 <20090108143127.437c15de@infradead.org> <4966974B.3090700@gmail.com>	 <49672166.4050606@gmail.com> <496724A2.5030400@kernel.org> <c4e36d110901090331r7c1cf06cy25c4a3a3579e47de@mail.gmail.com>
In-Reply-To: <c4e36d110901090331r7c1cf06cy25c4a3a3579e47de@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zdenek Kabelac wrote:
> 2009/1/9 Tejun Heo <tj@kernel.org>:
>> Convert WARN_ON() on command issue/completion paths to WARN_ON_ONCE()
>> so that libata doesn't spam the machine even when one of those
>> conditions triggers repeatedly.
>>
> 
> 
> Hi
> 
> I've not yet applied this patch - but now I'm getting these WARNS on my T61:
> (commit: 2150edc6c5cf00f7adb54538b9ea2a3e9cedca3f)
> 
> Is this patch solving the problem or just hiding warnings ?

Hiding warnings.  As Tejun noted in another email, this condition should 
not be happening in the first place.

If I had to guess, I would say that Arjan's patches assume it is OK to 
treat two ports on a single IDE controller as completely independent, 
when that is not really the reality of the hardware.

	Jeff




