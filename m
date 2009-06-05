Return-Path: <linux-kernel-owner+w=401wt.eu-S1754304AbZFEOiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304AbZFEOiT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 10:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753154AbZFEOiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 10:38:10 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:41337 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034AbZFEOiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 10:38:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=W4wD+Ej7vbADMyZiDeky4mdN/WmURuIfZjy/HWDDjJ1SWVvinFqH9/yy+6eJyVN2Uf
         iE9phVLKlh+1FkRlbcpuBUC7T6usu50z8FDgvF4uaWI+mcFLPkt0uf9rcmQUHHEKTcM6
         +IE+hmzgmie3AbFUtzxTkm+oiQ5yvPiSv3+I4=
MIME-Version: 1.0
Reply-To: alan-jenkins@tuffmail.co.uk
In-Reply-To: <1244209873.23533.29.camel@penberg-laptop>
References: <Pine.LNX.4.64.0906051157460.22218@melkki.cs.Helsinki.FI>
	 <71cd59b00906050446g7310d24el94f0d137dc0e0ecf@mail.gmail.com>
	 <1244205844.23533.21.camel@penberg-laptop>
	 <71cd59b00906050602s5c9b9a31ne11b6aaf7546f58c@mail.gmail.com>
	 <1244209873.23533.29.camel@penberg-laptop>
Date: Fri, 5 Jun 2009 15:38:08 +0100
Message-ID: <9b2b86520906050738kea062c9n1b2c0e767d6eb0aa@mail.gmail.com>
Subject: Re: [PATCH] eeepc-laptop: enable camera by default
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Corentin Chary <corentin.chary@gmail.com>,
       acpi4asus-user@lists.sourceforge.net, len.brown@intel.com,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/5/09, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> Hi Corentin,
>
> On Fri, 2009-06-05 at 15:02 +0200, Corentin Chary wrote:
>> > That said, I am more than happy to measure this but I need a little bit
>> > more information to get started as I have never used powertop. So what
>> > is it exactly you want me to do?
>>

>> For propers results, shutdown all services and just keep a shell
>> (without X or network).
>> You can also test that with and without the camera driver.
>
> I did not see a power usage estimate. I am running PowerTOP 1.11 that
> comes with Ubuntu 9.04. So I am not sure if what I did is what you
> wanted me to do but I ran "powertop -t 60 -d" with camera enabled and
> disabled and here are the results.

Yeah, "no ACPI power usage estimate available", just like my eeepc.

> Also, when I run plain powertop, it keeps complaining that some USB
> device causes wakeups (probably the camera?) and suggests suspending.
> But doing that doesn't seem to help things.

/me hijacks thread

Unfortunately powertop is out of date now.  The default behaviour is
not to suspend and it must be enabled on a per-device basis, because
there's lots of buggy hardware.

> Camera Disabled
> ---------------

> Wakeups-from-idle per second :  1.2	interval: 60.0s


> Camera Enabled
> --------------

> Wakeups-from-idle per second : 11.1	interval: 60.0s


Ok.  I didn't bother shutting down my system, but I get a similar
difference; 16 wakeups/s disabled v.s. 25 enabled.  Anecdotally,
disabling the camera does help battery life, and presumably Asus had
good reason to implement it!  (The shipped OS "fixes" the usability
problem by patching the camera apps).

BUT I found that autosuspend didn't seem to break anything, and
enabling it also got me down to 16 wakeups/s.  I think this is ideal
because autosuspend is automatic so I can save power without manual
toggling.

Here's some magic to enable autosuspend:

# echo -n auto > /sys/bus/usb/drivers/uvcvideo/*:*/../power/level

Ideally this wants to be enabled automatically using a udev rule.

Anyway, my point is we should be happy to enable the camera by
default, because it will encourage the development of userspace
autosuspend whitelists :-).

Alan
