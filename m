Return-Path: <linux-kernel-owner+w=401wt.eu-S1754100AbZJPVW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbZJPVW6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 17:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751294AbZJPVW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 17:22:57 -0400
Received: from mail-yw0-f202.google.com ([209.85.211.202]:48619 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbZJPVW5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 17:22:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vJd9y6v8WM/xmEW2BFOECmBavbVfI1up1+9UscTdPLo14CAiVQ+PO5kkuHSiWs3/qj
         sosgnSa9IEtI2XelkHebrdFzZROoQUYOQS7NWgJgqYU3y06cctLiNbQ8CyUbdq5SqAYz
         7x1N0BKOggtTYwRaWDJoe5txemfj57LtaWImM=
MIME-Version: 1.0
In-Reply-To: <200910162246.45678.elendil@planet.nl>
References: <b637ec0b0910161253y60eb6b4fl3e49e5b9129d81ac@mail.gmail.com>
	 <200910162246.45678.elendil@planet.nl>
Date: Fri, 16 Oct 2009 23:23:01 +0200
Message-ID: <b637ec0b0910161423o2a5fdd12u926f50c2e4139bf3@mail.gmail.com>
Subject: Re: [Regression] - 2.6.32-rc5 hangs using rfkill on an eeePC
From: Fabio Comolli <fabio.comolli@gmail.com>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, rjw@sisk.pl,
       Darren Salt <linux@youmustbejoking.demon.co.uk>,
       linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Fri, Oct 16, 2009 at 10:46 PM, Frans Pop <elendil@planet.nl> wrote:
> Fabio Comolli wrote:
>> Pressing rfkill button on my eeePC 900 to disable wireless hangs the
>> system.
>>
>> In console I can see (warning: what follows is copied by hand):
>>
>> acpid: client 148[6:100] has disconnected
>> ACPI group/action not found: hotkey / ATKD
>> unregister netdevice: waiting for wlan0 to become free; usage count=1
>> (last line repeats forever). Hard reset is needed.
>>
>> With any previous kernel version (I'm running -rc4 right now) everything
>> works:
>>
>> ACPI group/action undefined: hotkey / ATKD
>> ath5k 0000:01:00.0: PCI INT A disabled
>
> AFAICT there are only two commits since -rc4 that are likely candidates:
>
> commit b56ab33d68638e6aafdbfc694025e8354a628f49
> Author: Darren Salt <linux@youmustbejoking.demon.co.uk>
> Date:   Tue Oct 13 00:13:33 2009 +0200
>    eeepc-laptop: Prevent a panic when disabling RT2860 wireless when
>                  associated
>
> commit 0af49167b1e5ba154e90d2c454bf4624ee47df80
> Author: Darren Salt <linux@youmustbejoking.demon.co.uk>
> Date:   Wed Oct 14 02:19:22 2009 +0100
>    Staging: rt2860sta: prevent a panic when disabling when associated
>
> They look related and which one is relevant for you probably depends on
> which driver you're using.
>
> Could you try reverting them both to see if that solves the problem?

I already answered my own post in the thread: the culprit is:

eeepc-laptop: Prevent a panic when disabling RT2860 wireless when associated

Funnily enough, my eeePC has an Atheros card.

>
> Cheers,
> FJP
>

Regards,
Fabio
