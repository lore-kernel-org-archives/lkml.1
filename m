Return-Path: <linux-kernel-owner+w=401wt.eu-S1760310AbXK1K7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760310AbXK1K7a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 05:59:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758292AbXK1K7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 05:59:18 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:10914 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755955AbXK1K7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 05:59:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ov9O9UR6/NTYkuwA/eSsmRXzQ4CE6nM6pfEqzJjCk8J9lYPGVLtAdTtlZZ5B1owJ6SN+lI5iok5aIvVDpSjFH440AHYXsl7UkWaNwGRBdqeBvvJicGP+6IU+7bISZjhso8XdhoA7nFqZTrYpAKRYfm9x2X9/Yy9eLSqga3IVIlA=
Message-ID: <aa79d98a0711280259o6cc6fb12mf020c4a986d84ca6@mail.gmail.com>
Date: Wed, 28 Nov 2007 13:59:16 +0300
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: michael@ellerman.id.au
Subject: Re: [PATCH] PPC: CELLEB - fix potential NULL pointer dereference
Cc: PPCML <linuxppc-dev@ozlabs.org>, "Olof Johansson" <olof@lixom.net>,
       "Paul Mackerras" <paulus@samba.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Ishizaki Kou" <kou.ishizaki@toshiba.co.jp>
In-Reply-To: <aa79d98a0711280253x3d1d28d6qa0cee0b731e807fe@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <aa79d98a0711252346m583b652bocf72e11077da352e@mail.gmail.com>
	 <1196243333.2109.2.camel@concordia>
	 <aa79d98a0711280253x3d1d28d6qa0cee0b731e807fe@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/07, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On 11/28/07, Michael Ellerman <michael@ellerman.id.au> wrote:
> > On Mon, 2007-11-26 at 10:46 +0300, Cyrill Gorcunov wrote:
> > > This patch adds checking for NULL value returned to prevent possible
> > > NULL pointer dereference.
> > > Also two unneeded 'return' are removed.
> > >
> > > Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> > > ---
> > > Any comments are welcome.
> >
> > I guess it's good to be paranoid, but this is a little verbose:
> >
> >        wi0 = of_get_property(node, "device-id", NULL);
> > +       if (unlikely((!wi0))) {
> > +               printk(KERN_ERR "PCI: device-id not found.\n");
> > +               goto error;
> > +       }
> >        wi1 = of_get_property(node, "vendor-id", NULL);
> > +       if (unlikely((!wi1))) {
> > +               printk(KERN_ERR "PCI: vendor-id not found.\n");
> > +               goto error;
> > +       }
> >        wi2 = of_get_property(node, "class-code", NULL);
> > +       if (unlikely((!wi2))) {
> > +               printk(KERN_ERR "PCI: class-code not found.\n");
> > +               goto error;
> > +       }
> >        wi3 = of_get_property(node, "revision-id", NULL);
> > +       if (unlikely((!wi3))) {
> > +               printk(KERN_ERR "PCI: revision-id not found.\n");
> > +               goto error;
> > +       }
> >
> > Perhaps instead:
> >
> >        wi0 = of_get_property(node, "device-id", NULL);
> >        wi1 = of_get_property(node, "vendor-id", NULL);
> >        wi2 = of_get_property(node, "class-code", NULL);
> >        wi3 = of_get_property(node, "revision-id", NULL);
> >
> >       if (!wi0 || !wi1 || !wi2 || !wi3) {
> >               printk(KERN_ERR "PCI: Missing device tree properties.\n");
> >               goto error;
> >       }
>
> Hi Michael, yes that is much better (actually I was doubt about what form of
> which the checking style to use - your form is much compact but mine does
> show where *exactly* the problem appeared). So 'case that is the fake driver
> your form is preferred ;) Ishizaki, could you use Michael's part then?
>
> >
> >
> > cheers
> >
> > --
> > Michael Ellerman
> > OzLabs, IBM Australia Development Lab
> >
> > wwweb: http://michael.ellerman.id.au
> > phone: +61 2 6212 1183 (tie line 70 21183)
> >
> > We do not inherit the earth from our ancestors,
> > we borrow it from our children. - S.M.A.R.T Person
> >
> >
>
> Cyrill
>
Ishizaki I can update the patch if you needed. Should I?

Cyrill
