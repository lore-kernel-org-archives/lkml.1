Return-Path: <linux-kernel-owner+w=401wt.eu-S1756746AbZFCIBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746AbZFCIBA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 04:01:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755793AbZFCIAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 04:00:43 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:41000 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756073AbZFCIAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 04:00:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=hTLpvpkidwTtDFkh3j8asAAw61gKDFr5ZXNJuxIwlr710gJqPIQnmg5qIiV1wdjo/O
         adKJam3Lkjtf0J3RqKiwe0+T5mGHf2S9ogQB21QyoX0sAoyg3OkwgcIqSxt111H3U5s7
         Ms2D/yQ/Exn54kQCONaH0SVGL/v8a8nZSU4Bw=
Date: Wed, 3 Jun 2009 10:00:40 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Peter Feuerer <peter@piie.net>
Cc: LKML <linux-kernel@vger.kernel.org>, lenb@kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [PATCH] Acer Aspire One Fan Control
Message-ID: <20090603080040.GA2716@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@gmail.com>,
	Peter Feuerer <peter@piie.net>, LKML <linux-kernel@vger.kernel.org>,
	lenb@kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>,
	Maxim Levitsky <maximlevitsky@gmail.com>
References: <20090503184617.GA3555@liondog.tnic> <cone.1241648222.299676.7476.1000@mentalhome> <20090509171432.GA31126@liondog.tnic> <cone.1242065107.695268.13534.1000@onepiie> <20090512060231.GB26286@liondog.tnic> <cone.1242669880.118150.4276.1000@deskpiie> <20090524192219.GA30285@liondog.tnic> <cone.1243865900.580144.4368.1000@deskpiie> <20090603073939.GB2671@liondog.tnic> <cone.1244015521.698111.16292.1000@arca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cone.1244015521.698111.16292.1000@arca>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jun 03, 2009 at 09:52:01AM +0200, Peter Feuerer wrote:
>>> +#define pr_fmt(fmt) "acerhdf: " fmt
>>
>> This is new but it's not used anywhere. Maybe some debug leftovers?
>
> This is the way Joe suggested, how to use printk's:
> You define the pr_fmt(fmt) before any includes and you can just do  
> 'pr_notice("Fan control off, to enable:\n");' to printk a notice which 
> looks like this: "acerhdf: Fan control off...". Same with pr_err(...) 
> which prints an error.

Ah, this thing. Ok.

...

+static int acerhdf_unbind(struct thermal_zone_device *thermal,
+               struct thermal_cooling_device *cdev)
+{
+       if (cdev != acerhdf_cool_dev)
+               return 0;
+
+       if (thermal_zone_unbind_cooling_device(thermal, 0, cdev)) {
+               pr_err("acerhdf: error unbinding cooling dev\n");

you've missed one here.

+               return -EINVAL;
+       }
+       return 0;
+}

...


-- 
Regards/Gruss,
    Boris.
