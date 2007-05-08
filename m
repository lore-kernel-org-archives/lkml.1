Return-Path: <linux-kernel-owner+w=401wt.eu-S966918AbXEHMV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966918AbXEHMV7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 08:21:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933865AbXEHMV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 08:21:58 -0400
Received: from wx-out-0506.google.com ([66.249.82.233]:65266 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932458AbXEHMV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 08:21:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=RHk88CZgX99MUIxZGvn0FzEH9waOLHXGY8GIsMK4oUlOnLp2+1iu5gqR/mNUHsSuGJXqHAOoQUBEWPj+keZG2+7++xoZdR9tMuR7E1xluXzhA9IUV8SnqNjTV8/AqxQ6EeVA/J5b01BreJg2ZmKmKldV4JYEPCNBzGL6CzuG/iI=
Message-ID: <84144f020705080521k6d75d9f8m33e25585735e4f7e@mail.gmail.com>
Date: Tue, 8 May 2007 15:21:55 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Michael Tokarev" <mjt@tls.msk.ru>
Subject: Re: [KJ PATCH] Replacing memset(<addr>,0,PAGE_SIZE) with clear_page() in kernel/kexec.c
Cc: "Shani Moideen" <shani.moideen@wipro.com>, ebiederm@xmission.com,
       linux-kernel@vger.kernel.org, kernel-janitors@lists.osdl.org
In-Reply-To: <46405AB6.6040901@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1178621444.3598.15.camel@shani-win>
	 <46405AB6.6040901@msgid.tls.msk.ru>
X-Google-Sender-Auth: 14907e0dfff5d2c1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Shani Moideen wrote:
> >                 ptr = kmap(page);
> > -               memset(ptr, 0, PAGE_SIZE);
> > +               clear_page(ptr);

On 5/8/07, Michael Tokarev <mjt@tls.msk.ru> wrote:
> I wonder if it's worth to invent kzmap() or something like that... ;)

I am counting 59 kmap + memset pairs in the kernel, so perhaps it is
worth it to reduce kernel text size.
