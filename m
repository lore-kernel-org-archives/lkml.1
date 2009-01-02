Return-Path: <linux-kernel-owner+w=401wt.eu-S1756738AbZABBjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738AbZABBjx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 20:39:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751702AbZABBjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 20:39:44 -0500
Received: from wf-out-1314.google.com ([209.85.200.168]:29651 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbZABBjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 20:39:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Z72qygqWsjDtZibzTdLWlatbaRV666zM5Dm2CMZoG7hvIJOXuzkV2o/RqEjVaciDgw
         G1vcAArBC2ruGTGa16+C6zyoWMzJR2UN96rNSOhJRCX6ThYRdpB8azWPh9Arnk4ahz46
         y7dx9Uzi2KtbpOOC3H+hCzlY6Iwj9BKKc347A=
Subject: Re: compile time warnings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Tom Spink <tspink@gmail.com>
Cc: Jesper Juhl <jj@chaosbits.net>, Ingo Brueckl <ib@wupperonline.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <7b9198260901011735k42e9298tb1c5dc0e15285eb1@mail.gmail.com>
References: <495d3100@wupperonline.de>
	 <alpine.LNX.2.00.0901012312450.11772@swampdragon.chaosbits.net>
	 <7b9198260901011735k42e9298tb1c5dc0e15285eb1@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 01 Jan 2009 17:39:40 -0800
Message-Id: <1230860380.5500.1.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-02 at 01:35 +0000, Tom Spink wrote:
> 2009/1/1 Jesper Juhl <jj@chaosbits.net>:
> > On Thu, 1 Jan 2009, Ingo Brueckl wrote:
> [snip]
> 
> Hi,
> 
> > pgd_base is very much used...
> 
> It's probably something to do with:
> 
> # define permanent_kmaps_init(pgd_base)         do { } while (0)
> 
> Which is within the #else part of #if CONFIG_HIGHMEM.  So, if
> CONFIG_HIGHMEM is not set, permanent_kmaps_init gets wiped out, and
> therefore that warning will be issued.
> 
> Perhaps changing that to an empty inline would remove the warning?
> 

If it can be an inline, it should be, otherwise:

# define permanent_kmaps_init(pgd_base) do { (void)(pgd_base) } while (0)

would do the trick.

Harvey

