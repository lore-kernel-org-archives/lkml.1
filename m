Return-Path: <linux-kernel-owner+w=401wt.eu-S935518AbXHLRaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935518AbXHLRaA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 13:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936044AbXHLR3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 13:29:32 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:49988 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932223AbXHLR3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 13:29:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DszRJL7UTBxcH4e5bJCstt48nrNZjw96dk0GyEv+d6ygCm959TwbE4XwGOh19tW2RCcjFVfzV9gOK9+iFdF5Tx6w/dr3mwtNEBgR5e/nGHZ+PqV31aJGx1TitkKn71UWFFYMCqbP6UjAQQn+JhKFPmdPhApwJZcRyYPt7Hnixxg=
Message-ID: <625fc13d0708121029k13b180c7i9abacbdf4a0647f8@mail.gmail.com>
Date: Sun, 12 Aug 2007 12:29:22 -0500
From: "Josh Boyer" <jwboyer@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] [MTD] Fix CFI build error with meaningless nonfunctional .config
Cc: "David Woodhouse" <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20070812162417.GA15412@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070806161537.GA1269@elte.hu>
	 <1186717841.7282.104.camel@shinybook.infradead.org>
	 <20070810074140.GB28264@elte.hu>
	 <1186731902.3571.1.camel@shinybook.infradead.org>
	 <20070812162417.GA15412@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/12/07, Ingo Molnar <mingo@elte.hu> wrote:
>
> * David Woodhouse <dwmw2@infradead.org> wrote:
>
> > On Fri, 2007-08-10 at 09:41 +0200, Ingo Molnar wrote:
> > > looks quite quirky. Is there no Kconfig-space solution for this?
> >
> > I thought about that, but decided against it. We have altogether too
> > much munging of config options without the user's knowledge already; I
> > didn't want to make it worse.
>
> just found another one via randconfig, it fails with:
>
>  In file included from drivers/mtd/chips/map_rom.c:16:
>  include/linux/mtd/map.h:128:2: error: #error "No bus width supported. What's the point?"
>
> config attached below. Because it's so nice to be able to keep a
> randconfig build-test running overnight, i think this needs to be fixed
> too. (even if with just a runtime BUG())

Urgh.  Is there a way to tell Kconfig, "One or more of the below
options must be set if CONFIG_CFI_GEOMETRY is enabled?"

josh
