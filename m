Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003Ab0BGHSf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 02:18:35 -0500
Received: from kcmailp05.birch.net ([216.212.0.100]:63870 "EHLO mx01.birch.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751666Ab0BGHSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 02:18:34 -0500
Message-ID: <4B6E6959.60708@softplc.com>
Date: Sun, 07 Feb 2010 01:18:49 -0600
From: Dick Hollenbeck <dick@softplc.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: SquashFS on ARM9
References: <4B6E0F88.2020402@softplc.com>
In-Reply-To: <4B6E0F88.2020402@softplc.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dick Hollenbeck wrote:
>
> Dear Philip et. al,
>
>
> I am using 2.6.30.5 on an ARM9 with squashfs.
>
> The squashFS image is built with x86_64 form of
>
>        mksquashfs version 4.1-CVS (2009/09/20)
>
> 64 bit linux program.
 >  There are no problems on the development system, only the ARM9.



OK I got more news:

The image works OK if I build it with the 32 version of mksquashs on x86.

Amazing, there are differences in file format other than endian-ness?

So we have at least 3 forms of the file system image now?  I am 
disappointed.  One would have sufficed.  I don't even buy the need for 
LSbyte vs MSbyte being needed.  There should have been only one form of 
the FS image.

Ouch, this seems amateurish.   Can I assume it is the bitfields?   Get 
rid of the bitfields!

Use #defines and OR and AND them please.

In the mksquashfs program, simply create some ints

(1<<a)
(1<<b)

etc using #defines.


Andrew Morton warned you about this years ago.  You have the bitfields 
using defines, its just that you control where the bits are:

#define MBIT (1<<2)

struct s {
    int32_t val;
} r;


r.val |= MBIT;

How hard is that really?

For now I don't need anymore help.  Sorry if I burned down my bridge, I 
only intend to offer strategy to improve the filesystem.

Dick


