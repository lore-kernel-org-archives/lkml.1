Return-Path: <linux-kernel-owner+w=401wt.eu-S1761271AbZFMRvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761271AbZFMRvS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 13:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754241AbZFMRvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 13:51:11 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:57723 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbZFMRvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 13:51:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=hOzT81sPyyavmkWtY4aCBOjd5F/FkCO9VX4Uex6ANY0WEkWSFBxjh3XG5HtmzduSxF
         TEvmOV0i92OTpvYrvtYZoALpf1WwNa+lKroUJ2O1Ap4PtkehgeMvVITbCcQGNhOrgXxU
         nJaXm+unwLk6HhNkx0l4WxuH0l3/O1hRHrv28=
MIME-Version: 1.0
In-Reply-To: <507032D758%linux@youmustbejoking.demon.co.uk>
References: <504BBE2828%linux@youmustbejoking.demon.co.uk>
	 <20090404041813.GA30746@srcf.ucam.org>
	 <9b2b86520906080824i134ee546v33990176b0d3e618@mail.gmail.com>
	 <71cd59b00906130155u2757ade3t3378685846b80410@mail.gmail.com>
	 <4A337251.7010705@tuffmail.co.uk>
	 <71cd59b00906130306w319c0fc2i376bb03323845b80@mail.gmail.com>
	 <507032D758%linux@youmustbejoking.demon.co.uk>
Date: Sat, 13 Jun 2009 18:51:12 +0100
Message-ID: <9b2b86520906131051t32183554r8208cf886609e09c@mail.gmail.com>
Subject: Re: [PATCH 2.6.29] eeepc-laptop: report brightness control events via 
	the input layer
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Corentin Chary <corentin.chary@gmail.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       linux-kernel@vger.kernel.org, acpi4asus-user@lists.sourceforge.net,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Darren Salt <linux@youmustbejoking.demon.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/13/09, Darren Salt <linux@youmustbejoking.demon.co.uk> wrote:
> I demand that Corentin Chary may or may not have written...
>
>> On Sat, Jun 13, 2009 at 11:33 AM, Alan
>> Jenkins<alan-jenkins@tuffmail.co.uk>
>> wrote:
> [snip]
>>> The firmware still changes the brightness immediately.  It seems
>>> that when g-p-m gets delayed, it responds _wrongly_. It doesn't realize
>>> that the firmware already changed the brightness, so it changes the
>>> brightness again.
>
> Should it be changing the brightness at all? I ask because every laptop
> which
> I've used will change the brightness without userspace being involved.
> (Although it's possible that g-p-m might get brightness-change events from
> some source other than that which is used to report the laptop's own
> brightness controls...)

Good point.  Google suggests it may be necessary on some other systems though.

<https://lists.ubuntu.com/archives/kubuntu-bugs/2009-February/067008.html>

And I was wrong before when I said g-p-m should watch the generic
backlight interface.  It doesn't generate uevents, and in one way
that's good, because uevents are relatively heavyweight.  So the
brightness up / down "keypress" events are the only generic way that
g-p-m can use to detect changes :-(.

But I don't think it's important to be able to show a brightness
pop-up.  So I'm less confident, but I still think this change should
be reverted.

> [snip]
>> Version: 2.24.2-2ubuntu8
>> Ok I can reproduce [the brightness being changed inappropriately from
>> userspace].
>
>> I want to check if we can't fix g-p-m before reverting the patch. If
>> there is no way to fix it, I'll revert.
>
> I don't see that it can ever be reliable in the face of the brightness
> having
> already been changed without userspace involvement short of being able to
> tell it to report only on some/all events from some input devices.

Hmm.  I think I could accept it if it only played up when thrashing
the SSD.  So I'll try to work out exactly what happens in the other
case I reported, in case they're not the same problem.  (This other
problem is where I hold down "brightness down", then tap "brightness
up" a couple of times; the first couple of taps casue a flash as the
brightness goes first up and then down).

Alan
