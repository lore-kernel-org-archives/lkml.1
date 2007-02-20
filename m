Return-Path: <linux-kernel-owner+w=401wt.eu-S932800AbXBTGLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932800AbXBTGLW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 01:11:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932801AbXBTGLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 01:11:22 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:60918 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932800AbXBTGLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 01:11:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mzRX7kOw8rJEner6jJG9YwtrktZmDSFvcNd7NJX5OqqcisGJuBjdFf5PO4hgu8/mHqT3NghHi5bjvAmT9NqoSN4BWp1jlos37mcJv6GydEhJlL5LCEMdEXwJjPK2k1RLqoTFQvtWwPt15ByNw/8Tk3k1fnBU6axQet5LBJTD7/c=
Message-ID: <45a44e480702192211i78b8f4b1lecb3dfc284fb9eea@mail.gmail.com>
Date: Tue, 20 Feb 2007 01:11:19 -0500
From: "Jaya Kumar" <jayakumar.lkml@gmail.com>
To: "Paul Mundt" <lethal@linux-sh.org>,
       "Jaya Kumar" <jayakumar.lkml@gmail.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, jsimmons@infradead.org,
       Geert.Uytterhoeven@sonycom.com
Subject: Re: [PATCH 2.6.20 1/1] fbdev,mm: hecuba/E-Ink fbdev driver
In-Reply-To: <20070220043848.GA4092@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070217104215.GB25512@localhost> <1171715652.5186.7.camel@lappy>
	 <45a44e480702170525n9a15fafpb370cb93f1c1fcba@mail.gmail.com>
	 <20070217135922.GA15373@linux-sh.org>
	 <45a44e480702180331t7e76c396j1a9861f689d4186b@mail.gmail.com>
	 <20070218235741.GA22298@linux-sh.org>
	 <45a44e480702192013s7d49d05ai31e576f0448a485e@mail.gmail.com>
	 <20070220043848.GA4092@linux-sh.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/19/07, Paul Mundt <lethal@linux-sh.org> wrote:
> On Mon, Feb 19, 2007 at 11:13:04PM -0500, Jaya Kumar wrote:
> >
> > Ok. Here's what I'm thinking for abstracting this:
> >
> > fbdev drivers would setup fb_mmap with their own_mmap as usual. In
> > own_mmap, they would do what they normally do and setup a vm_ops. They
> > are free to have their own nopage handler but would set the
> > page_mkwrite handler to be fbdev_deferred_io_mkwrite().
>
> The vast majority of drivers do not implement ->fb_mmap(), and with
> proper abstraction, this should be something that's possible as a direct
> alternative to drivers/video/fbmem.c:fb_mmap() for the people that want
> it. Of course it's just as easy to do something like the sbuslib.c route
> and then have drivers set their ->fb_mmap() from that too.
>

I was thinking about having that fb_mmap replacement too. But then I
got worried because that generic implementation of nopage/etc would
need to handle whether the driver's fb memory was vmalloced, kmalloced
or a mixture if some do that. So I figured let's aim low and just pull
in the core part that does the setup and page tracking stuff. I hope
that's okay.

> That works for me, though I'd prefer for struct page_list to be done with
> a scatterlist, then it's trivial to setup from the workqueue context
> without having to shuffle things around.
>

Ok. Will check out when implementing.

Thanks,
jaya
