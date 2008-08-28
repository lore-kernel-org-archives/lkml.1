Return-Path: <linux-kernel-owner+w=401wt.eu-S1756595AbYH1Acr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595AbYH1Acr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 20:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754418AbYH1Acj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 20:32:39 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:26760 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754049AbYH1Aci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 20:32:38 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=4XhaZ8GnmUGj5dZ82+XF1IliMo16he4JbCvnY51W8jzNVgJWkvWC7rI8Yq6iYUd7/p10IITC+VPjiQ65rW+W7wHxVuJOsUKNqTsn34JpR/Ga5q9cy9aXgTkjTc2OBwYDRHXsKboo90Br9hD0DiTW/ykzXhXS2Pco7gHtO26bki8=  ;
X-YMail-OSG: 7FqErjUVM1nbAKLgXfFEfD.SnsJnvRw4lNvP5E0nqsIelzQ.rwOtFVhJxtF9tSsQO5HXf2mZEIVnWdr13wJwMKhlx3lmwPjF4MAydnyr53sSMWbZ6pgiu2nbENc1GBq5UkE-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: Definition of x86 _PAGE_SPECIAL and sharing _PAGE_UNUSED1
Date: Thu, 28 Aug 2008 10:32:30 +1000
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, Hugh Dickens <hugh@veritas.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>
References: <48B5A4B0.9050308@goop.org>
In-Reply-To: <48B5A4B0.9050308@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808281032.30594.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 August 2008 05:02, Jeremy Fitzhardinge wrote:
> _PAGE_SPECIAL is overloading _PAGE_UNUSED1.  Does it really leave
> _PAGE_UNUSED1 available for other uses, or does it become an exclusive
> user of that flag.  Under what circumstances can they be shared?
>
> arch/x86/mm/pageattr-test.c is now using _PAGE_UNUSED1 as the flag used
> to make sure that huge pages are shattered properly (previously it used
> _PAGE_GLOBAL).  Is that going to clash with _PAGE_SPECIAL?

Ah... pity it was hidden away there and not put into the include file.


> In other words, should we drop _PAGE_UNUSED1 altogether, or at least
> define how the its different users can coexist?

I don't feel strongly about it. But you should put your definition in
pgtable.h (and possibly explain how it coexists with _SPECIAL).


> Am I right in supposing that _PAGE_SPECIAL can only be set on user pages?

Yes.


> (Also, "SPECIAL" is awfully generic.  Was there really no more
> descriptive name for this?)

I thought it was about on par with its counterpart, which is "normal".
Either way, I don't think a casual reader would get an adequate idea
of how it works in one word. normal ~= refcounted, special ~= !refcounted
I guess, but it is slightly more than that and besides, normal was there
first, and I think Linus coined it... if you can convince him to change
it then you have my blessing to change special into whatever you want.
