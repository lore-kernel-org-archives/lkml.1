Return-Path: <linux-kernel-owner+w=401wt.eu-S965722AbXG3Jf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965722AbXG3Jf4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 05:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938322AbXG3Jfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 05:35:46 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:35090 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935875AbXG3Jfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 05:35:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=CxMiquFfTe1WHOjASDJUXUWxwGMaDou6bHEaFRH6JUFNdwK8qBjK42X4ofVsHmnlwRnWx2iFgQwfu7d2ZEBWtMRnkbWtY5k3THfbOZusZeO+g/Ll86mG4pUYD6VMCXHcioiJqI4PaIE4c7s0i7bl5KEigQKNMVsrK2i2FIKH4KA=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Jan Kratochvil <jan.kratochvil@redhat.com>
Subject: Re: [BUG] i386 relocable kernel breakes /proc/kcore debugging
Date: Mon, 30 Jul 2007 12:32:01 +0300
User-Agent: KMail/1.9.4
Cc: Vivek Goyal <vgoyal@in.ibm.com>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
References: <200707280443.44048.maximlevitsky@gmail.com> <20070730080303.GA6071@in.ibm.com> <20070730084116.GA18263@host0.dyn.jankratochvil.net>
In-Reply-To: <20070730084116.GA18263@host0.dyn.jankratochvil.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707301232.01989.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 July 2007 11:41, Jan Kratochvil wrote:
> On Mon, 30 Jul 2007 10:03:03 +0200, Vivek Goyal wrote:
> > On Sat, Jul 28, 2007 at 04:43:43AM +0300, Maxim Levitsky wrote:
>
> ...
>
> > > gdb 'thinks' that all kernel symbols are below 0x80000000 , while they
> > > are at 0xC000....
> > >
> > > Turning CONFIG_RELOCATABLE off fixes that, so I assume that is the
> > > reason for that.
> >
> > This is a gdb issue. I had raised it in gdb mailing list some time back.
> >
> > http://sourceware.org/ml/gdb/2006-08/msg00137.html
>
> There was the patch post:
> 	http://sources.redhat.com/ml/gdb/2006-08/msg00182.html
>
> > What version of gdb you are using? I know it got fixed for gdb shipped
> > with RHEL5. I am not sure about what upstream version of gdb it got fixed
> > in.
>
> It did not make it to the upstream as the patch above is an imperfect one.
> It is fixed in RH gdb-6.5-5 upwards, therefore Fedora 6 + RHEL-5.
> 	http://cvs.fedora.redhat.com/viewcvs/*checkout*/devel/gdb/gdb-6.5-bz203661
>-emit-relocs.patch?root=core
>
>
> Regards,
> Jan

Hi,

I am using mandriva 2007 and gdb that come with it ( 6.3 I think)
I also compiled gdb 6.6, but the same issue persist.

Thanks for the info, and I will try to apply the above patch and see if helps,

Will it make into gdb?

By the way, I had another issue with /proc/kcore.
That enabling sparse memory model instead of flat causes /proc/kcore not to 
work at all. I traced that to a "FIXME" in sparcemem.

/* XXX: FIXME -- wli */
#define kern_addr_valid(kaddr)  (0)

Kconfig should contatin a warning for those who select sparcemem 
that /proc/kcore will be disabled.
or maybe this should be implemented (it is not easy since spacemem allows 
memory to be discontinous, and nobody wants to allow user to read reserved 
regions)

Except the above, /proc/kcore works fine, and it is very usefull.

Best regards,
	Maxim Levitsky

Best regards,
	Maxim Levitsky
