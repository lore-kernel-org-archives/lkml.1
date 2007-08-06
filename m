Return-Path: <linux-kernel-owner+w=401wt.eu-S1762873AbXHFJci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762873AbXHFJci (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 05:32:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760099AbXHFJcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 05:32:31 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:41558 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756849AbXHFJca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 05:32:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qSRNm3M5zTauqvMq9i66dx8HS0vfqxc3B1iDatAOkd6BKaslc8omdWcixYlVjeH1hojw7aXvBE7yAuXHdaSffqd9O27cFUf5YJFRX3f/+f5lbDplFjZPRpA9wZV7VDUFbR03QVfw5XK9CGW/GYVgRJYvqkmaQTyMz1s7a3qF4zs=
Message-ID: <a8e1da0708060232i4e239406p3ee73b3a4b24d108@mail.gmail.com>
Date: Mon, 6 Aug 2007 09:32:30 +0000
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Wim Van Sebroeck" <wim@iguana.be>
Subject: Re: eurotechwdt will cause reboot
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20070803062436.GA2652@infomag.infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a8e1da0707312003s6000b02s95c90b5971dbbd51@mail.gmail.com>
	 <20070801055845.GA2648@infomag.infomag.iguana.be>
	 <a8e1da0707312322g4559a546xc357505b591f9e65@mail.gmail.com>
	 <a8e1da0708021853y1eab0ee1v859ffdb9b35762a2@mail.gmail.com>
	 <20070803062436.GA2652@infomag.infomag.iguana.be>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>On 8/3/07, Wim Van Sebroeck <wim@iguana.be> wrote:
> Hi Dave,
>
> > Hi,
> > News: 2.6.23-rc1-mm1 will reboot with eurotechwdt, but 2.6.23-rc1-mm2
> > will not. do you need the config files?
> >
> > I will concentrate on this problem as well. Any hints how to debug?
>
> Yes: make a diff file between the two versions and see what has changed.
> If something changed on the eurotechwdt file then that is probably the
> answer you are looking for.  Else it will mean that your problem is fixed
> by other code and then we will have to find out which code did this.
>
> I was reading the datasheet to see how the driver worked. But I think
> we want to concentrate now first on what the difference is between the
> -mm1 and -mm2. Luckily something fixed allready your problem. Now it would
> be usefull to know what that was.

Yes, I think I get the reason.

The -mm1 kernel/irq/manage.c send a fake irq via handler in
request_irq function. -mm2 surround it with  #ifdef CONFIG_DEBUG_SHIRQ
/ #endif.

Regards
dave
