Return-Path: <linux-kernel-owner+w=401wt.eu-S1752071AbZHKLzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071AbZHKLzs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 07:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbZHKLzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 07:55:46 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:41228 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbZHKLzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 07:55:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PyMv7XwQIqWzcRNYzEQpAE1t+uZp826xuNPHJJqmG2lkgaZjQXGJU2TBmsR2w3Jppj
         dvk063G4zaW5F367VSLfKtqrGppfVzGp3OPApJFOHb8LTVJ+zJDALZCeZlVVMCjiKODw
         /AYLO20IYhd4EjiQVhDobTrMruLmFXjd+SXPU=
MIME-Version: 1.0
In-Reply-To: <4A7F31F6.9000706@gmail.com>
References: <4A7D961A.1020303@gmail.com> <4A7F31F6.9000706@gmail.com>
Date: Tue, 11 Aug 2009 10:54:03 +0200
Message-ID: <25e057c00908110154g48241b85td089e6726109b581@mail.gmail.com>
Subject: Re: [PATCH] applicom: Prevent unsigned wrap in ac_interrupt()
From: roel kluin <roel.kluin@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> unsigned i wraps if this occurs in the first iteration.
>
> Could you elaborate? I don't quite understand the point.

`i' is unsigned. The last test in the loop is:

if(readb(apbs[i].RamIO + RAM_IT_TO_PC)) {
        /* There's another int waiting on this card */
        spin_unlock(&apbs[i].mutex);
        i--;
} else {
        spin_unlock(&apbs[i].mutex);
}

In the first iteration `i' is 0, so if this condition evaluates to true
then `i' becomes 0xffffffff (since it's unsigned), the for loop test
fails and the i++ never occurs.

>> Or do we know this can't happen?
>
> You mean the i--? It's followed by i++ in the for loop 3rd expression. Or?

No, I meant: do we know the test can't evaluate to true in the first iteration?

Thanks,

Roel
