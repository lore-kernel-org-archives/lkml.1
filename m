Return-Path: <linux-kernel-owner+w=401wt.eu-S1753315AbYAXBgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315AbYAXBgT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 20:36:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751113AbYAXBgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 20:36:10 -0500
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:29661 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750994AbYAXBgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 20:36:09 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=fedI2CuaPeU3M9G0W4y+5/mmQwxhr0+jq5ZhMpRGaXvwHND9tkTyCXrpY4nv+iP4LmOjb0hMtdH/9Br26afJHryFNnlkYLYgkzlSLFgiqzvDvA2tvI3R94oFJ0BbTo2BBPjVtkGHNF3hzpk/h7LVU1teygJ786FxFwQbVbDN74I=  ;
X-YMail-OSG: tKOKhvkVM1msFNow6v_1wD2kdm7UAApQslcdF4GMaYoDd.Tbfod6qqUmGANgYO8HRzw51mE_IA--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH -v8 3/4] Enable the MS_ASYNC functionality in sys_msync()
Date: Thu, 24 Jan 2008 12:36:00 +1100
User-Agent: KMail/1.9.5
Cc: Anton Salikhmetov <salikhmetov@gmail.com>, linux-mm@kvack.org,
       jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       staubach@redhat.com, jesper.juhl@gmail.com, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, protasnb@gmail.com, miklos@szeredi.hu,
       r.e.wolff@bitwizard.nl, hidave.darkstar@gmail.com, hch@infradead.org
References: <12010440803930-git-send-email-salikhmetov@gmail.com> <1201044083504-git-send-email-salikhmetov@gmail.com> <alpine.LFD.1.00.0801230836250.1741@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0801230836250.1741@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801241236.01114.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 January 2008 04:05, Linus Torvalds wrote:
> On Wed, 23 Jan 2008, Anton Salikhmetov wrote:
> > +
> > +		if (pte_dirty(*pte) && pte_write(*pte)) {
>
> Not correct.
>
> You still need to check "pte_present()" before you can test any other
> bits. For a non-present pte, none of the other bits are defined, and for
> all we know there might be architectures out there that require them to
> be non-dirty.
>
> As it is, you just possibly randomly corrupted the pte.
>
> Yeah, on all architectures I know of, it the pte is clear, neither of
> those tests will trigger, so it just happens to work, but it's still
> wrong.

Probably it can fail for !present nonlinear mappings on many
architectures.

