Return-Path: <linux-kernel-owner+w=401wt.eu-S965357AbXAYOLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965357AbXAYOLe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 09:11:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965353AbXAYOLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 09:11:34 -0500
Received: from nz-out-0506.google.com ([64.233.162.225]:53925 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965280AbXAYOLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 09:11:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=if9TUhW1XuVRT6KSIdtC0dC/yTalvZDZRBEl3amg41hEUBR/nDczNqSQUI/E6BGLToNqqtG6PoFUMEQTPdZs4QqRpvV6O3EHalzXulxzSg6ffSq4cuiJK36gKYuj26RxKdSJ8RlWE5hhsDIZZqW7uCoxpI4ss5NpZoRarFUPuKc=
Message-ID: <806dafc20701250611u9935049ja8f88deb2aac4d40@mail.gmail.com>
Date: Thu, 25 Jan 2007 09:11:32 -0500
From: "Christopher \"Monty\" Montgomery" <xiphmont@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [PATCH] alsa: correct nonsensical sysfs device symlinks
Cc: perex@suse.cz, mclasen@redhat.com, jrb@redhat.com,
       "Lennart Poettering" <lennart@poettering.net>,
       "Pierre Ossman" <drzeus@drzeus.cx>, linux-kernel@vger.kernel.org,
       alsa-devel@alsa-project.org, fedora-desktop-list@redhat.com
In-Reply-To: <20070125042616.GA21813@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <806dafc20701241750t53b86babn36831cadc7dfa76c@mail.gmail.com>
	 <20070125042616.GA21813@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/24/07, Greg KH <greg@kroah.com> wrote:
> I don't understand, where does the symlink currently point to?  It looks
> correct to me on my machines:

My machines and the fedora rawhide machines using the 2.6.20-rcX
releases look nothing like what you pasted.  If they did, hald would
be working...  (I'll note that bugs have also been logged against
Pulse and HAL by users having trouble, so it's not just us.)

What you said you have:

> $ tree /sys/class/sound/
> /sys/class/sound/
> |-- card0 -> ../../devices/pci0000:00/0000:00:1b.0/card0
> |-- controlC0 -> ../../devices/pci0000:00/0000:00:1b.0/card0/controlC0
> |-- pcmC0D0c -> ../../devices/pci0000:00/0000:00:1b.0/card0/pcmC0D0c
> |-- pcmC0D0p -> ../../devices/pci0000:00/0000:00:1b.0/card0/pcmC0D0p
> |-- pcmC0D2c -> ../../devices/pci0000:00/0000:00:1b.0/card0/pcmC0D2c
> |-- pcmC0D6c -> ../../devices/pci0000:00/0000:00:1b.0/card0/pcmC0D6c
> |-- pcmC0D6p -> ../../devices/pci0000:00/0000:00:1b.0/card0/pcmC0D6p
> `-- timer -> ../../devices/virtual/sound/timer

What we actually have here:
/sys/class/sound/
|-- adsp
|   |-- dev
|   |-- device -> ../../../class/sound/card0
|   |-- power
|   |   `-- wakeup
|   |-- subsystem -> ../../../class/sound
|   `-- uevent
|-- audio
|   |-- dev
|   |-- device -> ../../../class/sound/card0
|   |-- power
|   |   `-- wakeup
|   |-- subsystem -> ../../../class/sound
|   `-- uevent
|-- audio1
|   |-- dev
|   |-- device -> ../../../class/sound/card1
|   |-- power
|   |   `-- wakeup
|   |-- subsystem -> ../../../class/sound
|   `-- uevent
|-- card0
|   |-- 0-0:AD1981B
|   |   |-- bus -> ../../../../bus/ac97
|   |   |-- power
|   |   |   `-- wakeup
|   |   |-- subsystem -> ../../../../bus/ac97
|   |   `-- uevent
|   |-- device -> ../../../devices/pci0000:00/0000:00:1f.5
|   |-- power
|   |   `-- wakeup
|   |-- sound:adsp -> ../../../class/sound/adsp
|   |-- sound:audio -> ../../../class/sound/audio
|   |-- sound:controlC0 -> ../../../class/sound/controlC0
|   |-- sound:dsp -> ../../../class/sound/dsp
|   |-- sound:mixer -> ../../../class/sound/mixer
|   |-- sound:pcmC0D0c -> ../../../class/sound/pcmC0D0c
|   |-- sound:pcmC0D0p -> ../../../class/sound/pcmC0D0p
|   |-- sound:pcmC0D1c -> ../../../class/sound/pcmC0D1c
|   |-- sound:pcmC0D2c -> ../../../class/sound/pcmC0D2c
|   |-- sound:pcmC0D3c -> ../../../class/sound/pcmC0D3c
|   |-- sound:pcmC0D4p -> ../../../class/sound/pcmC0D4p
|   |-- subsystem -> ../../../class/sound
|   `-- uevent
|-- card1
|   |-- 1-1:unknown codec
|   |   |-- bus -> ../../../../bus/ac97
|   |   |-- power
|   |   |   `-- wakeup
|   |   |-- subsystem -> ../../../../bus/ac97
|   |   `-- uevent
|   |-- device -> ../../../devices/pci0000:00/0000:00:1f.6
|   |-- power
|   |   `-- wakeup
|   |-- sound:audio1 -> ../../../class/sound/audio1
|   |-- sound:controlC1 -> ../../../class/sound/controlC1
|   |-- sound:dsp1 -> ../../../class/sound/dsp1
|   |-- sound:mixer1 -> ../../../class/sound/mixer1
|   |-- sound:pcmC1D0c -> ../../../class/sound/pcmC1D0c
|   |-- sound:pcmC1D0p -> ../../../class/sound/pcmC1D0p
|   |-- subsystem -> ../../../class/sound
|   `-- uevent
|-- controlC0
|   |-- dev
|   |-- device -> ../../../class/sound/card0
|   |-- power
|   |   `-- wakeup
|   |-- subsystem -> ../../../class/sound
|   `-- uevent
|-- controlC1
|   |-- dev
|   |-- device -> ../../../class/sound/card1
|   |-- power
|   |   `-- wakeup
|   |-- subsystem -> ../../../class/sound
|   `-- uevent
|-- dsp
|   |-- dev
|   |-- device -> ../../../class/sound/card0
|   |-- power
|   |   `-- wakeup
|   |-- subsystem -> ../../../class/sound
|   `-- uevent
|-- dsp1
|   |-- dev
|   |-- device -> ../../../class/sound/card1
|   |-- power
|   |   `-- wakeup
|   |-- subsystem -> ../../../class/sound
|   `-- uevent
|-- mixer
|   |-- dev
|   |-- device -> ../../../class/sound/card0
|   |-- power
|   |   `-- wakeup
|   |-- subsystem -> ../../../class/sound
|   `-- uevent
|-- mixer1
|   |-- dev
|   |-- device -> ../../../class/sound/card1
|   |-- power
|   |   `-- wakeup
|   |-- subsystem -> ../../../class/sound
|   `-- uevent
|-- pcmC0D0c
|   |-- dev
|   |-- device -> ../../../class/sound/card0
|   |-- pcm_class
|   |-- power
|   |   `-- wakeup
|   |-- subsystem -> ../../../class/sound
|   `-- uevent
|-- pcmC0D0p
|   |-- dev
|   |-- device -> ../../../class/sound/card0
|   |-- pcm_class
|   |-- power
|   |   `-- wakeup
|   |-- subsystem -> ../../../class/sound
|   `-- uevent
|-- pcmC0D1c
|   |-- dev
|   |-- device -> ../../../class/sound/card0
|   |-- pcm_class
|   |-- power
|   |   `-- wakeup
|   |-- subsystem -> ../../../class/sound
|   `-- uevent
|-- pcmC0D2c
|   |-- dev
|   |-- device -> ../../../class/sound/card0
|   |-- pcm_class
|   |-- power
|   |   `-- wakeup
|   |-- subsystem -> ../../../class/sound
|   `-- uevent
|-- pcmC0D3c
|   |-- dev
|   |-- device -> ../../../class/sound/card0
|   |-- pcm_class
|   |-- power
|   |   `-- wakeup
|   |-- subsystem -> ../../../class/sound
|   `-- uevent
|-- pcmC0D4p
|   |-- dev
|   |-- device -> ../../../class/sound/card0
|   |-- pcm_class
|   |-- power
|   |   `-- wakeup
|   |-- subsystem -> ../../../class/sound
|   `-- uevent
|-- pcmC1D0c
|   |-- dev
|   |-- device -> ../../../class/sound/card1
|   |-- pcm_class
|   |-- power
|   |   `-- wakeup
|   |-- subsystem -> ../../../class/sound
|   `-- uevent
|-- pcmC1D0p
|   |-- dev
|   |-- device -> ../../../class/sound/card1
|   |-- pcm_class
|   |-- power
|   |   `-- wakeup
|   |-- subsystem -> ../../../class/sound
|   `-- uevent
|-- seq
|   |-- dev
|   |-- power
|   |   `-- wakeup
|   |-- subsystem -> ../../../class/sound
|   `-- uevent
|-- sequencer
|   |-- dev
|   |-- power
|   |   `-- wakeup
|   |-- subsystem -> ../../../class/sound
|   `-- uevent
|-- sequencer2
|   |-- dev
|   |-- power
|   |   `-- wakeup
|   |-- subsystem -> ../../../class/sound
|   `-- uevent
`-- timer
    |-- dev
    |-- power
    |   `-- wakeup
    |-- subsystem -> ../../../class/sound
    `-- uevent

In other words... no resemblance whatsoever, so something is obviously
very wrong.  That is a vanilla 2.6.20-rc5 build on a fedora rawhide
machine, the rawhide-tweaked kernel and 2.6.19-rc6-mm2 produces the
same results.

With my patch, at least the 'old' entries for the pcm devices are as
before (The patch doesn't 'correct' anything for the device types
other than pcm and control, adsp and audio are still messed):

/sys/class/sound/
|-- adsp
|   |-- dev
|   |-- device -> ../../../class/sound/card0
|   |-- power
|   |   `-- wakeup
|   |-- subsystem -> ../../../class/sound
|   `-- uevent
|-- audio
|   |-- dev
|   |-- device -> ../../../class/sound/card0
|   |-- power
|   |   `-- wakeup
|   |-- subsystem -> ../../../class/sound
|   `-- uevent
|-- audio1
|   |-- dev
|   |-- device -> ../../../class/sound/card1
|   |-- power
|   |   `-- wakeup
|   |-- subsystem -> ../../../class/sound
|   `-- uevent
|-- card0
|   |-- 0-0:AD1981B
|   |   |-- bus -> ../../../../bus/ac97
|   |   |-- power
|   |   |   `-- wakeup
|   |   |-- subsystem -> ../../../../bus/ac97
|   |   `-- uevent
|   |-- device -> ../../../devices/pci0000:00/0000:00:1f.5
|   |-- power
|   |   `-- wakeup
|   |-- sound:adsp -> ../../../class/sound/adsp
|   |-- sound:audio -> ../../../class/sound/audio
|   |-- sound:dsp -> ../../../class/sound/dsp
|   |-- sound:mixer -> ../../../class/sound/mixer
|   |-- subsystem -> ../../../class/sound
|   `-- uevent
|-- card1
|   |-- 1-1:unknown codec
|   |   |-- bus -> ../../../../bus/ac97
|   |   |-- power
|   |   |   `-- wakeup
|   |   |-- subsystem -> ../../../../bus/ac97
|   |   `-- uevent
|   |-- device -> ../../../devices/pci0000:00/0000:00:1f.6
|   |-- power
|   |   `-- wakeup
|   |-- sound:audio1 -> ../../../class/sound/audio1
|   |-- sound:dsp1 -> ../../../class/sound/dsp1
|   |-- sound:mixer1 -> ../../../class/sound/mixer1
|   |-- subsystem -> ../../../class/sound
|   `-- uevent
|-- controlC0
|   |-- dev
|   |-- device -> ../../../devices/pci0000:00/0000:00:1f.5
|   |-- power
|   |   `-- wakeup
|   |-- subsystem -> ../../../class/sound
|   `-- uevent
|-- controlC1
|   |-- dev
|   |-- device -> ../../../devices/pci0000:00/0000:00:1f.6
|   |-- power
|   |   `-- wakeup
|   |-- subsystem -> ../../../class/sound
|   `-- uevent
|-- dsp
|   |-- dev
|   |-- device -> ../../../class/sound/card0
|   |-- power
|   |   `-- wakeup
|   |-- subsystem -> ../../../class/sound
|   `-- uevent
|-- dsp1
|   |-- dev
|   |-- device -> ../../../class/sound/card1
|   |-- power
|   |   `-- wakeup
|   |-- subsystem -> ../../../class/sound
|   `-- uevent
|-- mixer
|   |-- dev
|   |-- device -> ../../../class/sound/card0
|   |-- power
|   |   `-- wakeup
|   |-- subsystem -> ../../../class/sound
|   `-- uevent
|-- mixer1
|   |-- dev
|   |-- device -> ../../../class/sound/card1
|   |-- power
|   |   `-- wakeup
|   |-- subsystem -> ../../../class/sound
|   `-- uevent
|-- pcmC0D0c
|   |-- dev
|   |-- device -> ../../../devices/pci0000:00/0000:00:1f.5
|   |-- pcm_class
|   |-- power
|   |   `-- wakeup
|   |-- subsystem -> ../../../class/sound
|   `-- uevent
|-- pcmC0D0p
|   |-- dev
|   |-- device -> ../../../devices/pci0000:00/0000:00:1f.5
|   |-- pcm_class
|   |-- power
|   |   `-- wakeup
|   |-- subsystem -> ../../../class/sound
|   `-- uevent
|-- pcmC0D1c
|   |-- dev
|   |-- device -> ../../../devices/pci0000:00/0000:00:1f.5
|   |-- pcm_class
|   |-- power
|   |   `-- wakeup
|   |-- subsystem -> ../../../class/sound
|   `-- uevent
|-- pcmC0D2c
|   |-- dev
|   |-- device -> ../../../devices/pci0000:00/0000:00:1f.5
|   |-- pcm_class
|   |-- power
|   |   `-- wakeup
|   |-- subsystem -> ../../../class/sound
|   `-- uevent
|-- pcmC0D3c
|   |-- dev
|   |-- device -> ../../../devices/pci0000:00/0000:00:1f.5
|   |-- pcm_class
|   |-- power
|   |   `-- wakeup
|   |-- subsystem -> ../../../class/sound
|   `-- uevent
|-- pcmC0D4p
|   |-- dev
|   |-- device -> ../../../devices/pci0000:00/0000:00:1f.5
|   |-- pcm_class
|   |-- power
|   |   `-- wakeup
|   |-- subsystem -> ../../../class/sound
|   `-- uevent
|-- pcmC1D0c
|   |-- dev
|   |-- device -> ../../../devices/pci0000:00/0000:00:1f.6
|   |-- pcm_class
|   |-- power
|   |   `-- wakeup
|   |-- subsystem -> ../../../class/sound
|   `-- uevent
|-- pcmC1D0p
|   |-- dev
|   |-- device -> ../../../devices/pci0000:00/0000:00:1f.6
|   |-- pcm_class
|   |-- power
|   |   `-- wakeup
|   |-- subsystem -> ../../../class/sound
|   `-- uevent
|-- seq
|   |-- dev
|   |-- power
|   |   `-- wakeup
|   |-- subsystem -> ../../../class/sound
|   `-- uevent
|-- sequencer
|   |-- dev
|   |-- power
|   |   `-- wakeup
|   |-- subsystem -> ../../../class/sound
|   `-- uevent
|-- sequencer2
|   |-- dev
|   |-- power
|   |   `-- wakeup
|   |-- subsystem -> ../../../class/sound
|   `-- uevent
`-- timer
    |-- dev
    |-- power
    |   `-- wakeup
    |-- subsystem -> ../../../class/sound
    `-- uevent

Monty
