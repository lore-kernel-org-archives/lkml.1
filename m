Return-Path: <linux-kernel-owner+w=401wt.eu-S1752111AbZIJQD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbZIJQD3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 12:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbZIJQD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 12:03:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55775 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbZIJQD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 12:03:28 -0400
Message-ID: <4AA921E0.3000605@zytor.com>
Date: Thu, 10 Sep 2009 08:57:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Alan Cox <alan@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] char/tty_io: fix legacy pty name when more than 256 pty
 devices are requested
References: <20090908144942.76ddf0e7@caramujo.chehab.org>	<4AA6DF50.3030603@zytor.com>	<20090908203323.486c129c@caramujo.chehab.org>	<4AA6F63F.7090009@zytor.com>	<20090908235441.04549a29@caramujo.chehab.org>	<4AA73309.8030302@zytor.com>	<20090910010512.60a1f523@caramujo.chehab.org>	<4AA89B02.1050909@zytor.com>	<20090910093301.4ccfd786@caramujo.chehab.org> <20090910150716.66310f02@lxorguk.ukuu.org.uk>
In-Reply-To: <20090910150716.66310f02@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2009 07:07 AM, Alan Cox wrote:
> I actually have another proposal having reviewed the user space code.
> 
> Limit the BSD ptys to 256. Nothing uses them, the C library routines for
> their allocation would need glibc modifying (which takes about five years
> for a tty change it seems anyway). It's basically a huge amount of work
> for no purpose at all.
> 
> So lets limit BSD ptys (unused anyway) to 256 and be done with it.

IMO this is the right thing to do (and in fact what the current kernel
does, explicitly, via Kconfig); I guess I assumed Mauro had a specific
reason for breaking it, but there are multiple reasons to NOT do this:

a) the userspace code needs to be changed regardless, in an arbitrary
   number of places.
b) noone uses them, except the occasional dedicated pipe which wants
   a predefined name.
c) the memory used is statically allocated.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

