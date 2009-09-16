Return-Path: <linux-kernel-owner+w=401wt.eu-S1760133AbZIPV1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760133AbZIPV1M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 17:27:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760051AbZIPV1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 17:27:10 -0400
Received: from mail.cs.nmsu.edu ([128.123.64.3]:54844 "EHLO mail.cs.nmsu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760048AbZIPV1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 17:27:08 -0400
Message-ID: <2c0ac825ebe78da99328b896faae04a2.squirrel@intranet.cs.nmsu.edu>
In-Reply-To: <20090916034642.GC2756@core.coreip.homeip.net>
References: <aac07123ee2b14a0ac25d1652dbe0780.squirrel@intranet.cs.nmsu.edu>
    <5d5443650909151011k4b21a6d0n28ac6142c3d7161d@mail.gmail.com>
    <20090915183406.GA5696@core.coreip.homeip.net>
    <0debc76f26fe85e28adf642396233928.squirrel@intranet.cs.nmsu.edu>
    <20090916034642.GC2756@core.coreip.homeip.net>
Date: Wed, 16 Sep 2009 15:27:11 -0600
Subject: Re: Using EV_MSC or extending KEY_*
From: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Cc: "Trilok Soni" <soni.trilok@gmail.com>,
       "Linux USB" <linux-usb@vger.kernel.org>,
       "LKML" <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> On Tue, Sep 15, 2009 at 01:05:57PM -0600, Rick L. Vinyard, Jr. wrote:
>> Dmitry Torokhov wrote:
>> > On Tue, Sep 15, 2009 at 10:41:30PM +0530, Trilok Soni wrote:
>> >> Adding linux-input.
>> >>
>> >> On Tue, Sep 15, 2009 at 9:49 PM, Rick L. Vinyard, Jr.
>> >> <rvinyard@cs.nmsu.edu> wrote:
>> >> > On the Logitech G13 there are a set of 10 special keys at the top
>> of
>> >> the
>> >> > device.
>> >> >
>> >> > I've written the driver so that it maintains a map from the general
>> >> keys
>> >> > (G1-G22) to Linux' input subsystem keys.
>> >> >
>> >> > The map can be changed on the fly, allowing multiple keymaps to be
>> >> loaded.
>> >> >
>> >> > As a side note I haven't provided for this functionality (multiple
>> >> > keymaps) in the driver since this can be maintained from userspace,
>> >> but it
>> >> > does need to know about the currently loaded keymap so that when
>> the
>> >> raw
>> >> > HID events are parsed the appropriate EV_KEY events can be input.
>> >> >
>> >> > I could set it up so that the special keys also map to a KEY_*
>> code.
>> >> > However, I'd prefer to set things up so that any G1-G22 key can be
>> >> mapped
>> >> > to any input subsystem KEY_* code and not reserve a set of 10 from
>> the
>> >> > current KEY_* codes for the 10 special keys.
>> >> >
>> >> > One way I was thinking of approaching this was to generate EV_MSC
>> type
>> >> > events (with a MSC_RAW code) using the value to indicate the state
>> >> > (pressed/released) and special key.
>> >
>> > Doesn't HID already generate EV_MSC/MSC_SCAN for exactly this purpose
>> > so userspace knows what keys can be remapped? You may initially map
>> all
>> > keys you don't know the usage to KEY_UNKNOWN.
>>
>> As I understand it the EV_MSC/MSC_SCAN is used to trigger a prompting of
>> the user to map a key, which would be useful for the G1-G22 keys and
>> perhaps 5 of the 10 special keys. But, that's not the behavior I want
>> for
>> the M1, M2, M3, MR and backlight keys.
>>
>> Somehow they need to be distinct from any existing KEY_* codes or not
>> have
>> a code at all... i.e. only emitting the raw misc events.
>>
>> Perhaps the BTN_MISC codes are better suited for these keys?
>>
>
> I am sorry, I don't follow... why would yo not want to assign a standard
> code to the M* keys?
>
> --
> Dmitry

The M* keys are intended to provide a quick way to switch between key
mappings, with each mode having their own user-defined mappings.

So, if it is intended for the user to potentially program any of the G*
keys to anything within the set of existing keys (KEY_*, BTN_*) then the
M* keys need something outside that set to signal their events.

That's why I was thinking that EV_MSC/MSC_RAW could encode both the key
and the state (Pressed/Released) outside the set of existing keys.

---

Rick


