Return-Path: <linux-kernel-owner+w=401wt.eu-S1755148AbXHBIVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148AbXHBIVE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 04:21:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbXHBIUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 04:20:51 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:34298 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbXHBIUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 04:20:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Ph0gaA1/YJh1sko4tDfIAAaL9au8hed4gbW/ZVIhDS67/wyATI7bs6lWTrzxxVszuske6PnM4nLTizg/A0R2tFhHPc6qdrS/SxT/TdQ9TPlvf7XNut6jxkVis2Y4wXyaIQTwy+xKk4PGFsrYY+29D7pRllw4jLfgv7+E883H38g=
Message-ID: <9a8748490708020120w4bbfe6d1n6f6986aec507316@mail.gmail.com>
Date: Thu, 2 Aug 2007 10:20:47 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix two potential mem leaks in MPT Fusion (mpt_attach())
Cc: "Eric Moore" <Eric.Moore@lsi.com>, DL-MPTFusionLinux@lsi.com,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       support@lsi.com, mpt_linux_developer@lsi.com,
       linux-scsi@vger.kernel.org,
       "James Bottomley" <James.Bottomley@steeleye.com>
In-Reply-To: <20070801172653.1fd44e99.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200708020155.33690.jesper.juhl@gmail.com>
	 <20070801172653.1fd44e99.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 2 Aug 2007 01:55:33 +0200
> Jesper Juhl <jesper.juhl@gmail.com> wrote:
>
[snip]
> > +++ b/drivers/message/fusion/mptbase.c
> > @@ -1393,18 +1393,18 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
> >       struct proc_dir_entry *dent, *ent;
> >  #endif
> >
> > +     if (mpt_debug_level)
> > +             printk(KERN_INFO MYNAM ": mpt_debug_level=%xh\n", mpt_debug_level);
> > +
> > +     if (pci_enable_device(pdev))
> > +             return r;
> > +
> >       ioc = kzalloc(sizeof(MPT_ADAPTER), GFP_ATOMIC);
>
> Why on earth is that using GFP_ATOMIC?  This function later goes on to
> create procfs files and such things.
>
Dunno. But you are right, that does seem a bit odd, but I assumed
there was a reason for it.

>
> y'know, we could have a debug option which will spit warnings if someone
> does a !__GFP_WAIT allocation while !in_atomic() (only works if
> CONFIG_PREEMPT).
>
> But please, make it depend on !CONFIG_AKPM.  I shudder to think about all
> the stuff it would pick up.
>

I can try to cook up something like that tonight...

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
