Return-Path: <linux-kernel-owner+w=401wt.eu-S1755575AbZGOPwG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbZGOPwG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 11:52:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755050AbZGOPwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 11:52:06 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:43341 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307AbZGOPwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 11:52:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=HeZOMtJ6MfuKRk2jt6jDslBCZJahId9xF8J9cxLNVwQntLqjX/UoonPXBxXLtb+DZG
         J+NUNKAhNPJK+jt0vQB7vLU2cWSlY88qiJkWLtiZG1zkdD7KYkC/ECbf2zBtuCtwwKvd
         JSDMmZYNWc1wMuZFn9gdV1yq+XAcecGY1kSt8=
MIME-Version: 1.0
In-Reply-To: <20090714235332.GA1552@ucw.cz>
References: <43e72e890907141511h70a0a987g57cb26e23e5824a9@mail.gmail.com> 
	<20090714235332.GA1552@ucw.cz>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 15 Jul 2009 08:51:43 -0700
Message-ID: <43e72e890907150851m69cd2de6lfb71596fbfac30e6@mail.gmail.com>
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

On Tue, Jul 14, 2009 at 4:53 PM, Pavel Machek<pavel@ucw.cz> wrote:
> On Tue 2009-07-14 15:11:45, Luis R. Rodriguez wrote:
>> I'm working on Wake-on-Wireless support for wireless right now [1].
>> Upon wake up I wanted to inform the kernel of the event which caused
>> the wake up but am not clear if there is a generic API for this. Mind
>> you, for WoW we'll need at least some AC power to the card so we'll
>> need to at least be in S3-Hot so we'll only need events for that for
>> now.
>>
>> Do we have some generic infrastructure to gather reasons for wake up
>> from S1-S4 and pass this to userspace yet?
>
> I do not think generic api exists...
>
> How does it work?

I tried to brain dump as much as I could on the WoW wiki page [1]. In
essence we send keep alive messages (null data frames) and since we're
in PS mode the AP buffers the frames for us. At least for Atheros
ath9k devices we don't have any option but to not process any frames
sent to us from the AP except for WoW hardware processing. For WoW we
have a few triggers, with user patterns we can customize a wakeup upon
ARP requests, for example, but right now I've only enabled and tested
Magic Packet.

> I thought that wifi stack is in software -> you need
> main cpu to run for wifi to work?

Yes, but we are not processing 802.11 frames for data processing and
sending them up to any higher layer, we're just doing raw hardware
pattern matching and event triggering. This of course also means
devices which do not a CPU or a CPU but no special WoW firmware that
you won't be able to use WPA for group key stuff for example for which
I do believe we do need the box's CPU. Which reminds me, maybe we
should not allow WoW for that case for now.

> ...and what are the applications?

Same as with Ethernet, only difference this is 802.11. Also not all
Ethernet drivers support WoL.

> I understand that WoL is useful for
> remote administration of connected desktops.

Sure, I for instance want to be able to use WoL and WoW to power up my
machines at home when I walk in and my Android associates to my AP.
Some devices may be connected through Ethernet some not.

>> [1] http://wireless.kernel.org/en/users/Documentation/WoW

  Luis
