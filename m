Return-Path: <linux-kernel-owner+w=401wt.eu-S933411AbXLMVh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933411AbXLMVh3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 16:37:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759381AbXLMVhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 16:37:07 -0500
Received: from wr-out-0506.google.com ([64.233.184.230]:16344 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765587AbXLMVhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 16:37:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MQ8WXCB+a8L7zJKGBIZY3XLwPQpDw2OY8xWVFSGdUU8vuH4Z0epOGlknJt4mVTrwlcosqcJ00/zFGNThTrR6qX/UOXC0kSiywzM9H/IjJf2RyZqWrmfkuOAGfUSHaWa8IHTBJhGlMpERYavo5VSvjrofrD57yByz0WHYn6XjF20=
Message-ID: <7b9198260712131337j6249c980q55306b676b361776@mail.gmail.com>
Date: Thu, 13 Dec 2007 21:37:02 +0000
From: "Tom Spink" <tspink@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] avoid ifdefs in desc.h, getting rid of pack_ldt and pack_tss
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Glauber de Oliveira Costa" <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       glommer@gmail.com, tglx@linutronix.de, ehabkost@redhat.com,
       jeremy@goop.org, avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       ak@suse.de, chrisw@sous-sol.org, rostedt@goodmis.org, zach@vmware.com,
       roland@redhat.com
In-Reply-To: <4761A385.1080301@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <11975561713425-git-send-email-gcosta@redhat.com>
	 <20071213202800.GD25130@elte.hu> <20071213205838.GA9649@elte.hu>
	 <20071213212221.GA16747@elte.hu> <4761A385.1080301@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 13, 2007 9:26 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Ingo Molnar wrote:
> >
> >> could we _please_ use basic tools as vmlinux size comparison and
> >> objcompare when unifying, to make sure it's a 100% identity
> >> conversion?
> >
> > case in point, the patch claims:
> >
> >>> No functional change is made.
> >
> > but vmlinux before/after size comparison shows:
> >
> >     text    data     bss     dec     hex filename
> >  8802894 1224910 3526656 13554460         ced31c vmlinux.before
> >  8803042 1224910 3526656 13554608         ced3b0 vmlinux.after
> >
>
> Well, "no functional changes" is not quite the same thing as "no object
> code changes".
>
>         -hpa
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

I'm by far no expert on the subject, but after a quick eyes-debug,
have you got the size and type parameters reversed here:

+       set_tssldt_descriptor(&tss, (unsigned long)addr,
               IO_BITMAP_OFFSET + IO_BITMAP_BYTES + sizeof(unsigned long) - 1,
               DESC_TSS);

Should DESC_TSS be the parameter before that big size equation?

-- 
Regards,
Tom Spink
University of Edinburgh
