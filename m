Return-Path: <linux-kernel-owner+w=401wt.eu-S1757456AbZEET2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757456AbZEET2T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 15:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753187AbZEET2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 15:28:04 -0400
Received: from web50101.mail.re2.yahoo.com ([206.190.38.29]:21084 "HELO
	web50101.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752491AbZEET2D convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 15:28:03 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=xYFKnSmOu1rO8moucaQ1G1CvLiIKvSOw1Lt1/k+1B9k7cEUuKIsM6SwbXu16uzM+Sl33ZZVzXlNyr4jAOQcdL2RR/WoOZZ6q+VSBV0HTJAZF11q3sj8ltQTXOumOj0imU5nuUjaykbVvR4JpkToWNyyInxyx4SIHRScHxGHdECs=;
Message-ID: <824989.5191.qm@web50101.mail.re2.yahoo.com>
X-YMail-OSG: CciFDNoVM1mgYwOfq0rzsToh.odbottq6ONFeXgwFv8HBZodrA22ajl6j4XsNPCzzhGTUeqMigVLrP6d9zbQWpRtl.WGG9SuWmhYxQIJF8bJwtsMVU2x2uUqP06fyX4wN_N2FVM9KHcpaZj8hS2wBN6y0mNttlt3r19j5Q4v6bXgihkHhNYoKFCOkldR6d5Qe2NGgD3ukIdUDzRqvkwBqIShoiVzf3MMEG3yvBgZ5VlCEgCynHrAvpJRmSvvNLL.ETDS1GmpCYCboRvtR2upDlsdGEP5hIPGHhR3Zn5te6uJU.xJBTg.4GajCUF6uEyI
X-Mailer: YahooMailClassic/5.3.9 YahooMailWebService/0.7.289.10
Date: Tue, 5 May 2009 12:28:01 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: [PATCH 09/21] amd64_edac: assign DRAM chip select base and mask in a family-specific way
To: Borislav Petkov <borislav.petkov@amd.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: akpm@linux-foundation.org, greg@kroah.com, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com, dougthompson@xmission.com,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- On Mon, 5/4/09, Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

> From: Mauro Carvalho Chehab <mchehab@redhat.com>
> Subject: Re: [PATCH 09/21] amd64_edac: assign DRAM chip select base and mask in a family-specific way
> To: "Borislav Petkov" <borislav.petkov@amd.com>
> Cc: akpm@linux-foundation.org, greg@kroah.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, dougthompson@xmission.com, linux-kernel@vger.kernel.org
> Date: Monday, May 4, 2009, 3:59 PM
> Borislav Petkov escreveu:
> > +    for (cs = 0; cs <
> CHIPSELECT_COUNT; cs++) {
> > +        reg = K8_DCSB0
> + (cs * 4);
> > +        err =
> pci_read_config_dword(pvt->dram_f2_ctl, reg,
> > +       
>            
>     &pvt->dcsb0[cs]);
> > +        if (err != 0)
> > +       
>     debugf0("%s() Reading K8_DCSB0[%d]
> failed\n",
> > +       
>         __func__, cs);
> > +
> > +        debugf0(" 
> DCSB0[%d]=0x%08x reg: F2x%x\n",
> > +       
>     cs, pvt->dcsb0[cs], reg);
> >   
> 
> Hmm... I suspect that there's a missing else before the
> debugf0(). If you got an error while reading it, you
> shouldn't be showing the results. 
> > +
> > +        /* If DCT are
> NOT ganged, then read in DCT1's base */
> > +        if
> (boot_cpu_data.x86 >= 0x10 &&
> !dct_ganging_enabled(pvt)) {
> > +       
>     reg = F10_DCSB1 + (cs * 4);
> > +       
>     err =
> pci_read_config_dword(pvt->dram_f2_ctl, reg,
> > +       
>            
>        
> &pvt->dcsb1[cs]);
> > +       
>     if (err != 0)
> > +       
>         debugf0("%s() Reading
> F10_DCSB1[%d] failed\n",
> > +       
>            
> __func__, cs);
> > +       
>     debugf0("  DCSB1[%d]=0x%08x reg:
> F2x%x\n",
> > +       
>         cs, pvt->dcsb1[cs],
> reg);
> >   
> The same issue here: if you got an error while reading it,
> you shouldn't be showing the results. 
> Cheers,
> Mauro.
> 

An 'else' could be inserted, but it is only under DEBUG state for development purposes.  

BACKGROUND: The error checking of the pci config space read was added during the time when the kernel couldn't read the extended 4k config space via the AMD IOConfig port access function (12 bits of offset) not via MMCONFIG. 

doug t
