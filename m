Return-Path: <linux-kernel-owner+w=401wt.eu-S1755828AbYJJFEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828AbYJJFEx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 01:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbYJJFEm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 01:04:42 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:10597 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbYJJFEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 01:04:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=WPh3i+Ul2xC1NrHxscOUcWlR8Y4b80wO2fZ3XhepDNzzr501swGvx4NJ3e4FkHcsdw
         SZjiAo8Pg/nZZNEUY0rG3kSdFyDZYYaSGCODBk4CZYpsny2AyMK3IqSeXlwv+4GMSSpP
         wKP//RsYnzbdwAtqF0nOU9B+4b3A3KbHpEyOE=
Message-ID: <9e4733910810092204wbe6dd7dgde9c7ee50f698309@mail.gmail.com>
Date: Fri, 10 Oct 2008 01:04:40 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Jarod Wilson" <jarod@wilsonet.com>
Subject: Re: [RFC PATCH 0/4] V3 - Implementation of IR support using the input subsystem
Cc: "Pavel Machek" <pavel@suse.cz>, lirc-list@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <1223611899.13345.86.camel@xavier.wilsonet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081006194032.15992.8393.stgit@terra>
	 <20081009120333.GA1623@ucw.cz>
	 <1223611899.13345.86.camel@xavier.wilsonet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2008 at 12:11 AM, Jarod Wilson <jarod@wilsonet.com> wrote:
> On Thu, 2008-10-09 at 14:03 +0200, Pavel Machek wrote:
>> Hi!
>>
>> >  What should the IR API look like?  How are IR events mapped into
>> > keyboard events? Should they be mapped? Map them in the kernel or in
>> > user space? The maps are tiny, less than 1K per remote.  Sysfs can
>> > be used to load maps into the kernel driver. Make maps only for the
>> > common buttons and don't map unusual ones?
>>
>> Map them in kernel, in analogy with normal keyboards.
>
> My thought was to basically follow what the ati_remote{,2} driver does.
>
>> > How should multiple remotes be handled? Split them out into
>> > individual input devices, or group them onto a single IR device? I
>> > can implement either.
>>
>> Individual input devices, I'd say... so that app can only listen for
>> 'its' remote.
>
> I don't quite get it. How can we tell there are multiple remotes to set
> up multiple input devices when the system comes up? All we can know
> about at driver init time is the receiver(s), no? Or would this be keyed
> off a config file? Or ______ ?


We could create a sysfs attribut named ir_config. For each config file
you copy to it it creates a new input device. The config files have
lists of map this protocol, device, command tuple to this key. When a
remote button is pressed the raw codes are fed to the in-kernel
protocol engine. That engine turns the raw codes into tuples. Tuples
are matched against the configs that have been loaded until a hit is
found. If no hit they get sent out the catch-all device.

Most remotes send out unique codes, they have to or they would turn on
unintended devices.


>
>
> --
> Jarod Wilson
> jarod@wilsonet.com
>
>



-- 
Jon Smirl
jonsmirl@gmail.com
