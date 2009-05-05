Return-Path: <linux-kernel-owner+w=401wt.eu-S1758744AbZEETbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758744AbZEETbM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 15:31:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758427AbZEETaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 15:30:22 -0400
Received: from web50105.mail.re2.yahoo.com ([206.190.38.33]:38059 "HELO
	web50105.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753655AbZEETaS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 15:30:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=UhVmWeNgqqO7IPWmNHME+6GMlR5Qfg+UJ0u5JImgGtwwbHUIjZtF6qtcnURWlSJA2a7KW37Qcl+lZCAOqJ1lIRAqqUV4JVUOfxY/k8Oi+55mxEc0QMsZOgTFPsmqv5T078siSbk5USKVklQlLvf2UlSTskeeEtX5HS2SAUAp1hM=;
Message-ID: <950025.85766.qm@web50105.mail.re2.yahoo.com>
X-YMail-OSG: vctcQbIVM1kd8WEXO7E3DOR3qgsnAg2lC3pNt.PffGZCQLy_rdVRUnbdVeFDZNM_kG0A2O9m6M_mO.F_44gEKHNel1B6mlbbzfUEh2VXpttdTfD.0lC_nlReObz.cyuhBH5SE79AXO7vtWPLaQgtzziDVjNuCG9MKw6HWxocBj2hKoIkEtndi7VMvCe9qmiIqANpSdqB4Ery9Hh4RwWF25uEJrjWRKJ_nM3YmHsLVgT9OEunIaJaqjr5ZTOySKjzOJBSS8tYAj5vkmUkY1BbPtE56XIXvablOJDM
X-Mailer: YahooMailClassic/5.3.9 YahooMailWebService/0.7.289.10
Date: Tue, 5 May 2009 12:30:17 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: [PATCH 13/21] amd64_edac: add f10-and-later methods-p3
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
> Subject: Re: [PATCH 13/21] amd64_edac: add f10-and-later methods-p3
> To: "Borislav Petkov" <borislav.petkov@amd.com>
> Cc: akpm@linux-foundation.org, greg@kroah.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, dougthompson@xmission.com, linux-kernel@vger.kernel.org
> Date: Monday, May 4, 2009, 5:36 PM
> Borislav Petkov escreveu:
> > From: Doug Thompson <dougthompson@xmission.com>
> > 
> > Signed-off-by: Doug Thompson <dougthompson@xmission.com>
> > Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> > ---
> >  drivers/edac/amd64_edac.c |  318
> +++++++++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 318 insertions(+), 0
> deletions(-)
> > 
> > diff --git a/drivers/edac/amd64_edac.c
> b/drivers/edac/amd64_edac.c
> > index fe2342c..84075c0 100644
> > --- a/drivers/edac/amd64_edac.c
> > +++ b/drivers/edac/amd64_edac.c
> > @@ -2726,4 +2726,322 @@ static int
> f10_lookup_addr_in_dct(u32 InputAddr, u32 NodeID, u32
> ChannelSelect)
> >      return CSFound;
> >  }
> >  +/*
> > + * f10_match_to_this_node
> > + *
> > + * For a given 'DramRange' value, check if
> 'SystemAddr' fall within this value
> > + */
> > +static int f10_match_to_this_node(struct amd64_pvt
> *pvt, int DramRange,
> > +       
>         u64 SystemAddr,
> > +       
>         int *node_id,
> > +       
>         int *channel_select)
> > +{
> > +    int CSFound = -1;
> >   
> 
> As in the previous patch, please use a standard error code,
> instead of -1.
> 
> > +static int f10_translate_sysaddr_to_CS(struct
> amd64_pvt *pvt,
> > +       
>     u64 SysAddr,
> > +       
>     int *node,
> > +       
>     int *chanSel)
> > +{
> > +    int DramRange;
> > +    int CSFound = -1;
> >   
> Same here.
> 
> Cheers,
> Mauro
> 

Code was reference code from AMD. Probably safe to convert to use -EINVAL yes

doug t

