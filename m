Return-Path: <linux-kernel-owner+w=401wt.eu-S1754669AbZHCJP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbZHCJP6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 05:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754510AbZHCJP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 05:15:58 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:58006 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754492AbZHCJP5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 05:15:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TYGn9cd/BihWOdbr68st07xvG63OMlsT/tPod2cctLdMglifs+F2pLvyjjyZp3RR5Q
         aGPIseTNvEs4+Imi81nlS3XWWUMrYZNnnwYNByqGIC/KPkn8Dj/I5rESYNd53MyTaMIs
         x4vP8J33fTjwuvoAU9vAVEcY7CEz0KrYQPN54=
MIME-Version: 1.0
In-Reply-To: <74d0deb30908021049u191b3f9fj5230193535965ff7@mail.gmail.com>
References: <quadros.roger@gmail.com>
	 <1249232208-22274-1-git-send-email-quadros.roger@gmail.com>
	 <74d0deb30908021049u191b3f9fj5230193535965ff7@mail.gmail.com>
Date: Mon, 3 Aug 2009 12:15:57 +0300
Message-ID: <b90c0690908030215j3f0fb6a6u322a079795193652@mail.gmail.com>
Subject: Re: [PATCH v3] regulator: Add GPIO enable control to fixed voltage 
	regulator driver
From: Roger Quadros <quadros.roger@gmail.com>
To: pHilipp Zabel <philipp.zabel@gmail.com>
Cc: broonie@sirena.org.uk, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 2, 2009 at 8:49 PM, pHilipp Zabel<philipp.zabel@gmail.com> wrote:
> On Sun, Aug 2, 2009 at 6:56 PM, Roger Quadros<quadros.roger@gmail.com> wrote:
>> From: Roger Quadros <ext-roger.quadros@nokia.com>
>>
>> +
>> +               /* set output direction without changing state
>> +                * to prevent glitch
>> +                */
>> +               drvdata->is_enabled = config->enabled_at_boot;
>> +               if (!config->enable_high)
>> +                       drvdata->is_enabled = !drvdata->is_enabled;
>
> Assume .enabled_at_boot = 1, .enable_high = 0. In this case we end up
> with .is_enabled = 0, which does not represent the real state after
> the following call:
>
>> +               ret = gpio_direction_output(config->gpio, drvdata->is_enabled);
>
> Maybe use a local variable here or (drvdata->is_enabled ?
> config->enable_high : !config->enable_high).
>
> regards
> Philipp
>

Yes you are right.
