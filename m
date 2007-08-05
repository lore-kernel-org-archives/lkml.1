Return-Path: <linux-kernel-owner+w=401wt.eu-S1759783AbXHEXk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759783AbXHEXk0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 19:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756641AbXHEXkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 19:40:14 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:12072 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755792AbXHEXkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 19:40:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sf8ioRf9BMrfVUzHAJ8WIYcPY0yEOH4Tmzv5sMenJDVyhSrv0cAuOrilx8T5W+QMqE/lLOHBJOSfOjDzTQeXMNxDBwkmWQfwCUVUbtPGWQalDewKFfhhTqse2hubu4r5KsqkjgsvDbJRVqnhyPKuy7yaoJ9J9lXeQ+8FIkeCVcI=
Message-ID: <b14e81f00708051640i7a48b3d9oe4b8fa8d863cde1@mail.gmail.com>
Date: Sun, 5 Aug 2007 19:40:11 -0400
From: "Michael Chang" <thenewme91@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: rtc max frequency setting
Cc: "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       rtc-linux@googlegroups.com
In-Reply-To: <46B5148E.50302@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0708050042560.14443@fbirervta.pbzchgretzou.qr>
	 <46B5148E.50302@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/4/07, H. Peter Anvin <hpa@zytor.com> wrote:
> Jan Engelhardt wrote:
> > Hi,
> >
> > with the old rtc.ko module, there was a /proc/sys/dev/rtc/max-user-freq
> > that could be set. With rtc_cmos.ko (or the new rtc infrastructure in
> > general), I am missing this file. Where can I set the max-user-freq now,
> > or is this obsolete now? (mplayer prefers to have user-freq to be >= 1024.)
> >
>
> Qemu wants something like this too.  Both of these really want something
> else, which is a high-frequency userspace timer.

For mplayer, you can use -softsleep, but that uses a lot of CPU, and
you're probably already using a great deal of CPU for video decoding,
so it might be less than optimal.

-softsleep
Time  frames  by  repeatedly  checking the current time instead of
asking the kernel to wake up MPlayer at the correct time.  Useful if
your kernel timing is imprecise and you cannot use the RTC either.
Comes at the price of higher CPU consumption.

And apparently, the build of MPlayer[1] that I have doesn't need rtc,
except on slower machines, according to the man page:

-rtc (RTC only)
Turns  on  usage  of the Linux RTC (realtime clock - /dev/rtc) as
timing mechanism.  This wakes up the process every 1/1024 seconds to
check the current time.  Useless with modern Linux kernels configured
for desktop use as they already wake up the process  with  similar
accuracy when using normal timed sleep.

[1] MPlayer dev-SVN-r23777-4.1.2 (C) 2000-2007 MPlayer Team

--
Michael Chang

Please avoid sending me Word or PowerPoint attachments. Send me ODT,
RTF, or HTML instead.
See http://www.gnu.org/philosophy/no-word-attachments.html
Thank you.
