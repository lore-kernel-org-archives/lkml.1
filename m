Return-Path: <linux-kernel-owner+w=401wt.eu-S1755441AbYGRJ0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbYGRJ0h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 05:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753369AbYGRJ0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 05:26:30 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:42018 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbYGRJ03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 05:26:29 -0400
Date: Fri, 18 Jul 2008 02:20:42 -0700 (PDT)
From: Trent Piepho <tpiepho@freescale.com>
X-X-Sender: xyzzy@t2.domain.actdsltmp
To: Anton Vorontsov <avorontsov@ru.mvista.com>
cc: Grant Likely <grant.likely@secretlab.ca>,
       Richard Purdie <rpurdie@rpsys.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Kumar Gala <galak@kernel.crashing.org>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH v3] leds: implement OpenFirmare GPIO LED driver
In-Reply-To: <20080717234201.GA15745@polina.dev.rtsoft.ru>
Message-ID: <Pine.LNX.4.64.0807171807420.29856@t2.domain.actdsltmp>
References: <1216133032.5345.73.camel@dax.rpnet.com>
 <20080715151917.GA30607@polina.dev.rtsoft.ru> <Pine.LNX.4.64.0807161546010.12709@t2.domain.actdsltmp>
 <20080717041531.GA27243@secretlab.ca> <20080717140519.GA32617@polina.dev.rtsoft.ru>
 <20080717141335.GA2219@polina.dev.rtsoft.ru> <20080717150422.GC31932@secretlab.ca>
 <20080717152006.GA26120@polina.dev.rtsoft.ru>
 <fa686aa40807171105m22dda41dqb334dd5f7b2634d8@mail.gmail.com>
 <Pine.LNX.4.64.0807171302190.27902@t2.domain.actdsltmp>
 <20080717234201.GA15745@polina.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jul 2008, Anton Vorontsov wrote:
> On Thu, Jul 17, 2008 at 01:18:18PM -0700, Trent Piepho wrote:
>> Basically what I did then in my patch then, refactor leds-gpio so most of
>> it is shared and there is a block of code that does platform binding and
>> another block that does of_platform binding.
>
> Ok. I must admit I'm quite burned out with OF gpio-leds. I was posting the
> bindings since April, probably four or five times. Last time a week ago,
> IIRC.
>
> During the months I received just a few replies, one from Grant ("Looks
> good to me."), few from Segher (with a lot of criticism, that I much
> appreciated and tried to fix all spotted issues), and one from Laurent
> (about active-low LEDs).

I'm sorry, I never saw those emails.  Were they all to linuxppc-dev?  I hate
reading that list, gmane, marc, and lkml.org don't archive it and
mail-archive.com isn't nearly as nice.

Is this the last version?
http://www.mail-archive.com/linuxppc-dev@ozlabs.org/msg18355.html

Why did you get rid of "linux,default-trigger" and the active-low property? 
I couldn't find any discussion about this.  When I first saw your current
patch I was going to add them, but I see you already had them and then
removed them.

I'd like to replace my "led-hack" stg patch with this, but I need
default-trigger to do that.  I don't need active-low or default-brightness,
but they seem like a good idea.  Actually, if you look closely at the patch
I posted, you'll see I had modified the existing leds-gpio driver to add a
default-brightness feature, though I don't need it anymore.  The requirement
changed from having an led on during kernel boot to having it flash.  I
have another hack for that, since there is no way to pass parameters to a
trigger.

>> leds {
>>  	compatible = "gpio-led";
>>  	led@6 {
>>  		gpios = <&mpc8572 6 0>;
>>  		label = "red";
>>  	};
>>  	led@7 {
>>  		gpios = <&mpc8572 7 0>;
>>  		label = "green";
>>  	};
>> };
>
> I like this. Or better what Grant suggested, i.e. move label to node
> name.

Ok, I used that.  It's like the new way partitions are defined in NOR flash
OF bindings.  My first example was more like the old way.  The led name can
come from a label property or if there is none then the node name is used. 
I don't think you can have colons or spaces in node names.  I don't have a
default trigger property, but I'd really like to have that.  I could add an
active low flag too.  Maybe compatible should be "gpio-leds", since you can
define more than one?

The patch is done and works for me.  One can select platform device and/or
of_platform device support via Kconfig.  I'll port it to the git kernel and
post it soon.
