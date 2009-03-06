Return-Path: <linux-kernel-owner+w=401wt.eu-S1757423AbZCFTQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423AbZCFTQi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 14:16:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755799AbZCFTQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 14:16:28 -0500
Received: from n29.bullet.mail.mud.yahoo.com ([68.142.207.48]:25552 "HELO
	n29.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754516AbZCFTQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 14:16:26 -0500
X-Yahoo-Newman-Id: 926145.85921.bm@omp423.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Lbo4jI4fB96zIYeSJZMNYgvgJRIXj14DaaP/TsVGMXToTPnjEKRWfYTrOY4cD7+PoB430MrHh+8MIr0Xdd4HhxHLgFX564My4zbhX2CR+gxeANEA54uu8IKaGvNbKRc4PHaeVqDo+4qMPiklqFMllyn4cWjqgcqfPH8r1uQ+oK8=  ;
X-YMail-OSG: 9sWYWD8VM1nXUTHQZqoo4sc_d.6GLYZf8VZ.ka9zytqiJ8NeMepdEd4OccGzYXPXG3nMm7rnGeJjO52c756t8fXU4FVmViAj.1e3i6gEsX69JxNanZTBTkwoeR_dheL_C0YYRLUqYH86JonnP6JCZOZvRfQw0SnRNLurwTrv0Bky9RFEBHHF_Xfszg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Adrian Hunter <adrian.hunter@nokia.com>
Subject: Re: [PATCH] regulator: twl4030 VAUX3 supports 3.0V
Date: Fri, 6 Mar 2009 11:16:20 -0800
User-Agent: KMail/1.9.10
Cc: lrg@slimlogic.co.uk, LKML <linux-kernel@vger.kernel.org>,
       "linux-omap Mailing List" <linux-omap@vger.kernel.org>
References: <49B11EB0.30809@nokia.com>
In-Reply-To: <49B11EB0.30809@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903061116.21544.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 March 2009, Adrian Hunter wrote:
> TWL4030 and TWL5030 support 3.0V on VAUX3.

I double checked several technical reference manuals, and they
say otherwise.   The 3.0V settings in VAUX3_DEDICATED are very
consistently labeled as "TI cannot support these values", for
all current versions of chips with a VAUX3 supply:

  TWL4030 ES3.1
  TWL5030 ES1.1
  TPS65930 ES1.0 (more or less a cost-reduced TWL5030)
  TPS65950 ES1.0 (more or less TWL5030)

So, NAK on this.

Do you really need 3.0V out of that regulator?  If so,
then I'd rather see a patch exposing that CONFIG_*
setting to enable all the unsupported/out-of-range
values, rather than just selectively hacking those
tables to permit some (but not all) of them to be used
out-of-range.


> Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
> ---
> 
> According to TI:
> http://community.ti.com/forums/t/3777.aspx

That looks to me like some random TI developer reading the
manual and ignoring the label on those settings:  Yes if you
set that value it'll probably work.  But no, if you rely on
that it's working out-of-spec, and is clearly marked as such.


 
> 
> 
>  drivers/regulator/twl4030-regulator.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/regulator/twl4030-regulator.c b/drivers/regulator/twl4030-regulator.c
> index 8655443..1755026 100644
> --- a/drivers/regulator/twl4030-regulator.c
> +++ b/drivers/regulator/twl4030-regulator.c
> @@ -224,7 +224,7 @@ static const u16 VAUX2_VSEL_table[] = {
>  };
>  static const u16 VAUX3_VSEL_table[] = {
>  	1500, 1800, 2500, 2800,
> -	UNSUP(3000), UNSUP(3000), UNSUP(3000), UNSUP(3000),
> +	3000, 3000, 3000, 3000,
>  };
>  static const u16 VAUX4_VSEL_table[] = {
>  	700, 1000, 1200, UNSUP(1300),
> -- 
> 1.5.6.3
> 
> 



