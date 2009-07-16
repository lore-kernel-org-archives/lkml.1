Return-Path: <linux-kernel-owner+w=401wt.eu-S1756708AbZGPAOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708AbZGPAOP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 20:14:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754241AbZGPAOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 20:14:14 -0400
Received: from web50110.mail.re2.yahoo.com ([206.190.38.38]:43257 "HELO
	web50110.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753477AbZGPAOO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 20:14:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=Q6DGm1oPP1/nnmT94kyygF/CulzaOm9Drw1tQ8sGPlIwujep86ziCNkzhFq3qfPGl8+UUs3C7AVa4gHBEzqaNSmW+FQSgnJoqQNKGNmzchwqz6Yy3XCFhj/exNIanTWxbPerUHEXar9p2WvIc+conPWHXogVJJsdRBkJ1b/MiR0=;
Message-ID: <356572.69677.qm@web50110.mail.re2.yahoo.com>
X-YMail-OSG: O8mU9PoVM1mvCstCa_ojJK_escH6X5Yadqe77l3TX3zcEZH8hLC.H7HAX5yhpjhI4btmd6jEI1bbovoyN9vvmVnDkTW4bpqLLoUNHIAQJnziHC8bnzyKc8NNHmEJi2VmO7OvOzT.Ld7bX38jGiDko.N.yOzXWJ0fjW.fXDkTM3yNtYTzRwLURjdy7AJLugFlrHnBPNNPtwzA8pAi7iDyFvzWy.99y9QVgLWR_j3vmf.aX62_c6MHvE_G_xsNCRv_LExx29rnHq_yZjDbEy6DY8zmHQ3dEI_c5MEz4vG8z9HYMIcABgqrrdDjS.E33fa9V2iv2uAIY1VVDxt7lJ5z8vGXDVkWco4IITfiRA--
X-Mailer: YahooMailClassic/6.0.18 YahooMailWebService/0.7.338.1
Date: Wed, 15 Jul 2009 17:14:12 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: [PATCH 2/4] edac: mpc85xx add mpc83xx support
To: Andrew Morton <akpm@linux-foundation.org>
Cc: bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       "Ira W. Snyder" <iws@ovro.caltech.edu>,
       Kumar Gala <galak@kernel.crashing.org>, Dave Jiang <djiang@mvista.com>,
       linuxppc-dev@ozlabs.org
In-Reply-To: <20090715125249.e746496f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ira or Kumar,

can you address Andrew's concerns below and what was posted in prior posts on this?

thanks

doug t

--- On Wed, 7/15/09, Andrew Morton <akpm@linux-foundation.org> wrote:

> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: Re: [PATCH 2/4] edac: mpc85xx add mpc83xx support
> To: dougthompson@xmission.com
> Cc: bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
> Date: Wednesday, July 15, 2009, 1:52 PM
> On Wed, 15 Jul 2009 11:38:49 -0600
> dougthompson@xmission.com
> wrote:
> 
> > 
> > Add support for the Freescale MPC83xx memory
> controller to the existing
> > driver for the Freescale MPC85xx memory controller.
> The only difference
> > between the two processors are in the CS_BNDS register
> parsing code, which
> > has been changed so it will work on both processors.
> > 
> > The L2 cache controller does not exist on the MPC83xx,
> but the OF subsystem
> > will not use the driver if the device is not present
> in the OF device tree.
> > 
> > 
> > Kumar, I had to change the nr_pages calculation to
> make the math work
> > out. I checked it on my board and did the math by hand
> for a 64GB 85xx
> > using 64K pages. In both cases, nr_pages * PAGE_SIZE
> comes out to the
> > correct value. Thanks for the help.
> > 
> > v1 -> v2:
> >   * Use PAGE_SHIFT to parse cs_bnds
> regardless of board type
> >   * Remove special-casing for the 83xx
> processor
> > 
> > ...
> >
> > @@ -789,19 +791,20 @@ static void __devinit
> mpc85xx_init_csrow
> >          csrow =
> &mci->csrows[index];
> >          cs_bnds =
> in_be32(pdata->mc_vbase + MPC85XX_MC_CS_BNDS_0 +
> >         
>           (index *
> MPC85XX_MC_CS_BNDS_OFS));
> > -        start =
> (cs_bnds & 0xfff0000) << 4;
> > -        end = ((cs_bnds
> & 0xfff) << 20);
> > -        if (start)
> > -       
>     start |= 0xfffff;
> > -        if (end)
> > -       
>     end |= 0xfffff;
> > +
> > +        start =
> (cs_bnds & 0xffff0000) >> 16;
> > +       
> end   = (cs_bnds & 0x0000ffff);
> >  
> >          if (start
> == end)
> >         
>     continue;    /* not
> populated */
> >  
> > +        start <<=
> (24 - PAGE_SHIFT);
> > +       
> end   <<= (24 - PAGE_SHIFT);
> > +        end 
>   |= (1 << (24 - PAGE_SHIFT)) - 1;
> 
> <stares for a while>
> 
> That looks like the original code was really really wrong.
> 
> The setting of all the lower bits in `end' is
> funny-looking.  What's
> happening here?  Should it be commented?
> 
> 
> >         
> csrow->first_page = start >> PAGE_SHIFT;
> >         
> csrow->last_page = end >> PAGE_SHIFT;
> > -       
> csrow->nr_pages = csrow->last_page + 1 -
> csrow->first_page;
> > +       
> csrow->nr_pages = end + 1 - start;
> >         
> csrow->grain = 8;
> >         
> csrow->mtype = mtype;
> >         
> csrow->dtype = DEV_UNKNOWN;
> > @@ -985,6 +988,7 @@ static struct of_device_id
> mpc85xx_mc_er
> >      { .compatible =
> "fsl,mpc8560-memory-controller", },
> >      { .compatible =
> "fsl,mpc8568-memory-controller", },
> >      { .compatible =
> "fsl,mpc8572-memory-controller", },
> > +    { .compatible =
> "fsl,mpc8349-memory-controller", },
> >      { .compatible =
> "fsl,p2020-memory-controller", },
> >      {},
> >  };
> > @@ -1001,13 +1005,13 @@ static struct
> of_platform_driver mpc85xx
> >         
>    },
> >  };
> >  
> > -
> > +#ifdef CONFIG_MPC85xx
> >  static void __init mpc85xx_mc_clear_rfxe(void
> *data)
> >  {
> >      orig_hid1[smp_processor_id()]
> = mfspr(SPRN_HID1);
> >      mtspr(SPRN_HID1,
> (orig_hid1[smp_processor_id()] & ~0x20000));
> >  }
> > -
> > +#endif
> >  
> >  static int __init mpc85xx_mc_init(void)
> >  {
> > @@ -1040,26 +1044,32 @@ static int __init
> mpc85xx_mc_init(void)
> >         
> printk(KERN_WARNING EDAC_MOD_STR "PCI fails to
> register\n");
> >  #endif
> >  
> > +#ifdef CONFIG_MPC85xx
> >      /*
> >       * need to clear
> HID1[RFXE] to disable machine check int
> >       * so we can catch
> it
> >       */
> >      if (edac_op_state ==
> EDAC_OPSTATE_INT)
> >         
> on_each_cpu(mpc85xx_mc_clear_rfxe, NULL, 0);
> > +#endif
> >  
> >      return 0;
> >  }
> 
> The patch adds lots of ifdefs :(
> 
> >  module_init(mpc85xx_mc_init);
> >  
> > +#ifdef CONFIG_MPC85xx
> >  static void __exit mpc85xx_mc_restore_hid1(void
> *data)
> >  {
> >      mtspr(SPRN_HID1,
> orig_hid1[smp_processor_id()]);
> >  }
> > +#endif
> 
> afacit this will run smp_processor_id() from within
> preemptible code,
> which is often buggy on preemptible kernels and will cause
> runtime
> warnings on at least some architectures.
> 
> >  static void __exit mpc85xx_mc_exit(void)
> >  {
> > +#ifdef CONFIG_MPC85xx
> >     
> on_each_cpu(mpc85xx_mc_restore_hid1, NULL, 0);
> > +#endif
> >  #ifdef CONFIG_PCI
> >     
> of_unregister_platform_driver(&mpc85xx_pci_err_driver);
> >  #endif
> 
