Return-Path: <linux-kernel-owner+w=401wt.eu-S1757515AbYJIIDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757515AbYJIIDX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 04:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755783AbYJIIC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 04:02:58 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:17334 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbYJIIC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 04:02:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=T7afudrWlMCDM5vuJfKsboRxktit3g2L+PMsC6OOQfapoW4s+vscjY6vf64/dF9B8h
         /D2OeoB4Wuna/GvcybKhJl5ENgO0ep1QxqFUnfdtphKtQ5lj8IGLwkAhJfANXui+I5Kw
         hOaMOJIZb+GvRA2y6QrRpOc071EZJw2uro1yQ=
Message-ID: <520f0cf10810090102je412ff9rb02017973d339ec1@mail.gmail.com>
Date: Thu, 9 Oct 2008 10:02:55 +0200
From: "John Kacur" <jkacur@gmail.com>
To: Valdis.Kletnieks@vt.edu
Subject: Re: Fwd: [PATCH 7/9] ASoC: Blackfin: I2S CPU DAI driver
Cc: "Bryan Wu" <cooloney@kernel.org>, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org, "Cliff Cai" <cliff.cai@analog.com>
In-Reply-To: <38521.1223537753@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1220516528-20301-1-git-send-email-cooloney@kernel.org>
	 <1220516528-20301-8-git-send-email-cooloney@kernel.org>
	 <20080904144343.GB32531@rakim.wolfsonmicro.main>
	 <520f0cf10810082353r2694535evc3edbcb2b3c76796@mail.gmail.com>
	 <520f0cf10810082358t274a46afy7d9c5bbc5ca56de7@mail.gmail.com>
	 <38521.1223537753@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 9, 2008 at 9:35 AM,  <Valdis.Kletnieks@vt.edu> wrote:
> On Thu, 09 Oct 2008 08:58:08 +0200, John Kacur said:
>
>> My eyes fell upon this switch statement, probably I have similar
>> criticisms as to what has already been said, but:
>> 1. Surely the default case is also an -EINVAL
>> 2. Why not let all the EINVALS fall through, it will shorten up the
>> code, and IMO make it more readable, something like this?
>> +       switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
>> +       case SND_SOC_DAIFMT_CBM_CFM: /* Passing Case */
>> +               break;
>> +       case SND_SOC_DAIFMT_CBS_CFS: /* Failing Cases */
>> +       case SND_SOC_DAIFMT_CBM_CFS:
>> +       case SND_SOC_DAIFMT_CBS_CFM:
>> +               ret = -EINVAL;
>> +               break;
>> +       default:
>> +               printk(KERN_INFO "Unknown SND_SOC_DAIFMT kind\n");
>> +               ret = -EINVAL;
>> +               break;
>> +       }
>
> Even shorter, but puts the default in a non-standard place:
>
> +       switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
> +       case SND_SOC_DAIFMT_CBM_CFM: /* Passing Case */
> +               break;
> +       default:                        /* So much Fail we should say something */
> +               printk(KERN_INFO "Unknown SND_SOC_DAIFMT kind\n");
> +       case SND_SOC_DAIFMT_CBS_CFS: /* Failing Cases */
> +       case SND_SOC_DAIFMT_CBM_CFS:
> +       case SND_SOC_DAIFMT_CBS_CFM:
> +               ret = -EINVAL;
> +               break;
> +       }
>
> (I see a checkpatch update to check where default: is, coming in 3.. 2.. 1.. :)
>

Well, of course you only want to make things shorter when it increases
clarity, you don't want to make things shorter for the sake of making
them shorter, so yeah, I would nix that non-standard default position
too.
