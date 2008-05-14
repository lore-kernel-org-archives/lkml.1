Return-Path: <linux-kernel-owner+w=401wt.eu-S1760637AbYENL30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760637AbYENL30 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 07:29:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757428AbYENL3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 07:29:16 -0400
Received: from nef2.ens.fr ([129.199.96.40]:2431 "EHLO nef2.ens.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755949AbYENL3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 07:29:15 -0400
Date: Wed, 14 May 2008 13:27:02 +0200
From: Eric.Brunet@lps.ens.fr
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Linux Kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Bug with keyboard input
Message-ID: <20080514112701.GA9639@platane.lps.ens.fr>
References: <20080513092735.GA32087@platane.lps.ens.fr> <4829FE73.20709@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4829FE73.20709@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.1.4 (nef2.ens.fr [129.199.96.32]); Wed, 14 May 2008 13:29:11 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 10:47:47PM +0200, Jiri Slaby wrote:
> On 05/13/2008 11:27 AM, Eric.Brunet@lps.ens.fr wrote:
>> Hi list,
>>
>> With uptodate Fedora 7 (kernel kernel-2.6.23.15-80.fc7) on a Dell D430 laptop.
>
> Please file a bug on redhat bugzilla. They (like other distro providers) 
> have bunch of patches included in it.
>
> Or try some kernel.org tree and recheck if the problem persist, then report it here.

Well that's not the sort of things distributions are patching, but you're
of course right, it is better to make sure. So I downloaded the sources
of a linux-2.6.25, copied the fedora .config, ran make oldconfig and
made the default answer to every question. With that pristine kernel, the
bug is still here.

Thanks,

	Éric Brunet

> In short, if I do
>         echo -n "i8042" > /sys/bus/platform/drivers/i8042/unbind
> followed by
>         echo -n "i8042" > /sys/bus/platform/drivers/i8042/bind
> everything works fine, EXCEPT if I hit a key on the keyboard between the
> unbind and the bind (tested with leftcontrol and spacebar). If I hit a
> key, it looks like the keyboard isn't taking release events anymore and
> the next key I hit is forever repeated. When my keyboard is in its
> working
> state, I read
>         N: Name="AT Translated Set 2 keyboard"
> in /proc/bus/input/devices. When it is in its non-working state (I hit a
> key between unbind and bind), I read
>         N: Name="AT Raw Set 2 keyboard"
> in the same file, and each time I hit a key, I have messages such as
>     atkbd.c: Unknown key pressed (raw set 2, code 0x11f on
> isa0060/serio0).
>     atkbd.c: Use 'setkeycodes 1f <keycode>' to make it known.
>     atkbd.c: Unknown key pressed (raw set 2, code 0x11e on
> isa0060/serio0).
>     atkbd.c: Use 'setkeycodes 1e <keycode>' to make it known.
> in my logs.
> 
> Note that the key doesn't have to be pressed while the bind happens, it
> is sufficient that the key have been pressed and released before the
> bind.
> 
> So, is there a way to make it work and have the input layer automatically
> recognize the correct keyboard type or keyboard mode ? If not, is there a
> way to keep it from guessing and to force it to treat the keyboard as an
> "AT Translated Set 2 keyboard" ?
> 
> As a final note, I get hit by this bug quite often during suspend/resume
> cycles. I had found that the keyboard wasn't all the time properly waking up,
> (it was getting stuck) so I've added a file in /etc/pm/sleep.d to do the
> unbind at suspend time and the bind at resume time. This fixed my
> problem, except that at times I stupidly press a key in the hope that the
> resume is done and that the screen is black only because of the
> screensaver, and that hitting a key will make appear the unlocking
> window...

