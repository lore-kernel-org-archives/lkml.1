Return-Path: <linux-kernel-owner+w=401wt.eu-S1753351AbYKZTMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351AbYKZTMT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 14:12:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbYKZTMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 14:12:08 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:14128 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571AbYKZTMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 14:12:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=V0bzJQlL/YJsQuL07qqclHztg98XoNsBXJTCw2mj30Nsk2NI6uFOkSwAKz08tjU+if
         FbWsVHQtrUHcuBQXTurSU2TBaBeHhpADTjgeL9EEVeCRm7JF3ioLxWaO6WOwg+v4268i
         CEo5905cgMhLeleW928IxF7Tl0Ha+R4xHh/KU=
Message-ID: <c8b4dbe10811261112w6cbbec73mb468870f206d9f97@mail.gmail.com>
Date: Wed, 26 Nov 2008 19:12:04 +0000
From: "Aidan Thornton" <makosoft@googlemail.com>
To: "Markus Rechberger" <mrechberger@gmail.com>
Subject: Re: [PATCH 1/7] Adding empia base driver
Cc: "Greg KH" <greg@kroah.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       em28xx <em28xx@mcentral.de>, acano@fastmail.fm,
       "Andre Kelmanson" <akelmanson@gmail.com>,
       "Bouwsma Barry" <freebeer.bouwsma@gmail.com>,
       "Dan Kreiser" <kreiser@informatik.hu-berlin.de>,
       "Frank Neuber" <fn@kernelport.de>,
       "Jelle de Jong" <jelledejong@powercraft.nl>,
       "John Stowers" <john.stowers.lists@gmail.com>,
       "Lukas Kuna" <lukas.kuna@evkanet.net>,
       "Stefan Vonolfen" <stefan.vonolfen@gmail.com>,
       "Stephan Berberig" <s.berberig@arcor.de>,
       "Thomas Giesecke" <thomas.giesecke@ibgmbh-naumburg.de>,
       "Vitaly Wool" <vwool@ru.mvista.com>, "Zhenyu Wang" <zhen78@gmail.com>
In-Reply-To: <d9def9db0810221524m738b838bs681c0b9159531c64@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d9def9db0810221414w5348acf3re31a033ea7179462@mail.gmail.com>
	 <20081022220903.GA15278@kroah.com>
	 <d9def9db0810221524m738b838bs681c0b9159531c64@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/08, Markus Rechberger <mrechberger@gmail.com> wrote:
> On Thu, Oct 23, 2008 at 12:09 AM, Greg KH <greg@kroah.com> wrote:
>> On Wed, Oct 22, 2008 at 11:14:36PM +0200, Markus Rechberger wrote:
>>>     em2880-dvb:
>>>     * supporting the digital part of Empia based devices, which
>>> includes ATSC, ISDB-T and DVB-T
>>
>> <snip>
>>
>> Doesn't this driver duplicate some of the existing devices we already
>> support with the current in-kernel driver?  If so, why not just add the
>> new device support to the existing driver instead of duplicating
>> everything?
>>
>> This is going to cause a big problem for distros as they will not know
>> which to enable, so they will probably just disable this one, which is
>> what I don't think you want to have happen :(
>>
>
> the current driver doesn't support most devices which are in there,
> also the alsa
> audio driver can easily crash the whole system. (It's my code so I
> know what was wrong there).
>
> The core video code is already too much off, the VBI code added alot
> complexity
> to it it does frame slicing on the fly.
>
> Those devices ship VBI+VIDEO within 1 datastream, VBI and Video aren't
> that different
> in the system. both interfaces provide framebuffers through a mmap'ed
> interface.
> If all the VBI buffers are filled the data has to be sliced off in any
> case while providing
> the same bottom data ot the Video interface

Hi,

Just to check, your driver does handle this correctly now, right? Last
time I checked, it was a buggy mess with severely broken locking that
caused a kernel panic half the time when recording whith MythTV (and
indeed, had been for years). It looks, at a glance, like this may have
been fixed, but since I never quite managed to pin down the exact
cause, I can't say for sure.

(The code is, alas, still somewhat ugly compared to the existing
videobuf-based code in the in-kernel driver - it should be possible to
add VBI support to that fairly cleanly and easily. I actually
attempted this a while back, but ran into issues due to not having
access to the datasheets. Of course, the fact that Markus works there
and is actively aggressive to any Linux driver development that
doesn't go through him.)

> http://mcentral.de/hg/~mrec/em28xx-new/shortlog (there are more than
> 200 changelog entries
> what happened in detail).
>
> The development has been split off (first due limitations in the
> kernel, afterwards due ..., and finally
> due the restriction that all that has to work without a framework
> upgrade on the eeePC).

This doesn't exactly inspire confidence; it seems to basically mean
you forked or rewrote existing drivers rather than just using code
that was already there.

> diffing the 2 available drivers shows up that only the core is twice
> as big as the one which is currently
> in the driver (the result of 2-3 years asynchronous development).

Actually, part of the reason for this is probably that there's a
massive bunch of video buffer handling code in your driver that mostly
repeats stuff handled by the videobuf module in the in-kernel driver.
(Admittedly, your does slightly more in that it handles raw VBI, but
as I've said it should be possible to do that cleanly and in a smaller
amount of code using videobuf.)

> The driver is currently also tested with signal generators (different
> inputs, and different video standards).
>
> Very likely the best would be to replace the available driver with it
> but I don't care, alot people use and have been using the driver from
> mcentral.de for a long time, development has always been opensource
> there too.

Just not necessarily open source under a GPL compliant license, as I recall.

As I've said before, it'd be really nice if you'd make an effort to
actually integrate your changes, but this looks like more of the same
old mess.

Aidan
