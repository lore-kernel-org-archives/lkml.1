Return-Path: <linux-kernel-owner+w=401wt.eu-S1753004AbZD2ENO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004AbZD2ENO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 00:13:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751303AbZD2EM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 00:12:57 -0400
Received: from web50104.mail.re2.yahoo.com ([206.190.38.32]:37085 "HELO
	web50104.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750729AbZD2EM4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 00:12:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=FyX1LyrUYCtpDagwE7QOwLtYl6mNiH6n3wsijVUr9f28HAx9MTHqzq5p1wOwqiCZ99O1XtrCVvE5N3cGaG1HYPNqHbd1V+A0fiuAyBQwWzAuRSSTfMz85g1+dEVDmdBx5WCW4PR5SMerKnu7gqdmsjMaPoiH3CTm01FjiX5fjhk=;
Message-ID: <204800.52873.qm@web50104.mail.re2.yahoo.com>
X-YMail-OSG: ud1KV5IVM1nMeBd90aP8Raw3EPyoGERn1_CXt2bCW1Kt_e5Uhk91Pp._ppxN8UX3rbaGwa8uJhwU4iDpn3JQH2lqH_pX..OHzQA_UaUFQK1nWt_2akZ66JJ7k5.KwSYUUnhlj3eBTuMIZp9kyPb4SIYZDTrKXr4OZS3iH9rhfOv_SI_5hcbixeDIR1TEa8H_oZ5eSaLlAE7l1xz676YbfiWSDbN2yVFIqdoU35AiFqD_Was803XoPEVGc205VCBjkUJ.QTpL0NSQ5ORYHvWkcaVlSt9wa3yL76yb0J3X66.mzT1HQxXu_8k-
X-Mailer: YahooMailClassic/5.2.20 YahooMailWebService/0.7.289.10
Date: Tue, 28 Apr 2009 21:12:55 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: bug in drivers/edac/mpc85xx_edac.c:mpc85xx_mc_check()
To: Dave Jiang <djiang@mvista.com>
Cc: linux-kernel@vger.kernel.org, Jeff Haran <jharan@Brocade.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dave, can you look at this

doug thompson

--- On Tue, 4/28/09, Jeff Haran <jharan@Brocade.COM> wrote:

> From: Jeff Haran <jharan@Brocade.COM>
> Subject: bug in drivers/edac/mpc85xx_edac.c:mpc85xx_mc_check()
> To: linux-kernel@vger.kernel.org
> Date: Tuesday, April 28, 2009, 7:23 PM
> Hi,
> 
> Recent versions of this function contain the following
> snippets:
> 
>     if (err_detect & DDR_EDE_SBE)
>         edac_mc_handle_ce(mci, pfn,
> err_addr & PAGE_MASK,
>                
>   syndrome, row_index, 0, mci->ctl_name);
> 
>     if (err_detect & DDR_EDE_MBE)
>         edac_mc_handle_ue(mci, pfn,
> err_addr & PAGE_MASK,
>                
>   row_index, mci->ctl_name);
> 
> I am pretty sure the references to PAGE_MASK should be
> proceeded by a
> tilda, as in:
> 
>     if (err_detect & DDR_EDE_SBE)
>         edac_mc_handle_ce(mci, pfn,
> err_addr & ~PAGE_MASK,
>                
>   syndrome, row_index, 0, mci->ctl_name);
> 
>     if (err_detect & DDR_EDE_MBE)
>         edac_mc_handle_ue(mci, pfn,
> err_addr & ~PAGE_MASK,
>                
>   row_index, mci->ctl_name);
> 
> 
> Much as I would like to submit a tested patch like the rest
> of the
> world, I find myself in the situation where the only
> Freescale target
> system I have to test on is running a 3 year old kernel
> (2.6.14), which
> preceeds the introduction of EDAC driver support, at least
> for
> Freescale. So the best I can do is borrow from the new EDAC
> driver and
> backport it to the old kernel.
> 
> But I have learned a few things in this process and can
> thus share what
> I've learned as it may be of help to the EDAC driver
> developers:
> 
> 1) Before you read the Freescale 8548 CAPTURE_ADDRESS
> register, you want
> to read CAPTURE_ATTRIBUTES first and make sure the VLD bit
> (least
> significant bit in the register) is set or else the data
> in
> CAPTURE_ADDRESS may not be yet valid.
> 
> 2) When you are done scrubbing the memory with the single
> bit error, you
> want to write 0 to CAPTURE_ATTRIBUTES so as to clear VLD
> and thus setup
> the ECC capture logic to capture the next single bit
> error.
> 
> Please include this email address in responses as I do not
> subscribe.
> 
> Thanks,
> 
> Jeff Haran
> Brocade
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
