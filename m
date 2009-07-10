Return-Path: <linux-kernel-owner+w=401wt.eu-S1755322AbZGJPZL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322AbZGJPZL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 11:25:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbZGJPYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 11:24:55 -0400
Received: from mail-qy0-f193.google.com ([209.85.221.193]:36964 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbZGJPYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 11:24:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=QWQV60GbW7O0BFXVASCaGDacEF5+5sLAM6TAMFn2bK4vSdJ4lsCACl7ujaDmhtwA2n
         Nus0kFBkFwjuhUgghaRYPjnKrZvufoZ6yGbXYikECdSG2snA5K/51xy4FJcMfjqZW+BU
         kF/v2FD3aaN0Y1RdILOTGZYA/9OqeiWw8UyCQ=
MIME-Version: 1.0
In-Reply-To: <200907101343.14113.elendil@planet.nl>
References: <200907082340.07787.elendil@planet.nl> <200907090311.40205.elendil@planet.nl> 
	<43e72e890907081907j279f48eep99e73cc2951dfdb@mail.gmail.com> 
	<200907101343.14113.elendil@planet.nl>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 10 Jul 2009 08:24:32 -0700
Message-ID: <43e72e890907100824o1a4116aeh6e4d28aa504b29cc@mail.gmail.com>
Subject: Re: [regression] ath5k: Overrides regulatory domain set for cfg80211
To: Frans Pop <elendil@planet.nl>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 10, 2009 at 4:43 AM, Frans Pop<elendil@planet.nl> wrote:

>> >> For further information please also read
>> >> Documentation/feature-removal-schedule.txt. Please use a valid
>> >> ISO-3166 alpha2 country code, I also advise to abandon the usage of
>> >> the ieee80211_regdom module parameter which we do eventually intend
>> >> on deprecating and if you know anyone using that please suggest the
>> >> same.
>> >
>> > As mentioned above I do not currently have the option of abandoning
>> > it.
>>
>> Yes you do, but you don't seem to want to do anything beyond what your
>> distribution offers, which is different.
>
> You're right :-)
> However, I am also a Debian Developer and Debian may (just as we did for
> Etch), at some point want to offer a newer kernel than the current .26
> for stable (possibly .31).

That'd be nice!

> From that PoV it is important to ensure there
> are no incompatibilities with what's in Debian stable.

And there shouldn't be.

Side note:

I'd suggest to disable OLD_REG and provide crda and iw on your shiny
new kernel. In the absence of crda you still have a really good world
regulatory domain with good world roaming capabilities. For setting
the regulatory domain you can look at what Fedora folks did with the
timezone info until the desktop catches up (geoclue and whatever).

> For that reason I am very conservative when it comes to installer newer or
> backported versions of packages.

Sure.

>> > That seems particularly bad in my case. For some weird reason this
>> > Trust PCMCIA card seems to have AM in its EEPROM, which is Armenia...
>> > The card was bought in the Netherlands (NL), which is also where I
>> > live.
>>
>> Yeah the short story of that is Armenia and Netherlands both have the
>> same regulatory rules, the first alpha2 that matched the same group
>> was picked up, which just so happened to be Armenia. In the future it
>> will be easier if cards are just programmed with the alpha2 country
>> code or with a world regulatory domain code, and just abandon the
>> grouping idea. That is something we will have to look forward to
>> change and promote for future device. What counts for regulatory
>> purposes is your device is complaint. The alternative was to keep all
>> the regulatory information statically in the kernel for each
>> regulatory group for Atheros devices.
>
> Ah! I had no idea about that and I guess that this is the real issue here:
> a simple usability problem. If I had seen the correct countrycode (NL
> instead of AM), I probably never would have reported a regression. What
> prompted my mail was that, from a user PoV, the country being selected
> looked to be completely broken. How am I, as a simple user, supposed to
> know that Armenia uses the same domain as the Netherlands and that what
> the driver is doing is actually 100% correct (and even that my PCMCIA
> card is not as broken as I thought)?

Yeah, its a good point.

> Would it be possible to improve the info presented by the kernel? Maybe
> print an extra line with a list of countries that use the selected reg
> domain (depends I guess on what's the max. nr. of countries that share a
> domain). Or at least indicate that the country code is a somewhat random
> choice.

Perhaps an informative "group regulatory domain" printk may make
sense, you're right.

>> > I can to some extend understand respecting hardware settings for APs,
>> > but for a wireless NIC it seems a useless limitation.
>>
>> You are right to a certain degree. The thing is wireless cards *can*
>> be used as APs on a regular desktops. Perhaps not with iwlagn, but
>> with ath5k and ath9k you can do AP, IBSS, Mesh, all of which actually
>> do start transmit with out any AP being around. For these cases you
>> *do* need to ensure proper regulatory compliance. And we haven't even
>> touched on DFS!
>
> Well, IIUC you do know what mode the card is being used in, so in theory
> you could distinguish between them. I'm not pushing for that though.
>
> End conclusion is that there is no regression and no backwards
> compatibility issue (which is good news), just a usability issue.

Yup.

  Luis
