Return-Path: <linux-kernel-owner+w=401wt.eu-S1754498AbZCKTCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbZCKTCd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 15:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754550AbZCKTCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 15:02:20 -0400
Received: from web50101.mail.re2.yahoo.com ([206.190.38.29]:38034 "HELO
	web50101.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754423AbZCKTCT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 15:02:19 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Mar 2009 15:02:18 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=1/r++0yXjSEBOkOETe9mNJ9y5WKXH/Z+g8KFt1XT+U1vJe0XkX+gAzBJEMmd1zApME2+M18OiNNZOUmobzVZBNuSNPU4Xux9nzXWMIReAj1E7GeTsa/LnPJQ+zLlDTQwkUkYPqI56N1llwmyURhEMDM6EDDfJ4hpv9HOXsF66GU=;
Message-ID: <918342.94228.qm@web50101.mail.re2.yahoo.com>
X-YMail-OSG: J2e3wkIVM1lDsO5sMhpfXjmhOEzINx.vK_yWVxuS_jfZQmaERA.0GBc4vZJyNsYU3a8VGYI7MglYyqPfxmP26OsMR.ZIXHla8_BYFQgnXMVyg7_5IjlfZ6yDrmNQOa6Z_YbXr2ac9yKDGuxjVuxAwwatcw3f9O1sxMcm2kVbvpT_CqVW6V9InV97COurxQ6khmlco4qrqzSdyVgeGal90qLQ1Qoc
X-Mailer: YahooMailClassic/5.1.19 YahooMailWebService/0.7.289.4
Date: Wed, 11 Mar 2009 11:55:36 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: [v1 PATCH 3/8] EDAC: AMD8111 driver source file
To: Harry Ciao <qingtao.cao@windriver.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, bluesmoke-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- On Tue, 3/10/09, Andrew Morton <akpm@linux-foundation.org> wrote:

> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: Re: [v1 PATCH 3/8] EDAC: AMD8111 driver source file
> To: "Harry Ciao" <qingtao.cao@windriver.com>
> Cc: linux-kernel@vger.kernel.org, bluesmoke-devel@lists.sourceforge.net
> Date: Tuesday, March 10, 2009, 2:46 PM
> On Mon,  9 Mar 2009 16:08:12
> +0800
> Harry Ciao <qingtao.cao@windriver.com>
> wrote:

<snip>

> > +static void edac_pci_write_dword(struct pci_dev *dev,
> int reg, u32 val32)
> > +{
> > +    int ret;
> > +
> > +    ret = pci_write_config_dword(dev,
> reg, val32);
> > +    if (ret > 0)
> > +        printk(KERN_ERR
> AMD8111_EDAC_MOD_STR
> > +       
>     " PCI Access Write Error at 0x%x\n",
> reg);
> > +}
> > +
> > +static void edac_pci_write_byte(struct pci_dev *dev,
> int reg, u8 val8)
> > +{
> > +    int ret;
> > +
> > +    ret = pci_write_config_byte(dev,
> reg, val8);
> > +    if (ret > 0)
> > +        printk(KERN_ERR
> AMD8111_EDAC_MOD_STR
> > +       
>     " PCI Access Write Error at 0x%x\n",
> reg);
> > +}
> 
> 
> <spends a while trying to work out what the return value
> of
> pci_read_config_dword() means>
> 
> <gets frustrated and gives up>
> 
> Is it correct that all of these functions treat a +ve
> return value as
> an error?

Yes, the config APIs do return an error code on an operation error. I found that before and during the transition to the AMD IOCF8 IO-Space config transition - the 12 bits of config space vs the 8 bits of config space and where AMD started using the PCI reserved bits to access the their extended config space.

The yet to be pushed upstream AMD64 EDAC driver required the extended config space access for the Family 10h CPUs

Now, I bracketed such error processing with #DEFINE DEBUG printouts to provide some type of signal during development of an error. This is not in the kernel yet.

I suppose these lines here are similar to provide some useless notice of an error

doug t

