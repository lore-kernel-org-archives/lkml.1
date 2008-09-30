Return-Path: <linux-kernel-owner+w=401wt.eu-S1752774AbYI3HWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774AbYI3HWR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 03:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751442AbYI3HWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 03:22:05 -0400
Received: from smtp111.mail.mud.yahoo.com ([209.191.84.64]:46678 "HELO
	smtp111.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751298AbYI3HWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 03:22:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=zefSXRo0o1AzZJLyyoVtmkiCfGd8i82lB6XiTUK/YiOO8/MmPD5f3xiJN0kZcJX4sQx53JOi2Vmwo2bn2OloJ8NfOl56mx2bpM6/VuKYXxNTrwM1mpGeylhRgVc3+Eai+NU0Hfe3WREHVVSN7W8b/dMK6pCbRO5Pst9EfqLVeQw=  ;
X-YMail-OSG: IYXbtsAVM1kKps7sZx7JAZ90MZbOD2gb8EZzOB1zVvFmf3Qe3WsFeNjXg0jSXuqB2N6PInkp9HXM8YAosXOhqJHqrKNeRgWj2eE6Euf0eNQcVNS.R4twEx803uxbiA2SvhK8WXZ_WOFRz1bXyOprBLhokRgz7SrprPqmw2h0zZ8vnOV_Oiw-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0/4] futex: get_user_pages_fast() for shared futexes
Date: Tue, 30 Sep 2008 17:21:51 +1000
User-Agent: KMail/1.9.5
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
References: <20080926173219.885155151@twins.programming.kicks-ass.net> <20080927161712.GA1525@elte.hu>
In-Reply-To: <20080927161712.GA1525@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809301721.52148.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 28 September 2008 02:17, Ingo Molnar wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > Since get_user_pages_fast() made it in, I thought to give this another
> > try. Lightly tested by disabling the private futexes and running some
> > java proglets.
>
> hm, very interesting. Since this is an important futex usecase i started
> testing it in tip/core/futexes:
>
>  cd33272: futex: cleanup fshared
>  a135356: futex: use fast_gup()
>  39ce77b: futex: reduce mmap_sem usage
>  0d7a336: futex: rely on get_user_pages() for shared futexes
>
> Nick, it would be nice to get an Acked-by/Reviewed-by from you, before
> we think about whether it should go upstream.

Yeah, these all look pretty good. It's nice to get rid of mmap sem here.

Which reminds me, we need to put a might_lock mmap_sem into
get_user_pages_fast...

But these patches look good to me (last time we discussed them I thought
there was a race with page truncate, but it looks like you've closed that
by holding page lock over the whole operation...)

Nice work, Peter.

BTW. what kinds of things use inter-process futexes as of now?
