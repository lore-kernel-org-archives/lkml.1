Return-Path: <linux-kernel-owner+w=401wt.eu-S1757223AbXEUJAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223AbXEUJAZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 05:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761104AbXEUJAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 05:00:08 -0400
Received: from wr-out-0506.google.com ([64.233.184.232]:8772 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755784AbXEUJAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 05:00:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=YnMnik5CBuMg/tXanetlxYFOPyIA1HV2s/NwLswRLU2VO5ZmxoZZQE+5nLP3NqiSDgj7Q/1LSpRFe53zbSOfbLy7gX/bqyaHw4+Oitohrdr3wDNRquH36qmRmsmtc5pTwVBt1CXw6th7TL9kgrs5S+jXfX9h7GDgEGXiBv3/vVM=
Message-ID: <46515F82.9070606@gmail.com>
Date: Mon, 21 May 2007 10:59:46 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Jarek Poplawski <jarkao2@o2.pl>
CC: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@linux-foundation.org>,
       David Chinner <dgc@sgi.com>, David Howells <dhowells@redhat.com>,
       Gautham Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] make cancel_rearming_delayed_work() reliable
References: <4645559D.4050602@gmail.com> <20070513192753.GA3014@tv-sign.ru> <46477239.9030007@gmail.com> <20070514194446.GA159@tv-sign.ru> <46496EC1.3090109@gmail.com> <20070515220024.GA615@tv-sign.ru> <464AEA47.7030600@gmail.com> <20070516185203.GB81@tv-sign.ru> <20070518073517.GB1573@ff.dom.local> <464DAB3D.4020000@gmail.com> <20070521070036.GA1695@ff.dom.local>
In-Reply-To: <20070521070036.GA1695@ff.dom.local>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Jarek Poplawski wrote:
> If we want to stick to more understanable, established ways,
> why don't we use a global lock (not per cpu but per work or
> per workqueue) for insert_work(), which would be really the
> simplest construct here. Probably because some compromise is
> needed. On the other hand many locks could be replaced with
> elaborate constructs with atomic operations like this. But
> for some reasons this usually isn't done.
> 
> IMHO it's better to get used to barriers, because, as seen
> in this thread, even after finding better solution, the
> problem of execution ordering didn't disappear. Another
> "strange" question is: if these barriers are so tough, why
> Oleg managed to do them seemingly right from the very first
> time? But even if he would do some error here, I think it
> should be easier to check for this one problem only, than to
> risk the "stability" of the whole algorithm by changing more.
> Of course now, after the time was spent anyway, this new
> "old-way" is more attractive.

Well, it might be just because I'm used to what I call 'locked
enter/leave' model.  If people don't find that easier to understand, no
objection from me and kudos to Oleg for getting it right from the beginning.

>> I think things can be made more similar to the locked enter/leave model
>> using the extra bit by putting manipulation and testing of the bit into
>> accesor functions, so readability was my primary concern not
>> performance.  But, then again, we can probably make the barrier() model
>> readable enough too with proper accessor functions and plenty of
>> comments above them.
> 
> Yes, the good thing is Oleg can choose between two good
> solutions here! (I don't envy him...)

As long as it's documented sufficiently, both are good.  It's your
decision, Oleg.  :-)

-- 
tejun
