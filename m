Return-Path: <linux-kernel-owner+w=401wt.eu-S1422742AbXBARNJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422742AbXBARNJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 12:13:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422740AbXBARNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 12:13:09 -0500
Received: from wx-out-0506.google.com ([66.249.82.239]:22053 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422742AbXBARNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 12:13:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lXaycn5+XJYH5gnuUZvktGcFbxiRe1H10e6aTfJ5hfRlyh/mD2gFLwJnQzzBdebMohIMf6JvW5sdkiYxruZAyosDWHwZHNiunuupjj02fPq0G5wO0PfERvHp6nR33PYHzZzTv0+iF6hxnFy8tgm2uqN+MJmsbCXqHHBiJuc5vvY=
Message-ID: <653402b90702010913g3d91b190ud4faa2bcce3251b@mail.gmail.com>
Date: Thu, 1 Feb 2007 18:13:06 +0100
From: "Miguel Ojeda" <maxextreme@gmail.com>
To: "Daniel Walker" <dwalker@mvista.com>
Subject: Re: crash on CONFIG_CFAG12864B=y in 2.6.20-rc3-mm1
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
In-Reply-To: <1170342991.9781.189.camel@imap.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1168188931.26086.255.camel@imap.mvista.com>
	 <653402b90702010549v17e72765uc718c1ae79419003@mail.gmail.com>
	 <653402b90702010716i7c0ddf71xe6fa7866323f52f4@mail.gmail.com>
	 <1170342991.9781.189.camel@imap.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/1/07, Daniel Walker <dwalker@mvista.com> wrote:
> On Thu, 2007-02-01 at 16:16 +0100, Miguel Ojeda wrote:
> > The problem is easy:
> >
> > ks0108_init() prints the error message and exit with -EINVAL, so the
> > module isn't loaded properly.
> >
> > However, cfag12864b_init() is called, although ks0108 failed. It
> > returns 0 and after a while cfag12864b calls ks0108_writecontrol()
> > which dereferences the uninitialized pointer ks0108_parport:
> >
> > 	parport_write_control(ks0108_parport, byte ^ (bit(0) | bit(1) | bit(3)));
> >
> > Why is cfag12864b_init() called if ks0108 module didn't load properly?
> > Is that normal? If so, how a module should alarm other modules about
> > it failed loading?
>
> I don't know if this matters, but I had this driver built-in , and not a
> module ..
>
> Daniel
>
>

Well, I use the word "module" for both cases: When I modprobe
cfag12864b, if ks0108 fails, it doesn't get linked. So I thought the
same happen for built-in drivers (in other words, I didn't think
cfag12864b would be linked if ks0108 failed).

So I'm waiting until someone tell me what is the right way to avoid
drivers like cfag12864b been inited if their dependencies failed.

Anyway, thanks for discovering the bug (I wouldn't have discovered it
as my motherboard has parallel port ;).

Miguel

-- 
Miguel Ojeda
http://maxextreme.googlepages.com/index.htm
