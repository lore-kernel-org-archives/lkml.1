Return-Path: <linux-kernel-owner+w=401wt.eu-S1755840AbXJNJVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840AbXJNJVz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 05:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754758AbXJNJVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 05:21:46 -0400
Received: from hpsmtp-eml12.KPNXCHANGE.COM ([213.75.38.112]:31369 "EHLO
	hpsmtp-eml12.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754583AbXJNJVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 05:21:46 -0400
From: Frans Pop <pop00041@planet.nl>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Subject: Re: 2.6.23: No text consoles with FRAMEBUFFER_CONSOLE_DETECT_PRIMARY
Date: Sun, 14 Oct 2007 11:21:43 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <200710132013.24024.elendil@planet.nl> <1192340601.6548.11.camel@daplas>
In-Reply-To: <1192340601.6548.11.camel@daplas>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710141121.43752.pop00041@planet.nl>
X-OriginalArrivalTime: 14 Oct 2007 09:21:43.0997 (UTC) FILETIME=[A2FA4ED0:01C80E43]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 October 2007, Antonino A. Daplas wrote:
> On Sat, 2007-10-13 at 20:13 +0200, Frans Pop wrote:
> > I could solve this issue in two ways:
> > - boot with VGA=791 parameter (initial boot was without VGA= parameter)
> > - compile kernel without FRAMEBUFFER_CONSOLE_DETECT_PRIMARY set (I also
> >   unset FB_VIRTUAL, but without its boot param that should be a no-op)
>
> After looking at vfb.c again, it seems the default is for vfb to be
> enabled and you have to actively disable vfb either with
>
> video=vfb:disable or video=vfb:off

Yes, that works as well.

> I have to change this behavior. In the meantime, try one of the above
> options.

No real need. I normally boot with vga=791 (which is also why I did not
see this during my testing of 2.6.23-rc*).

On Sunday 14 October 2007, Antonino A. Daplas wrote:
> Can you also post your dmesg and /proc/cdmline?

Guess that's no longer really needed, but here are the relevant lines from a
dmesg diff between kernels with and without FB_CONSOLE_DETECT_PRIMARY.

<snip>
 Command line: root=/dev/sdb1 ro
[...]
 Console: colour VGA+ 80x25
 console [tty0] enabled
[...]
 checking if image is initramfs...<6>Switched to high resolution mode on CPU 1
 Switched to high resolution mode on CPU 0
[console output stopped here]
  it is
[...] (omitted about 30 lines)
-Console: switching to colour frame buffer device 80x25
-fb0: Virtual frame buffer device, using 1024K of video memory
</snip>

Thanks for quick reaction. Let me know if you'd like a patch tested.

Cheers,
FJP
