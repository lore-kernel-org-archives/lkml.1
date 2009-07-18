Return-Path: <linux-kernel-owner+w=401wt.eu-S1753715AbZGRULU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715AbZGRULU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 16:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753632AbZGRULT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 16:11:19 -0400
Received: from mail-pz0-f194.google.com ([209.85.222.194]:45905 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664AbZGRULT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 16:11:19 -0400
X-Greylist: delayed 68118 seconds by postgrey-1.27 at vger.kernel.org; Sat, 18 Jul 2009 16:11:18 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=MYOZ9a8v+sBHAGLzCDxI2mNxufbl4JgLerpsRoxELE8hOyGPGiYBe1GE8V8a6JnSQo
         0CDdMSwMCL3pIPjTHCbpB6wP5tCOi8U3z30JUyOuRjGMevTaChDagV2oHs3XQSi7qVgp
         UPEPF98zShOo1q464wjaivEuovDWdXF2prhGE=
MIME-Version: 1.0
In-Reply-To: <20090718103756.GA11381@elf.ucw.cz>
References: <43e72e890907141511h70a0a987g57cb26e23e5824a9@mail.gmail.com> 
	<20090714235332.GA1552@ucw.cz> <43e72e890907150851m69cd2de6lfb71596fbfac30e6@mail.gmail.com> 
	<43e72e890907151100j37feb30av7281d09960ca5db2@mail.gmail.com> 
	<20090718103756.GA11381@elf.ucw.cz>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Sat, 18 Jul 2009 13:02:52 -0700
Message-ID: <43e72e890907181302j600506d5oc208167206c44745@mail.gmail.com>
Subject: Re: Generic events for wake up from S1-S4
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>, Jouni Malinen <j@w1.fi>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Stephen Chen <Stephen.Chen@atheros.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 18, 2009 at 3:37 AM, Pavel Machek<pavel@ucw.cz> wrote:
> On Wed 2009-07-15 11:00:07, Luis R. Rodriguez wrote:
>> On Wed, Jul 15, 2009 at 8:51 AM, Luis R. Rodriguez<mcgrof@gmail.com> wrote:
>> > On Tue, Jul 14, 2009 at 4:53 PM, Pavel Machek<pavel@ucw.cz> wrote:
>> >> On Tue 2009-07-14 15:11:45, Luis R. Rodriguez wrote:
>> >>> I'm working on Wake-on-Wireless support for wireless right now [1].
>> >>> Upon wake up I wanted to inform the kernel of the event which caused
>> >>> the wake up but am not clear if there is a generic API for this. Mind
>> >>> you, for WoW we'll need at least some AC power to the card so we'll
>> >>> need to at least be in S3-Hot so we'll only need events for that for
>> >>> now.
>> >>>
>> >>> Do we have some generic infrastructure to gather reasons for wake up
>> >>> from S1-S4 and pass this to userspace yet?
>> >>
>> >> I do not think generic api exists...
>>
>> Going back to this topic -- any suggestions? Will a generic netlink
>> family be OK? Or perhaps easier a udev event for some suitable
>> existing parent ?
>
> Is "who woke me" information even relevant? Yes, it may be interesting
> enough for printk, but... What will userspace do with that information?

Splashy event notification thingies?

I was just trying to avoid verbose debug info for WoW upon wakeup and
figured it be nice to report back through a generic interface.

> Imagine WoW packet comes, 5msec later WoL packet comes, 5msec later
> user opens the lid. You report WoW as wakeup reason, but it is
> inherently "racy".

Hm yeah, but I doubt someone will do that, generally we'd get one wake
up event. Can't we just report the first one and ignore the rest?

> What about simply reporting "wake event happened on this device" and
> doing that for all the devices?

That's fine too. Just think it would be nice to be more specific if possible.

  Luis
