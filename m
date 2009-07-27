Return-Path: <linux-kernel-owner+w=401wt.eu-S1753998AbZG0SB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbZG0SB2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 14:01:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751363AbZG0SB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 14:01:27 -0400
Received: from web50108.mail.re2.yahoo.com ([206.190.38.36]:28454 "HELO
	web50108.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753972AbZG0SB1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 14:01:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=Tzp/HF4reWdiKLb9HEPTPpSlZAd8Z1El5iRuzQqfYNG+mBEK7TDG3Vm/TVg6e8pgzV0hIGZFjIBV2bV3LrO0bCUQVLXwnn9cuZkPfKvQ09ZfmOgakYgOXTU636A2I5qQ6FEbc0+H9n34d5+pTXZqqFDn4opXasV3PYsBM0WU1ac=;
Message-ID: <368206.16549.qm@web50108.mail.re2.yahoo.com>
X-YMail-OSG: oxXLOVEVM1mq19AWsd4Va_TpiaxEHlojZgXFeD6t0dnqWQQKLoJxyZYXAevRWCsEwLKohhacTfvwaqettvRf8AHEo1j1pWEzc6R8bsbetqPFotI6RBlUAlxWLPMhultebQ_5WWmsolBijGsgXm_skYovvz0AbgdsFv1R3_kI211qC9codhSqWAwTSZV0KVrEat5q7YLD1jdlNx2c.dfblhuoIOHs9LNkNpmLFEenRET_5z0yD2ZV6xvKAw4e7amCsKT9AnnZp5fLQg6LyKX6MzOCiQryDm9mP7lyAzWf7VucJ3SZK2YHFFGorO4qqEcdFGeLgfs7NCIU9Dz0idVcqwTMb8IZSw--
X-Mailer: YahooMailClassic/6.0.19 YahooMailWebService/0.7.338.1
Date: Mon, 27 Jul 2009 11:01:26 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: [PATCH] amd64_edac: fix insmod fail while ecc is enabled
To: dougthompson@xmission.com, borislav.petkov@amd.com,
       wan wei <onewayforever@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <86bb1aef0907270947o6219f950xf13a077b30486d41@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for this. 

It is the same as one I posted last week or so.

Without it, the module fails to initialize and no polling occurs.

Boris,  

In a prior email you indicated that you refactored the function in question. What that in the series of patches you submitted?  I think that set is too big to get in the RC branch.

We need this in 2.6.31 in order for the module to even work.

Shall we push my simple one, or your complete refactor?

doug t


--- On Mon, 7/27/09, wan wei <onewayforever@gmail.com> wrote:

> From: wan wei <onewayforever@gmail.com>
> Subject: [PATCH] amd64_edac: fix insmod fail while ecc is enabled
> To: dougthompson@xmission.com, borislav.petkov@amd.com
> Cc: linux-kernel@vger.kernel.org
> Date: Monday, July 27, 2009, 10:47 AM
> Signed-off-by: Wan Wei<wanwei@mail.dawning.com.cn>
> 
> diff --git a/drivers/edac/amd64_edac.c
> b/drivers/edac/amd64_edac.c
> index 858fe60..95b1096 100644
> --- a/drivers/edac/amd64_edac.c
> +++ b/drivers/edac/amd64_edac.c
> @@ -2979,6 +2979,7 @@ static int
> amd64_check_ecc_enabled(struct amd64_pvt *pvt)
> 
>                 /*
> CLEAR the override, since BIOS controlled it */
>                
> ecc_enable_override = 0;
> +           
>    ret = 0;
>         }
> 
>         return ret;
> 
