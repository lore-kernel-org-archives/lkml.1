Return-Path: <linux-kernel-owner+w=401wt.eu-S1757368AbYCXIYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368AbYCXIYU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 04:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbYCXIYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 04:24:08 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:35108 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889AbYCXIYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 04:24:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Gotu2oAHDJjV7KDVB/ILLPPL4NBu7Hkd30kAkPGsEWOZWqQ8CGJJH7VOaiX8tLELlhtXGDRkIuwidW5tYTBaNwxInwpdXAcA5c2AAwa0ESh96H/jmJ3235yfB787r4RUA9QI8LT1kX/dNAQI117JcK0Auf8WYvHQFSNtxv5wP88=
Message-ID: <38b2ab8a0803240124j61a78649v45533a551f2f7da9@mail.gmail.com>
Date: Mon, 24 Mar 2008 09:24:06 +0100
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Chris Snook" <csnook@redhat.com>
Subject: Re: Question about C language.
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <47E60702.30302@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0803210846p2f9b92adr951fe7fa0444de63@mail.gmail.com>
	 <47E60702.30302@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, Mar 23, 2008 at 8:30 AM, Chris Snook <csnook@redhat.com> wrote:
>  > I know it's a bit out of topic but this is something I need to clarify for
>  > writing a Linux driver... hope you don't mind.
>  >
>  > In my driver I have a global variable that controls a loop such as:
>  >
>  > int my_condition;
>  >
>  > void change_my_condition(int new)
>  > {
>  >     my_condition = new;
>  > }
>  >
>  > int foo(void)
>  > {
>  >     /* irqs are disabled */
>  >     my_condition = 1;
>  >     do {
>  >         ....
>  >         local_irq_enable();
>  >         cpu_sleep();
>  >         local_irq_disable();
>  >
>  >    } while (my_condition);
>  >
>  > }
>  >
>  > This variable is modified by an interrupt handler define in another file
>  > by using 'change_my_condition' function.
>  >
>  > By reading the ISO C99 specification, I _think_ that I needn't any
>  > kind of barrier
>  > or even use the volatile type qualifier for my_condition variable to make a true
>  > access to 'my_condition' in the controlling expression of the while, but I'm not
>  > sure.
>  >
>  > Coud anybody confirm ?
>  >
>  > Thanks,
>
>  Even volatile may be insufficient with some architecture/compiler
>  combinations.  You should use explicit barriers wherever you need them,
>  or Bad Things will happen.
>

Really ?

Could you give me some details please ?

As I said previously, I don't think I need any barriers here because this code
doesn't have any reordering issues and futhermore only one CPU will be up
at this time.

Actually the only issue I can see is about compiler aliases. I don't know if
in that case it could use an alias for 'my_condition'. Looking at the code, it
would be a bad idea but I can't find anything about this in the C specification.
The C spec talks about sequence points but I'm really confused when reading
that part...

Thanks
-- 
Francis
