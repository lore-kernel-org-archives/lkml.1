Return-Path: <linux-kernel-owner+w=401wt.eu-S1754854AbZBIVs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854AbZBIVs4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 16:48:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbZBIVss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 16:48:48 -0500
Received: from rn-out-0910.google.com ([64.233.170.185]:10792 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511AbZBIVsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 16:48:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Jox0agcedAMp88dOgHpu+sQ8RYw7RDjxmI0BthjE3rMGDWMmbC4GEM9cEyyeEL4qPE
         ZkL7h2Cwuks90rQbzRQNOzsaOqjyfvRjjB5SyvetSnv9qU/iR/f7GocMKKC5C2CPjpKG
         6In9o2XDBRb8dBI7IJZt/QS9gIh6mkACE3cPs=
Subject: Re: [1/1] w1: w1 temp calculation overflow fix.
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ian Dall <ian@beware.dropbear.id.au>
In-Reply-To: <20090209214217.GA14958@ioremap.net>
References: <20090209214217.GA14958@ioremap.net>
Content-Type: text/plain
Date: Mon, 09 Feb 2009 13:48:44 -0800
Message-Id: <1234216124.5574.12.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-10 at 00:42 +0300, Evgeniy Polyakov wrote:
> Signed-off-by: Ian Dall <ian@beware.dropbear.id.au>
> Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>
> 
> diff --git a/drivers/w1/slaves/w1_therm.c b/drivers/w1/slaves/w1_therm.c
> index 2c8dff9..1ed3d55 100644
> --- a/drivers/w1/slaves/w1_therm.c
> +++ b/drivers/w1/slaves/w1_therm.c
> @@ -115,7 +115,7 @@ static struct w1_therm_family_converter w1_therm_families[] = {
>  
>  static inline int w1_DS18B20_convert_temp(u8 rom[9])
>  {
> -	s16 t = (rom[1] << 8) | rom[0];
> +	int t = ((s16)rom[1] << 8) | rom[0];

Alternatively,

	int t = (s16)le16_to_cpup((__le16 *)rom);

Cheers,

Harvey

