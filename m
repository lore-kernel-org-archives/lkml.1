Return-Path: <linux-kernel-owner+w=401wt.eu-S1760840AbXK2DXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760840AbXK2DXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 22:23:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756842AbXK2DXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 22:23:08 -0500
Received: from imx12.toshiba.co.jp ([61.202.160.132]:64797 "EHLO
	imx12.toshiba.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218AbXK2DXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 22:23:06 -0500
X-Greylist: delayed 66584 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Nov 2007 22:23:06 EST
Date: Thu, 29 Nov 2007 12:22:45 +0900 (JST)
Message-Id: <20071129.122245.-1300543769.kouish@swc.toshiba.co.jp>
To: gorcunov@gmail.com
Cc: michael@ellerman.id.au, olof@lixom.net, linuxppc-dev@ozlabs.org,
       paulus@samba.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PPC: CELLEB - fix potential NULL pointer dereference
In-Reply-To: <aa79d98a0711280259o6cc6fb12mf020c4a986d84ca6@mail.gmail.com>
From: Ishizaki Kou <kou.ishizaki@toshiba.co.jp>
X-Mailer: Mew version 4.2 on Emacs 21.3 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On 11/28/07, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> > On 11/28/07, Michael Ellerman <michael@ellerman.id.au> wrote:
> > > On Mon, 2007-11-26 at 10:46 +0300, Cyrill Gorcunov wrote:
> > > > This patch adds checking for NULL value returned to prevent possible
> > > > NULL pointer dereference.
> > > > Also two unneeded 'return' are removed.
> > > >
> > > > Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> > > > ---
> > > > Any comments are welcome.
> > >
> > > I guess it's good to be paranoid, but this is a little verbose:
> > >
> > >        wi0 = of_get_property(node, "device-id", NULL);
> > > +       if (unlikely((!wi0))) {
> > > +               printk(KERN_ERR "PCI: device-id not found.\n");
> > > +               goto error;
> > > +       }
> > >        wi1 = of_get_property(node, "vendor-id", NULL);
> > > +       if (unlikely((!wi1))) {
> > > +               printk(KERN_ERR "PCI: vendor-id not found.\n");
> > > +               goto error;
> > > +       }
> > >        wi2 = of_get_property(node, "class-code", NULL);
> > > +       if (unlikely((!wi2))) {
> > > +               printk(KERN_ERR "PCI: class-code not found.\n");
> > > +               goto error;
> > > +       }
> > >        wi3 = of_get_property(node, "revision-id", NULL);
> > > +       if (unlikely((!wi3))) {
> > > +               printk(KERN_ERR "PCI: revision-id not found.\n");
> > > +               goto error;
> > > +       }
> > >
> > > Perhaps instead:
> > >
> > >        wi0 = of_get_property(node, "device-id", NULL);
> > >        wi1 = of_get_property(node, "vendor-id", NULL);
> > >        wi2 = of_get_property(node, "class-code", NULL);
> > >        wi3 = of_get_property(node, "revision-id", NULL);
> > >
> > >       if (!wi0 || !wi1 || !wi2 || !wi3) {
> > >               printk(KERN_ERR "PCI: Missing device tree properties.\n");
> > >               goto error;
> > >       }
> >
> > Hi Michael, yes that is much better (actually I was doubt about what form of
> > which the checking style to use - your form is much compact but mine does
> > show where *exactly* the problem appeared). So 'case that is the fake driver
> > your form is preferred ;) Ishizaki, could you use Michael's part then?
> >
> > >
> > >
> > > cheers
> > >
> > > --
> > > Michael Ellerman
> > > OzLabs, IBM Australia Development Lab
> > >
> > > wwweb: http://michael.ellerman.id.au
> > > phone: +61 2 6212 1183 (tie line 70 21183)
> > >
> > > We do not inherit the earth from our ancestors,
> > > we borrow it from our children. - S.M.A.R.T Person
> > >
> > >
> >
> > Cyrill
> >
> Ishizaki I can update the patch if you needed. Should I?
> 
> Cyrill

There is no problem to use Michael's part, and I also prefer simple
one like this.

Cyrill, would you please update your patch?

Best regards,
Kou Ishizaki
