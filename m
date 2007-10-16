Return-Path: <linux-kernel-owner+w=401wt.eu-S935929AbXJPUtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935929AbXJPUtT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 16:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760787AbXJPUtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 16:49:10 -0400
Received: from mga11.intel.com ([192.55.52.93]:32392 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759566AbXJPUtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 16:49:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,284,1188802800"; 
   d="scan'208";a="347941919"
Message-ID: <471523B6.7030506@intel.com>
Date: Tue, 16 Oct 2007 13:48:54 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070911)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Jeremy Katz <katzj@redhat.com>, linux-kernel@vger.kernel.org,
       davej@redhat.com
Subject: Re: [PATCH] Map volume and brightness events on thinkpads
References: <1192481110-9299-1-git-send-email-katzj@redhat.com>	 <20071015210737.GA15293@khazad-dum.debian.net>	 <20071016130053.GA20010@srcf.ucam.org>	 <20071016141153.GA3237@khazad-dum.debian.net>	 <20071016142121.GA21431@srcf.ucam.org>	 <20071016143124.GB3237@khazad-dum.debian.net>	 <20071016144016.GA21749@srcf.ucam.org>	 <20071016165623.GA13643@khazad-dum.debian.net>	 <20071016184606.GB25181@srcf.ucam.org>	 <alpine.LFD.0.999.0710161208340.6887@woody.linux-foundation.org> <d120d5000710161312r5676cad8o60e0790a4e8d5256@mail.gmail.com>
In-Reply-To: <d120d5000710161312r5676cad8o60e0790a4e8d5256@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Oct 2007 20:49:07.0070 (UTC) FILETIME=[FE9751E0:01C81035]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> On 10/16/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>>
>> On Tue, 16 Oct 2007, Matthew Garrett wrote:
>>>> It still doesn't mean it belongs inside the stream of data for the keyboard,
>>>> maskerading as a key press.
>>> But it *is* a key press!
>> To get somewhat back on track: volume and brightness (and similar - lid
>> close etc) events clearly are keypresses.
>>
>> However, I would also argue that a keypress that is acted on by the
>> firmware automatically is *different* from a keypress that hasn't been
>> acted on: one is a "key was pressed *and* hardware did something
>> automatically", and the other is just a "key was pressed" event.
>>
>> IOW, I think the thinkpad issue (and others like it) should be fixed by
>> splitting up the KEY_VOLUMEUP "key" into separate KEY_VOLUMEUP and
>> KEY_VOLUMEUP_NOTIFY key events, so that downstream user mode (and the
>> kernel itself, for that matter) can know whether it's a informational
>> message or whether it should be acted upon.
> 
> I agree that these are 2 different events. My argument is that
> "VOLUME_UP_NOTIFY" event is similar to "BATTERY_OUT_NOTIFY",
> "DOCK_UNDOCK_NOTIFY", etc, etc and should be sent not through input
> layer but through a generic (yet to be designed) notification
> mechanism. Something lighter than input. Something like uevents over
> netlink.

absolutely

real life example: hook up one of those fancy usb keyboards with volume buttons to
your thinkpad. The volume keys on the thinkpad do adjust the volume, the ones on
the USB keyboard do not - software needs to be able to distinguish between them,
and sane defaults for these events need to not overlap.

Cheers,

Auke
