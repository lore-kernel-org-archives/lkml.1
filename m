Return-Path: <linux-kernel-owner+w=401wt.eu-S1758413AbZD3G3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758413AbZD3G3G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 02:29:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750714AbZD3G2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 02:28:53 -0400
Received: from web50109.mail.re2.yahoo.com ([206.190.38.37]:43150 "HELO
	web50109.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751140AbZD3G2w convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 02:28:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=U0KSN07kDD8QUnGuNOptUw1PFXZoZLHEVyjd1hLw3/iRdbKpKwKRcoKJeHqpVan0pZWOucfuskEy+dAww73TO4DlW8l//VHvy9cyxyysml27ATmq/PURPGYvNo1TL9SG9a1MLaaM2p6HJ6awKO70wbvRn5UjZ0OgqpJB6TFBTRI=;
Message-ID: <20977.9082.qm@web50109.mail.re2.yahoo.com>
X-YMail-OSG: 7od9BeYVM1n1iunsIFrploal0FYB0sK2M7C_APBBoTZ_ruIPVD8kuUiKAdsTUnPluLT8iyoWLLG2ujKbGMD.fKwCjxEpbnvwKe..4cdM3QebB67mxxfUmRcxvRvSBcvejSIxJRGi3zC9l9yh8Pw_aFBmIPfKAm4r6oP3BklOxTNHIo_jyqfw3fktBPbAuo8KNhnqZgr7sKLtW6mBBVZtcsAddwFAtPHkPYwZ7cIBALNl6Me9Bi_c8j8fSffr94slw18wWltkO4BIjcu9TRPe8pKCmENCZ6cmhvHc4BhTj6w3hm92Em0joumAA93U4OaG
X-Mailer: YahooMailClassic/5.3.9 YahooMailWebService/0.7.289.10
Date: Wed, 29 Apr 2009 23:28:51 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: [PATCH 20/21] amd64_edac: add DRAM error injection logic using sysfs
To: Borislav Petkov <borislav.petkov@amd.com>, Ingo Molnar <mingo@elte.hu>
Cc: akpm@linux-foundation.org, greg@kroah.com, tglx@linutronix.de,
       hpa@zytor.com, dougthompson@xmission.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I believe I failed to reply to ALL and replied only to the sender

doug t

--- On Wed, 4/29/09, Ingo Molnar <mingo@elte.hu> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> Subject: Re: [PATCH 20/21] amd64_edac: add DRAM error injection logic using sysfs
> To: "Borislav Petkov" <borislav.petkov@amd.com>
> Cc: akpm@linux-foundation.org, greg@kroah.com, tglx@linutronix.de, hpa@zytor.com, dougthompson@xmission.com, linux-kernel@vger.kernel.org
> Date: Wednesday, April 29, 2009, 12:17 PM
> 
> * Borislav Petkov <borislav.petkov@amd.com>
> wrote:
> 
> > From: Doug Thompson <dougthompson@xmission.com>
> > 
> > Signed-off-by: Doug Thompson <dougthompson@xmission.com>
> > Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> > ---
> >  drivers/edac/amd64_edac.c |  287
> +++++++++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 287 insertions(+), 0
> deletions(-)
> > 
> > diff --git a/drivers/edac/amd64_edac.c
> b/drivers/edac/amd64_edac.c
> > index b1a7e8c..4d1076f 100644
> > --- a/drivers/edac/amd64_edac.c
> > +++ b/drivers/edac/amd64_edac.c
> > @@ -4621,3 +4621,290 @@ static ssize_t
> amd64_hole_show(struct mem_ctl_info *mci, char *data)
> >  
> >  #endif    /* DEBUG */
> >  
> > +#ifdef CONFIG_EDAC_AMD64_OPTERON_ERROR_INJECTION
> 
> this should be in a separate .c file under
> drivers/edac/amd64/. 
> 
> Introducing large #ifdef sections like that is not very
> clean. The 
> amd64_edac.c file is _way_ too large at more than 5000
> lines of 
> code.
> 
>     Ingo

If we broke this into a separate files, then there would be TWO (2) files: 1 for the source code of the routines and a 1 for the table entries which reference those routines. Is that then acceptable as well?

Same pattern applies to the DEBUG functions Info refers to in another thread:  2 separate files would be required as well.

2 files for Error Injection code
2 files for DEBUG controls
1 files for text mapping

and I assume all these would be included via an #include statement at their appropriate locations

thx

doug t

