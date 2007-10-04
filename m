Return-Path: <linux-kernel-owner+w=401wt.eu-S1762735AbXJDQQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762735AbXJDQQe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 12:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759068AbXJDQQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 12:16:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36822 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757734AbXJDQQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 12:16:03 -0400
Message-ID: <470511A9.4060705@zytor.com>
Date: Thu, 04 Oct 2007 09:15:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: kernel list <linux-kernel@vger.kernel.org>, jikos@jikos.cz
Subject: Re: video resume stuff
References: <20071004130513.GA16076@elf.ucw.cz>
In-Reply-To: <20071004130513.GA16076@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
> I'm thinking about how to clean up video resume/how to get it to work
> for non-VESA video modes (jikos' case).
> 
> I guess the cleanest solution would be to just call set_mode from
> wakeup.S.... but that is not as easy as I imagined, because bootup
> code seems to be compiled separately.
> 
> Is there some easy way to retain bootup code in memory, so that wakeup
> can use it? Or is there some easy solution I'm missing?

No, not really.  The setup code is not even part of the kernel binary 
proper, and may not even have been run under certain circumstances.

The "easy" solution is to link it in again, which seems to be what 
you're doing.  Now, currently the boot code is compiled after vmlinux is 
complete, so some of the build ordering would have to be changed and/or 
some of the code rearranged.

I suggest we tackle this *after* the x86 merge.

	-hpa
