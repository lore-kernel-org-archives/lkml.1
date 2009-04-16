Return-Path: <linux-kernel-owner+w=401wt.eu-S1755267AbZDPMp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbZDPMp1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 08:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754726AbZDPMpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 08:45:15 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:35566 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472AbZDPMpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 08:45:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=i5c5gmalU7C2ZNMeDrBtLDxwIoiAyRGvSOX6XzKN7zxIHFgcpk/sg3tGq85maiwORv
         EEuuqA+rGkPEB/tisu/7fWonsQvFvHMrMwg8lMb5send6Gm0DoM08RMD7b15nQMZ7KL5
         PN8N1ECNoN7/pGk2cWo3wNC3DXT3Mr9CMGEh4=
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.00.0904161210450.10907@twin.jikos.cz>
References: <4e5e476b0904091453m61ec4e81j7cfdef918bb3dfb3@mail.gmail.com>
	 <alpine.LRH.2.00.0904161210450.10907@twin.jikos.cz>
Date: Thu, 16 Apr 2009 14:45:12 +0200
Message-ID: <4e5e476b0904160545h1f384dbdx4161a0a304ad4c80@mail.gmail.com>
Subject: Re: linux-2.6.30rc1 mouse stuck with usb autosuspend enabled
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: oliver@neukum.name, Linux-Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16, 2009 at 12:15 PM, Jiri Kosina <jkosina@suse.cz> wrote:
>
> [ added Oliver to CC ]
>
> On Thu, 9 Apr 2009, Corrado Zoccolo wrote:
>
>> I found this regression w.r.t. 2.6.29.
>> When enabling usb automatic power management for all usb peripherals, with:
>> > for i in /sys/bus/usb/devices/*/power/level; do echo auto > $i; done
>
> Well, it's difficult to consider this to be a regression. With default
> settings (USB autosuspend turned off), the system behaves the same way as
> it did before (ie. no mouse autosuspend).
>
>> after 2 seconds of inactivity (my autosuspend threshold), the mouse
>> gets stuck under X.
>
> That's because it got suspended, as you have configured it to do so.
>
>> Pushing a mouse button will revive it (and the event is passed to X).
>
> Which is expected behavior.
>
> Your mouse (as many other mice out there) doesn't emit wakeup event on
> movement, it only does on button click. There is nothing kernel can do
> about it. This is one of the reasons why autosuspend is disabled by
> default (other reason being many devices broken beyond hope when it comes
> to waking up).

Well, to me it seems a regression since it worked correctly in 2.6.29, i.e.
* it was suspended after inactivity (at least according to powertop),
* it resumed operation when it was moved (no need to push a button to
have it working again).
unless 2.6.29 just lied about suspending the mouse.

BTW, I find autosuspend useful to increase the battery life, so at
least with good devices, we should make sure it works.

Corrado

>
> --
> Jiri Kosina
> SUSE Labs
>
>



-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
