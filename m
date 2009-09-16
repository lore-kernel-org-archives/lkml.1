Return-Path: <linux-kernel-owner+w=401wt.eu-S1760142AbZIPV1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760142AbZIPV1f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 17:27:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760051AbZIPV12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 17:27:28 -0400
Received: from mail.cs.nmsu.edu ([128.123.64.3]:54875 "EHLO mail.cs.nmsu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760129AbZIPV11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 17:27:27 -0400
Message-ID: <478a4bd7c3e55ea219f5c808f5c571e1.squirrel@intranet.cs.nmsu.edu>
In-Reply-To: <20090916021922.GA1627@khazad-dum.debian.net>
References: <aac07123ee2b14a0ac25d1652dbe0780.squirrel@intranet.cs.nmsu.edu>
    <5d5443650909151011k4b21a6d0n28ac6142c3d7161d@mail.gmail.com>
    <20090915183406.GA5696@core.coreip.homeip.net>
    <0debc76f26fe85e28adf642396233928.squirrel@intranet.cs.nmsu.edu>
    <20090916021922.GA1627@khazad-dum.debian.net>
Date: Wed, 16 Sep 2009 15:27:27 -0600
Subject: Re: Using EV_MSC or extending KEY_*
From: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
To: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
Cc: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
       "Trilok Soni" <soni.trilok@gmail.com>,
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

Henrique de Moraes Holschuh wrote:
> On Tue, 15 Sep 2009, Rick L. Vinyard, Jr. wrote:
>> As I understand it the EV_MSC/MSC_SCAN is used to trigger a prompting of
>> the user to map a key, which would be useful for the G1-G22 keys and
>> perhaps 5 of the 10 special keys. But, that's not the behavior I want
>> for
>> the M1, M2, M3, MR and backlight keys.
>
> Why?
>
>> Somehow they need to be distinct from any existing KEY_* codes or not
>> have
>> a code at all... i.e. only emitting the raw misc events.
>
> Use KEY_RESERVED for them and in your driver, special case it to not
> output
> EV_KEY events for KEY_RESERVED, but still output the EV_MSC/MSC_SCAN.

That's how I ended up writing it.

> This allows userspace to reprogram them to normal keys (or even to
> KEY_UNKNOWN) if it wants.
>
>> Perhaps the BTN_MISC codes are better suited for these keys?
>
> That could work too, but are these generic buttons?

Yes. There is a bank of 6 buttons across the top (just beneath the LCD
display). Their purpose is application specific, but their physical
location provides an opportunity for UI's to use them in correlation with
the displayed LCD image... i.e. as an option selector, mode changer, etc.

The four M* keys are just beneath the bank of buttons.

---

Rick


