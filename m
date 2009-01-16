Return-Path: <linux-kernel-owner+w=401wt.eu-S1758927AbZAPEDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758927AbZAPEDy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 23:03:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755011AbZAPEDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 23:03:42 -0500
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:25932 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754655AbZAPEDl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 23:03:41 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Jm052ERhyuT2NTo9LV6c9opvhGFVTMyjqamaRQyPXMfDWQQiSzPyJiDFd26SqVvCeah4dNRERVqm4TlWtmqusZndTu6+4rpIqFBDgnDAzg/Mkm+Avluv5uAeoLVaKre3TEoempYpGChhGeYyrnOj5DRJSNu5kO30Ps5rYRQgwp4=  ;
X-YMail-OSG: wVYhwYUVM1nOOqOmQorDPGmoHDwwLeAAJbzE9HdKgNj5wB8PisDe05EaZwj43laLkyqPUXc6t8EMDdxOOpze.9aiHhzTUqm3i3E1wZi3lFEYRE9EjVg9p4esR5j7xLslIgktsH1ZCGd4eKYfCrIgOmR2LI8aXv5F1OD9adcts0nCI3rLL3IHKYbSGfH0w9.IrPVTHM_QZZUz6lWsw1q96v.GNg--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Mainline kernel OLTP performance update
Date: Fri, 16 Jan 2009 15:03:12 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: matthew@wil.cx, matthew.r.wilcox@intel.com, chinang.ma@intel.com,
       linux-kernel@vger.kernel.org, sharad.c.tripathi@intel.com,
       arjan@linux.intel.com, andi.kleen@intel.com, suresh.b.siddha@intel.com,
       harita.chilukuri@intel.com, douglas.w.styner@intel.com,
       peter.xihong.wang@intel.com, hubert.nueckel@intel.com,
       chris.mason@oracle.com, srostedt@redhat.com, linux-scsi@vger.kernel.org,
       andrew.vasquez@qlogic.com, anirban.chakraborty@qlogic.com
References: <BC02C49EEB98354DBA7F5DD76F2A9E800317003CB0@azsmsx501.amr.corp.intel.com> <200901151824.38658.nickpiggin@yahoo.com.au> <20090115162735.99277cc9.akpm@linux-foundation.org>
In-Reply-To: <20090115162735.99277cc9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <200901161503.13730.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 January 2009 11:27:35 Andrew Morton wrote:
> On Thu, 15 Jan 2009 18:24:36 +1100
>
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > Given that SLAB and SLUB are fairly mature, I wonder what you'd think of
> > taking SLQB into -mm and making it the default there for a while, to see
> > if anybody reports a problem?
>
> Nobody would test it in interesting ways.
>
> We'd get more testing in linux-next, but still not enough, and not of
> the right type.

It would be better than nothing, for SLQB, I guess.


> It would be better to just make the desision, merge it and forge ahead.
>
> Me, I'd be 100% behind the idea if it had a credible prospect of a net
> reduction in the number of slab allocator implementations.

>From the data we have so far, I think SLQB is a "credible prospect" to
replace SLUB and SLAB. But then again, apparently SLUB was a credible
prospect to replace SLAB when it was merged.

Unfortunately I can't honestly say that some serious regression will not
be discovered in SLQB that cannot be fixed. I guess that's never stopped
us merging other rewrites before, though.

I would like to see SLQB merged in mainline, made default, and wait for
some number releases. Then we take what we know, and try to make an
informed decision about the best one to take. I guess that is problematic
in that the rest of the kernel is moving underneath us. Do you have
another idea?


> I guess the naming convention will limit us to 26 of them.  Fortunate
> indeed that the kernel isn't written in cyrillic!

I could have called it SL4B. 4 would be somehow fitting...

