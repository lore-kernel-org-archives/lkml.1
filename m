Return-Path: <linux-kernel-owner+w=401wt.eu-S1759864AbYC0KJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759864AbYC0KJA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 06:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757008AbYC0KIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 06:08:42 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:35560 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756640AbYC0KIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 06:08:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IG85KqOoX/JSpa9AFhnW8QK50j/JUA+kYJoI6wWCL/5Y1d7c57YGHD+cH2oWF34cpz9g2hHWTr4Xg6TA3jKrc5QYNYY+gaP+Y21YKKhTBBsH0rvpT3wubObhuM8I2NL5ihZAXZpk1A32th3TCIkTYN6Y4OMoheg0SMD2aaB0gg4=
Message-ID: <bc64b4640803270308w6dc0723dr29e0ce5f20088d6d@mail.gmail.com>
Date: Thu, 27 Mar 2008 13:08:37 +0300
From: Dmitry <dbaryshkov@gmail.com>
To: "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>
Subject: Re: [PATCH 1/3] Clocklib: add generic framework for managing clocks.
Cc: "Russell King" <rmk+lkml@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, hskinnemoen@atmel.com, lethal@linux-sh.org,
       tony@atomide.com, paul@pwsan.com
In-Reply-To: <20080327105323.28a369fd@hskinnemo-gx620.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080326154913.GA15326@doriath.ww600.siemens.net>
	 <20080326155203.GA15405@doriath.ww600.siemens.net>
	 <20080326170441.795fb928@hskinnemo-gx620.norway.atmel.com>
	 <bc64b4640803260952s58ad0645ve11766fdfa45e785@mail.gmail.com>
	 <20080327100623.34d92c84@hskinnemo-gx620.norway.atmel.com>
	 <20080327091810.GA32396@flint.arm.linux.org.uk>
	 <20080327102648.225d6b4f@hskinnemo-gx620.norway.atmel.com>
	 <20080327093301.GB32396@flint.arm.linux.org.uk>
	 <20080327105323.28a369fd@hskinnemo-gx620.norway.atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2008/3/27, Haavard Skinnemoen <haavard.skinnemoen@atmel.com>:
> [domen.puncer@telargo.com keeps bouncing on me, removed from Cc]
>
>  On Thu, 27 Mar 2008 09:33:01 +0000
>
> Russell King <rmk+lkml@arm.linux.org.uk> wrote:
>
>
> > On Thu, Mar 27, 2008 at 10:26:48AM +0100, Haavard Skinnemoen wrote:
>  > > You can extend the struct, put the rate there and use the same
>  > > getrate() function for all the clocks that need to keep track of the
>  > > current rate this way.
>  >
>  > Well, if you're really concerned about size, you could do what I did with
>  > PXA and introduce a struct clk_ops to contain all the constant function
>  > pointers, rather than mashing the function pointers together - which
>  > saves far more than trying to combine them.
>
>
> I don't see what this has to do with the paragraph you quoted, but
>  yeah, good point. I don't think it should be used as an excuse for
>  filling up struct clk with platform-specific crap, however.
>
>  So how about something like this?
>
>  struct clk_ops {
>         struct module   *owner;
>
>
>         int (*can_get)  (struct clk *, struct device *);
>         int (*set_parent) (struct clk *, struct clk *);
>
>         int (*enable)   (struct clk *);
>         void (*disable) (struct clk *);
>
>         unsigned long (*getrate) (struct clk*);
>
>         int (*setrate)  (struct clk *, unsigned long);
>
>         long (*roundrate) (struct clk *, unsigned long);
>
> };
>
>
>  struct clk {
>         struct list_head node;
>         struct clk      *parent;
>
>         const char      *name;
>
>         int             users;
>
>         const struct clk_ops *ops;
>  };

I like this idea! This would also allow to cleanup the references code, etc.
Also after I saw such refactored struct clk, I thought that it looks
nearly like kobject. Maybe we should switch to the kobject-based
structs? What do you think?

-- 
With best wishes
Dmitry
