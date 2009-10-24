Return-Path: <linux-kernel-owner+w=401wt.eu-S1752360AbZJXVFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360AbZJXVFm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Oct 2009 17:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752341AbZJXVFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Oct 2009 17:05:42 -0400
Received: from mail-pw0-f42.google.com ([209.85.160.42]:45439 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305AbZJXVFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Oct 2009 17:05:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=e6zrNjo0VnqboFWLFpfr9ZiR/PTzspiKVH3Pldkv5ENAWBAYqpTLvizlG/9wtVKcnE
         UYraSJpuOrZbLuyFqVRA5jAlVDg2OiZ74+cM2e24Crx+XdCzmeJ+jJB32eyf9L4edsFO
         nTKiZctmfz4+X7bkQXSiSU60cHNXKjARzk6yA=
Date: Sat, 24 Oct 2009 14:05:40 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Harald Dunkel <harald.dunkel@t-online.de>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.31.5: /dev/input/event? are gone sometimes
Message-ID: <20091024210540.GA15297@core.coreip.homeip.net>
References: <4AE308A8.2070309@t-online.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AE308A8.2070309@t-online.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Harald,

On Sat, Oct 24, 2009 at 04:01:12PM +0200, Harald Dunkel wrote:
> Hi folks,
>
> Sometimes (by chance, as it seems) the /dev/input/event? devices
> are not working after power-on or reboot. They are not listed in
> /proc/bus/input/devices. The mouse in X is not moving, keyboard
> is dead, etc. All I can do is reboot and hope.
>
> Below you can find the diff of /proc/bus/input/devices between
> a bad and a good start.
>
>
> udev is 146-5 (included with Debian Sid).
>
>
> Any helpful hints would be highly appreciated. Of course I can
> send you the .config, if there is some interest.
>
>
> Regards
>
> Harri
> ===================================================================
> % diff -u devices.bad devices.good
> --- devices.bad 2009-10-24 15:08:24.000000000 +0200
> +++ devices.good        2009-10-24 15:17:17.000000000 +0200
> @@ -3,7 +3,7 @@
>  P: Phys=isa0060/serio0/input0
>  S: Sysfs=/devices/platform/i8042/serio0/input/input0
>  U: Uniq=
> -H: Handlers=kbd
> +H: Handlers=kbd event0

Since evdev binds to -every_ input device registered its absence in the
handlers list suggests that the module is not loaded. I am not sure how
and when your distribution loads evdev; try making it built-in to avoid
cases when it is not loaded for one reason or another.

-- 
Dmitry
