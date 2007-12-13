Return-Path: <linux-kernel-owner+w=401wt.eu-S933468AbXLMXn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933468AbXLMXn2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 18:43:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755704AbXLMXnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 18:43:18 -0500
Received: from nz-out-0506.google.com ([64.233.162.235]:31740 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299AbXLMXnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 18:43:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pJv5USv7WBNmscs4NBY40p8okUmUISaopdeh+AKLgLCHev3CRL/LoEGHf3CEU3Mnh4DwZyJB7j1KHEHlQGBRZ+guE3Kso+UPa01UGE7R5tWA+13ckKdr9MtP3wrAp1GSueEp3bzjBK7CMgq7xo2US7d7dVJ2SX3hnsq/78x4VLE=
Message-ID: <b14f3e280712131543s5467be5cjf3df6049fb6dc645@mail.gmail.com>
Date: Thu, 13 Dec 2007 21:43:15 -0200
From: "Mauricio Mauad Menegaz Filho" <mmauad@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: Print taint info in more places.
Cc: "Dave Jones" <davej@redhat.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <p73y7byfb0h.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071213224927.GA18639@redhat.com>
	 <p73y7byfb0h.fsf@bingen.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2007/12/13, Andi Kleen <andi@firstfloor.org>:
> Dave Jones <davej@redhat.com> writes:
>
> >  #define WARN_ON(condition) ({                                                \
> >       int __ret_warn_on = !!(condition);                              \
> >       if (unlikely(__ret_warn_on)) {                                  \
> > -             printk("WARNING: at %s:%d %s()\n", __FILE__,            \
> > -                     __LINE__, __FUNCTION__);                        \
> > +             printk(KERN_ERR "WARNING: at %s:%d %s() (%s)\n",        \
> > +                      __FILE__, __LINE__, __FUNCTION__,              \
> > +                      print_tainted());                              \
> >               dump_stack();                                           \
>
> Have you checked how this affects code size? It might be worth it
> now to do a out of line helper.
>

Have you checked how does spotting a bug is worth the extra size
sometimes (almost all the time)?
