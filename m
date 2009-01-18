Return-Path: <linux-kernel-owner+w=401wt.eu-S1760874AbZARCHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760874AbZARCHW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 21:07:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757492AbZARCHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 21:07:04 -0500
Received: from wf-out-1314.google.com ([209.85.200.169]:60202 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757540AbZARCHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 21:07:00 -0500
Message-ID: <49728EBF.40401@gawab.com>
Date: Sat, 17 Jan 2009 18:06:55 -0800
From: Justin Madru <jdm64@gawab.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081205)
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: Jesper Juhl <jj@chaosbits.net>, lkml <linux-kernel@vger.kernel.org>,
       John Stoffel <john@stoffel.org>
Subject: Re: 2.6.29-rc1 Firefox crashing on page load
References: <4970F46F.4060803@gawab.com> <49714266.6020401@gawab.com> <49715039.2090406@gmail.com> <49719B53.8050300@gawab.com> <alpine.LNX.2.00.0901172115170.28288@swampdragon.chaosbits.net> <4972489B.30500@gawab.com> <497260FE.4010102@gmail.com> <4972723B.4000201@gawab.com> <49727BDE.9070509@gmail.com>
In-Reply-To: <49727BDE.9070509@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin P. Mattock wrote:
> Justin Madru wrote:
>> Justin P. Mattock wrote:
>>> Justin Madru wrote:
>>>> Ok, more preliminary testing has returned that at least in the case 
>>>> of the iGoogle page crashing, it's related to google talk.
>>>> Because right after it connects to the google talk server the crash 
>>>> happens.
>>>> And why it doesn't crash on firefox 3.2 is because for some reason 
>>>> the talk feature doesn't load on that version of firefox.
>>>> I still get the crashes when going to Preferences->Main or 
>>>> Preferences->Applications.
>>>>
>>>> I tried the suggested moving of .gconf* .gnome* .mozilla*
>>>> The only thing that did was make firefox crash when going to 
>>>> Preference.
>>>> I did not try compiling firefox from source, but I did test with 
>>>> the binaries straight from mozilla.
>>>> I also tried disabling any plugin/extention (I only have flash and 
>>>> AdBlockerPlus), but no change.
>>>>
>>> What I should of said, is to maybe uninstall/disable any of those 
>>> apps or plugins
>>> that are automatically triggered when loading firefox.
>>> (although renaming some of  the  .* files is good, freshens it up);
>>> So when you don't go to google talk you can surf?
>>
>> So far only a connection to talkgadget.google.com or the 2 tabs in 
>> preferences make firefox crash.
>> Other than that I've yet to run into another site that makes it 
>> crash, and can browse just fine.
>> Actually, other than this bug .29-rc2 is running rather nicely ;-)
>>
>> Ok, this time I maded sure I uninstalled/disabled everything I could.
>> Sill.... same results. So, I decided to try something different. Test 
>> with Epiphany.
>> I tried both with the geko and webkit backends.
>> Same results, a crash when going to my iGoogle page that has google 
>> talk applet.
>>
>> But, this time epiphany left an error to the console that gives a 
>> clue to the cause:
>>
>> $ epiphany-webkit                                                ** 
>> (epiphany-webkit:9016): WARNING **: Cannot extract frame (0,0) from 
>> the grid
>> ** (epiphany-webkit:9016): WARNING **: Cannot extract frame (36,0) 
>> from the grid
>> ** (epiphany-webkit:9016): WARNING **: Cannot extract frame (72,0) 
>> from the grid
>> ** (epiphany-webkit:9016): WARNING **: Cannot extract frame (108, 0) 
>> from the grid
>> ** (epiphany-webkit:9016): WARNING **: Cannot extract frame (144, 0) 
>> from the grid
>> ** (epiphany-webkit:9016): WARNING **: Cannot extract frame (180, 0) 
>> from the grid
>> ** (epiphany-webkit:9016): WARNING **: Cannot extract frame (216, 0) 
>> from the grid
>> ** (epiphany-webkit:9016): WARNING **: Cannot extract frame (252, 0) 
>> from the grid
>> console message:  @1: Unsafe JavaScript attempt to access frame with URL
>> http://1.gmodules.com/ig/ifr?view=home&url=http://www.google.com/ig/modules/youtube_igoogle/v2/youtube.xml&nocache=0&up_title=YouTube&up_username=&up_prefs_version=0&up_search_channels=0&up_search_channel_name0=&up_search_channel_url0=&up_search_channel_name1=&up_search_channel_url1=&up_search_channel_name2=&up_search_channel_url2=&up_current_channel_id=0&up_rawQuery=&up_channel_url_to_preload=http://gdata.youtube.com/feeds/api/standardfeeds/US/recently_featured%3Falt%3Djson&lang=en&country=us&.lang=en&.country=us&synd=ig&mid=1&ifpctok=-8098139156870189641&parent=http://www.google.com&extern_js=/extern_js/f/CgJlbhICdXMrMBU4ACw/BrDZK7EjJT4.js 
>>
>> from frame with URL
>> http://www.google.com/ig/ifpc_relay#%22remote_iframe_1%22&0&1&0&%22%2522remote_iframe_1%2522%26%2522resize_iframe%2522%26%2522%2522%26%2522%2522%26%2522remote_iframe_1%2522%26369%26%25221%2522%22&true. 
>>
>> Domains, protocols and ports must match.
>> console message:  @1: Unsafe JavaScript attempt to access frame
>> with URL http://www.google.com/ig from frame with URL
>> http://talkgadget.google.com/talkgadget/mole?id=gth-hover-card&hl=en#id=gth-hover-card. 
>>
>> Domains, protocols and ports must match.
>> console message:  @1: Unsafe JavaScript attempt to access frame
>> with URL http://www.google.com/ig from frame with URL
>> http://talkgadget.google.com/talkgadget/blank. Domains,
>> protocols and ports must match.
>> Segmentation fault
>>
>> So, it's complaining about matching domains, protocols and ports.
>> Henceforth, I would surmise that the bug is related to the network code?
>>
>> Justin Madru
>>
> Well positive side is you can at least  grab youre news and info.
> bad side is you can't access igoogle(or whatever it's called).
>
> Domains, protocols and ports must match.
> probably the culprit(if you found the correct location
> that's causing this);
>
> regards;
>
> Justin P. Mattock
>
It's only half positive because I use the google rss reader of igoogle.
Unfortunately, there's the stupid google talk app that won't go away, 
that causes the crash!
But I can fortunately use firefox 3.2 because google talk says it 
doesn't support that browser and doesn't load.

I'll do a git bisect if I can, and report back in a few days.

Justin Madru
