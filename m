Return-Path: <linux-kernel-owner+w=401wt.eu-S1758559AbYBDXSM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758559AbYBDXSM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 18:18:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756731AbYBDXR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 18:17:58 -0500
Received: from de01egw01.freescale.net ([192.88.165.102]:41364 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755772AbYBDXR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 18:17:58 -0500
Message-ID: <47A79D09.6090806@freescale.com>
Date: Mon, 04 Feb 2008 17:17:29 -0600
From: Timur Tabi <timur@freescale.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Roel Kluin <12o3l@tiscali.nl>, Timur Tabi <timur@freescale.com>,
       liam.girdwood@wolfsonmicro.com, alsa-devel@alsa-project.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH][sound/soc/fsl/mpc8610_hpcd.c] duplicate
 strcasecmp test for "rj-master" in mpc8610_hpcd_probe()
References: <47A77EB2.6070703@tiscali.nl> <20080204231114.GA7842@sirena.org.uk>
In-Reply-To: <20080204231114.GA7842@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> On Mon, Feb 04, 2008 at 10:08:02PM +0100, Roel Kluin wrote:
>> In linus' git tree I found this problem. Is it also in the alsa tree?
>> please confirm it's the right fix. The patch was not yet tested.
> 
> Timur, this looks like a good catch?

Yes, thank you!  The change below should be made.

> 
>> --
>> duplicate test for "rj-master"
>>
>> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
>> ---
>> diff --git a/sound/soc/fsl/mpc8610_hpcd.c b/sound/soc/fsl/mpc8610_hpcd.c
>> index f26c4b2..a00aac7 100644
>> --- a/sound/soc/fsl/mpc8610_hpcd.c
>> +++ b/sound/soc/fsl/mpc8610_hpcd.c
>> @@ -314,9 +314,9 @@ static int mpc8610_hpcd_probe(struct of_device *ofdev,
>>  	} else if (strcasecmp(sprop, "lj-master") == 0) {
>>  		machine_data->dai_format = SND_SOC_DAIFMT_LEFT_J;
>>  		machine_data->codec_clk_direction = SND_SOC_CLOCK_IN;
>>  		machine_data->cpu_clk_direction = SND_SOC_CLOCK_OUT;
>> -	} else if (strcasecmp(sprop, "rj-master") == 0) {
>> +	} else if (strcasecmp(sprop, "rj-slave") == 0) {
>>  		machine_data->dai_format = SND_SOC_DAIFMT_RIGHT_J;
>>  		machine_data->codec_clk_direction = SND_SOC_CLOCK_OUT;
>>  		machine_data->cpu_clk_direction = SND_SOC_CLOCK_IN;
>>  	} else if (strcasecmp(sprop, "rj-master") == 0) {
> _______________________________________________
> Alsa-devel mailing list
> Alsa-devel@alsa-project.org
> http://mailman.alsa-project.org/mailman/listinfo/alsa-devel
> 


-- 
Timur Tabi
Linux kernel developer at Freescale
