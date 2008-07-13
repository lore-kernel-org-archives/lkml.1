Return-Path: <linux-kernel-owner+w=401wt.eu-S1754196AbYGMGjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbYGMGjn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 02:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbYGMGjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 02:39:35 -0400
Received: from mail.dunaweb.hu ([81.17.184.3]:47639 "EHLO mail.dunaweb.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475AbYGMGjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 02:39:35 -0400
Message-ID: <4879A325.4040501@dunaweb.hu>
Date: Sun, 13 Jul 2008 08:39:33 +0200
From: Zoltan Boszormenyi <zboszor@dunaweb.hu>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Mickey mouse voices on snd-intel8x0
References: <486677F7.6080004@dunaweb.hu> <s5hskurs5nw.wl%tiwai@suse.de>
In-Reply-To: <s5hskurs5nw.wl%tiwai@suse.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai írta:
> At Sat, 28 Jun 2008 19:42:15 +0200,
> Zoltan Boszormenyi wrote:
>   
>> Hi,
>>
>> I have a Compaq Deskpro EN with PIII/866 recycled as a thin client.
>> The problem was that sound on the thin client was played faster than it
>> should.
>> I have Fedora 9/x86-64 on the main machine, so the thin client is LTSP5
>> that comes with F9.
>> I tried everything (acpi=off, etc) but the strange voice didn't get better.
>> I discovered this in the dmesg:
>>     
>
> Did this problem exist on the earlier kernel?
>   

IIRC, yes.
When I have set up LTSP5, both the client and the host had a 2.6.24.x
kernel.
Don't ask the exact version, though.

>> intel8x0_measure_ac97_clock: measured 50895 usecs
>> intel8x0: measured clock 78 rejected
>>     
>
> This value is way too small than normal.  It means that either the
> clocking or the calculation of the position in
> intel8x0_measure_ac97_clock() is wrong.  Could you check what is the
> value if ichdev->position in that function?
>   

How? Is there a module option for such debug info?

>> intel8x0: clocking to 48000
>>
>> I looked at the current kernel sources and found the solution for that.
>> I had to provide this for the thin client in
>> /opt/ltsp/i386/etc/modprobe.conf :
>>
>> options snd-intel8x0 ac97_clock=44100
>>     
>
> Usually it's a bit slower than that.  See
> Documentation/sound/alsa/ALSA-Configuration.txt.
>   

Thanks.

>
> thanks,
>
> Takashi
>
>   

