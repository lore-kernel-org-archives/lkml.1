Return-Path: <linux-kernel-owner+w=401wt.eu-S1763996AbZD3Nz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763996AbZD3Nz7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 09:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763946AbZD3Nzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 09:55:35 -0400
Received: from web50105.mail.re2.yahoo.com ([206.190.38.33]:23075 "HELO
	web50105.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1763841AbZD3Nze convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 09:55:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=3Rv4JE+zvUr0veSmVmABdPh3u6Li9LaBfcmR4rNOgVwmn/M5Q1iZRBltmB+k2GhGu+Fwc+/sMfU6240HCOPKEJ3OucurDDphqIX3YzVRNjozqnCXsnsshCgP4nHQ3v7s9rFihzsEv6HH5vTsG690eW9VDx9br2dCc8Gpfx0vcQA=;
Message-ID: <37726.64726.qm@web50105.mail.re2.yahoo.com>
X-YMail-OSG: GJLJ9uAVM1kKiNG0Em.dw0Erokb1_0aW1ppv2DjIs34Zci9x4p4evTUg5Ag6qu4MIqDoR5pIqSHLkbae_Scn.pCZ_rGdu65NGLukjgGZyEB6FBLb.43N84Y00OG1ZtliNFW8aqo.kFwEH08kTHuEBSmqebOFhUHq9F6ZHKfzJopGXRiY3HbXl2xHmFV1O3SvJJM2hduZXwDfob8cI1ItrwrtWBw9GoETNm6rLUsQgjSLd74D5.HtlFXiEXLWiLz.d.EDpaJ7HKe2AcfmhlrxNZiHJ.u9GPh8kzgyG_wwean.KngFoaOCmQoBtgRyzl6G
X-Mailer: YahooMailClassic/5.3.9 YahooMailWebService/0.7.289.10
Date: Thu, 30 Apr 2009 06:55:32 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: [PATCH 20/21] amd64_edac: add DRAM error injection logic using sysfs
To: Ingo Molnar <mingo@elte.hu>
Cc: Borislav Petkov <borislav.petkov@amd.com>, akpm@linux-foundation.org,
       greg@kroah.com, tglx@linutronix.de, hpa@zytor.com,
       dougthompson@xmission.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- On Thu, 4/30/09, Ingo Molnar <mingo@elte.hu> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Subject: Re: [PATCH 20/21] amd64_edac: add DRAM error injection logic using sysfs
> To: "Doug Thompson" <norsk5@yahoo.com>
> Cc: "Borislav Petkov" <borislav.petkov@amd.com>, akpm@linux-foundation.org, greg@kroah.com, tglx@linutronix.de, hpa@zytor.com, dougthompson@xmission.com, linux-kernel@vger.kernel.org
> Date: Thursday, April 30, 2009, 2:34 AM
> 
> * Doug Thompson <norsk5@yahoo.com>
> wrote:
> 
> > 
> > I believe I failed to reply to ALL and replied only to
> the sender
> > 
> > doug t
> > 
> > --- On Wed, 4/29/09, Ingo Molnar <mingo@elte.hu>
> wrote:
> > 
> > > From: Ingo Molnar <mingo@elte.hu>
> > > Subject: Re: [PATCH 20/21] amd64_edac: add DRAM
> error injection logic using sysfs
> > > To: "Borislav Petkov" <borislav.petkov@amd.com>
> > > Cc: akpm@linux-foundation.org,
> greg@kroah.com, tglx@linutronix.de,
> hpa@zytor.com, dougthompson@xmission.com,
> linux-kernel@vger.kernel.org
> > > Date: Wednesday, April 29, 2009, 12:17 PM
> > > 
> > > * Borislav Petkov <borislav.petkov@amd.com>
> > > wrote:
> > > 
> > > > From: Doug Thompson <dougthompson@xmission.com>
> > > > 
> > > > Signed-off-by: Doug Thompson <dougthompson@xmission.com>
> > > > Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> > > > ---
> > > >  drivers/edac/amd64_edac.c |  287
> > > +++++++++++++++++++++++++++++++++++++++++++++
> > > >  1 files changed, 287 insertions(+), 0
> > > deletions(-)
> > > > 
> > > > diff --git a/drivers/edac/amd64_edac.c
> > > b/drivers/edac/amd64_edac.c
> > > > index b1a7e8c..4d1076f 100644
> > > > --- a/drivers/edac/amd64_edac.c
> > > > +++ b/drivers/edac/amd64_edac.c
> > > > @@ -4621,3 +4621,290 @@ static ssize_t
> > > amd64_hole_show(struct mem_ctl_info *mci, char
> *data)
> > > >  
> > > >  #endif    /* DEBUG */
> > > >  
> > > > +#ifdef
> CONFIG_EDAC_AMD64_OPTERON_ERROR_INJECTION
> > > 
> > > this should be in a separate .c file under
> > > drivers/edac/amd64/. 
> > > 
> > > Introducing large #ifdef sections like that is
> not very
> > > clean. The 
> > > amd64_edac.c file is _way_ too large at more than
> 5000
> > > lines of 
> > > code.
> > > 
> > >     Ingo
> > 
> > If we broke this into a separate files, then there
> would be TWO 
> > (2) files: 1 for the source code of the routines and a
> 1 for the 
> > table entries which reference those routines. Is that
> then 
> > acceptable as well?
> > 
> > Same pattern applies to the DEBUG functions Info
> refers to in 
> > another thread: 2 separate files would be required as
> well.
> > 
> > 2 files for Error Injection code
> > 2 files for DEBUG controls
> > 1 files for text mapping
> > 
> > and I assume all these would be included via an
> #include statement 
> > at their appropriate locations
> 
> A Makefile might be more natural i think - that way the
> #ifdef turns 
> into a makefile rule?
> 
>     Ingo
> 

OK, yes for the separate and standalone functions themselves, but NOT for the function pointer table entries, which also share the table with the DEBUG function pointers and possibly function pointers to code that is not bracketed by #ifdefs 

The function pointer table itself is/can be composed of several entries, not just of the injection or debug kind. In this instance, that is what is there, but I would prefer to allow for future additions not tied to injection and/or debug origins nor of #ifdef bracketing

doug t

