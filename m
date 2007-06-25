Return-Path: <linux-kernel-owner+w=401wt.eu-S1753195AbXFYUUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195AbXFYUUQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 16:20:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751611AbXFYUUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 16:20:04 -0400
Received: from gw02.mail.saunalahti.fi ([195.197.172.116]:47223 "EHLO
	gw02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbXFYUUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 16:20:03 -0400
X-Greylist: delayed 628 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Jun 2007 16:20:03 EDT
Message-ID: <468020F1.1090602@opensound.com>
Date: Mon, 25 Jun 2007 23:09:21 +0300
From: Hannu Savolainen <hannu@opensound.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org
Subject: Handling xruns in OSS (was re:whatever)
References: <Pine.BSO.4.63.0706241943190.25800@rudy.mif.pg.gda.pl>	<20070624200837.16e11305@the-village.bc.nu>	<Pine.BSO.4.63.0706242113530.25800@rudy.mif.pg.gda.pl>	<20070624215724.025a5de5@the-village.bc.nu>	<20070624224411.GB21724@alinoe.com>	<8d6898730706242041q61f56b07kf4dc181fdad4e4dc@mail.gmail.com>	<20070625100618.3653863d@the-village.bc.nu> <s5h8xa8iaee.wl%tiwai@suse.de>
In-Reply-To: <s5h8xa8iaee.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai kirjoitti:
> At Mon, 25 Jun 2007 10:06:18 +0100,
> Alan Cox wrote:
>   
>>> If it is native ALSA driver then it will restart after each underrun
>>> and overrun. It is the applications job to do this, alsa-lib provides
>>> all support for this. I have no idea of OSS and OSS emulation in ALSA.
>>>       
>> OSS should autorestart on underrun and just moan about overruns and drop
>> bits. So if it's not following that behaviour he is IMHO correct for the
>> OSS emulation case.
>>     
>
> I think he is right in the case of read (although I don't remember his
> post as my buffer overran).  The playback is automaically reset and
> restarted at underrun.
>
> But, the patch there is wrong.  It should handle -EPIPE, which means
> XRUN, while -ESTRPIPE means the suspend state.
>   
To be exact the OSS should not even stop the device when a xrun occurs. 
Instead it should keep playing silence until the application writes more 
output data and to discard the oldest recorded data when an overrun 
occurs. This is more effective than stopping and restarting the device.

Best regards,

Hannu
