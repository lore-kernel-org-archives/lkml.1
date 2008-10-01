Return-Path: <linux-kernel-owner+w=401wt.eu-S1754484AbYJAWJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbYJAWJv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 18:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753369AbYJAWJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 18:09:44 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:21049 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330AbYJAWJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 18:09:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=dLZOTa3RYjpY/QOH15JIGHBVMdXjQhXk2r1bu1eknHpkTKlHWzDL/rM0MbrHi3g8P3
         kc2uZ+an9WPHyhYhwiug1ixVO5qEBuyOJE8zZockwg9u+fGAhcgAcxwusn/yOT60OvFd
         E6V3R5XJ27OIxtKBvfpLlaNQMef8H9xYJyfU0=
Message-ID: <2c0942db0810011509j6c35911fh55c4e3178caf7f04@mail.gmail.com>
Date: Wed, 1 Oct 2008 15:09:40 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Marek Szuba" <scriptkiddie@wp.pl>
Subject: Re: Regular system 'hiccups' with 2.6.25+ on amd64 machines
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081001235106.57edede4@ifurita.akmm.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081001235106.57edede4@ifurita.akmm.lan>
X-Google-Sender-Auth: 4415b6e7d8dc18b4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 1, 2008 at 2:51 PM, Marek Szuba <scriptkiddie@wp.pl> wrote:
> Hello everyone,
>
> While I am not sure whether this is a bug or not, the phenomenon is
> rather peculiar so I have decided to ask here. The problem is, upgrading
> the kernel on any of my two AMD64 boxes from 2.6.24 to 2.6.25 or newer
> causes both systems to get "hiccups", that it every half a second or so
> they briefly freeze. Below you will find two examples of the problem:
>
> 1. On both systems, refreshing icons in the system tray takes much more
> time than before: whereas with 2.6.24 the flicker of icons as they get
> updated is barely noticeable, with 2.6.25+ you can see it quite clearly
> and sometimes you can even see blank background of the tray app.
>
> 2. On the weaker of the two systems (Athlon64 3500+, 2 GB RAM,
> nForce-based motherboard, on-board sound device supported by the
> intel8x0 ALSA driver), one can hear audio playback (tested primarily
> on a Shoutcast stream) stutter on a regular basis even with
> buffering enabled. With 2.6.24 this never happened, even under heavy
> system load.
>
> 3. I run an instance of Internet DJ Console (idjc), which used JACK, on
> the stronger of the two systems (Athlon64 4000+, 2 GB RAM, nForce-based
> motherboard, Sound Blaster Audigy 2 PCI card with ALSA driver emu10k1).
> Up to and including 2.6.24 I've never had any problems with streaming
> to the Icecast server I use, even under relatively heavy system load -
> those few xruns, of just a few ms each, that did happen were removed by
> buffering. However, under 2.6.25 and up I start getting xruns as soon
> as idjc starts, even before I connect to the Icecast server or start
> broadcasting anything! These look as follows:
>
> **** alsa_pcm: xrun of at least 1222893019070.464 msecs
>
> (the value is always the same) and appear more-or-less twice per
> second. When I do connect to the server and begin streaming, the sound
> as received by clients is audibly choppy when the system is otherwise
> idle and becomes extremely distorted under load. The problem persists
> after switching to an Icecast server running on the same machine, or indeed
> if instead of running an independent media client I enable (in idjc)
> listening to the stream before it gets sent to the server.
>
>
> As I mentioned earlier, the problem affects all kernel versions I have
> tried from 2.6.25 up to and including 2.6.26.5 - both vanilla versions
> and with the grsecurity patch applied. Attached you will find my config
> files for 2.6.24.7 and 2.6.26.5. Unfortunately I do not know whether the
> problem affects other architectures than amd64.
>
> I would greatly appreciate it if you could look into the problem and
> let me know what is wrong - i.e. whether this is a bug, an
> unnecessarily-enabled feature, something that just needs a bit of
> tuning and so on. If you need any more information regarding the issue,
> my set-ups and so on, please don't hesitate to contact me (by
> writing to my e-mail address - I'm not subscribed to LKML at present)!
>
> Yours sincerely,
> --
> MS
>

$ bzgrep -i group config.2.6.26.5.bz2
# CONFIG_CGROUPS is not set
CONFIG_GROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_RT_GROUP_SCHED is not set
# CONFIG_CGROUP_SCHED is not set

The group scheduler has (or at least had, prior to now) known fairness
and interactivity issues. Please disable it and try again.
