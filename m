Return-Path: <linux-kernel-owner+w=401wt.eu-S1755848AbYFBEoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848AbYFBEoc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 00:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751311AbYFBEoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 00:44:25 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:21053 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbYFBEoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 00:44:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PqqAbm5ydIJdnVHlSdkeuagrRM4NyKBPYr1/wWIAHsXxBso7DhblokK3L81KtpLwSkQ/6Ju7UTHHO6Fhc0nAu/1OuIYERPUPeg6W8bP+ZNLpAZigUkr72J5ya/5UEb8AWM3DfhBeV9DCmFP2tQTTS8182T3azppvGC2yEAIBYfg=
Message-ID: <dd18b0c30806012144ncd458f3jdeb1336e9082948d@mail.gmail.com>
Date: Mon, 2 Jun 2008 04:44:23 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: BUG kmalloc-2048: Poison overwritten
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080601211536.1e3ba47c@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30806011613l6c8c1863rd237f7de06a6b33a@mail.gmail.com>
	 <20080601190138.4d86dc66@infradead.org>
	 <dd18b0c30806012053q27b00fd6p40fa63bcb4bb19a3@mail.gmail.com>
	 <20080601211536.1e3ba47c@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 2, 2008 at 4:15 AM, Arjan van de Ven <arjan@infradead.org> wrote:
> On Mon, 2 Jun 2008 03:53:43 +0000
> "Justin Mattock" <justinmattock@gmail.com> wrote:
>
>> On Mon, Jun 2, 2008 at 2:01 AM, Arjan van de Ven
>> <arjan@infradead.org> wrote:
>> > On Sun, 1 Jun 2008 23:13:51 +0000
>> > "Justin Mattock" <justinmattock@gmail.com> wrote:
>> >
>> >> I received this after the second simultaneous suspend: (I will try
>> >> and see if this is re creatable or not)
>> >>
>> >> [  232.270737] BUG: unable to handle kernel paging request at
>> >> 6b6b6c6b
>> >
>> > bad bad bad
>> >
>> >
>> >> [  232.270743] IP: [<c013f96d>] module_put+0x12/0x2b
>> >> [  232.270750] *pde = 00000000
>> >> [  232.270753] Oops: 0002 [#1] SMP
>> >> [  232.270757] Modules linked in: hci_usb cpufreq_ondemand
>> >> cpufreq_performance cpufreq_powersave rfcomm hidp l2cap bluetooth
>> >> fan ipmi_watchdog ipmi_msghandler uinput wlan_tkip
>> >> ieee80211_crypt_tkip ieee80211_crypt arpt_mangle arptable_filter
>> >> arp_tables nf_conntrack_ipv4 nf_conntrack iptable_mangle
>> >> iptable_filter ip_tables x_tables intelfb i2c_i810 i2c_algo_bit
>> >> coretemp eeprom acpi_cpufreq fglrx(P) applesmc joydev uvcvideo
>> >> appletouch wlan_scan_sta
>> >   ^^^^^
>> >
>> > naughty
>> >
>> >> ath_rate_sample firewire_ohci firewire_core snd_hda_intel ath_pci
>> >> snd_pcm wlan ohci1394 intel_agp evdev ath_hal(P) snd_timer ieee1394
>> >                                        ^^^^^^^^^^
>> >
>> > worse
>> >
>> >
>> >> Hopefully this is nothing serious,
>> >> regards;
>> >
>> > actually it's very serious, something is scribbling all over your
>> > memory, it's just a matter of time before that overwrites something
>> > important on your filesystem, and then you have a high risk of
>> > losing most of your data.
>> >
>> > However, since  you're using 2 proprietary kernel modules, you
>> > really ought to contact the vendors for those modules for support;
>> > they're a very likely cause for problems
>> > (for example, these two are the cause for the number 1, 2, 5 and 7
>> > of the top 10 kernel oopses/crashes for the last week)
>> >
>> >
>> >
>> great!!!  Well The problem I have with these modules is A) madwifi
>> "waiting until support is in the kernel for this one,
>
> you mean the ath5k driver which already is in the kernel?
> If it doesnt work for you, have you filed a bugzilla ?
>
>> for now I
>> just have to deal with risking loosing any data". B) graphics driver I
>> can unload the driver but then loose suspend to mem "argh!!"
>
> A current ATI driver in X.org ought to be close to getting this one
> right.
>
>> aside from that, I just performed the test again of simultaneously
>> suspending to memory and didn't receive this message,
>
> sure the corruption this time wasn't in a redzone.. but maybe elsewhere.
>
>> so now I'm at a
>> lost for words as to what is happening. The positive side is there
>> isn't any important data on my system i.g. important doc's etc..., but
>>
>
> good luck.
>
>
> --
> If you want to reach me at my work email, use arjan@linux.intel.com
> For development, discussion and tips for power savings,
> visit http://www.lesswatts.org
>

Thanks for the help: if the new athk5 supports model AR5418 then I'm a
go for that,
As for the rest of the issues "nice, now you have me freaked out," "I
guess I'll have to use OSX," but then If I do
I'll have to listen to this voice in my head saying " use Linux" "go
ahead Justin use Linux" "come on what are you chicken",
kind of like putting you're full day's worth of work in; and driving
on the 405, Then all of a sudden having a voice tell you
to go grab a nice cold refreshment(B$%^r)
regards;

-- 
Justin P. Mattock
