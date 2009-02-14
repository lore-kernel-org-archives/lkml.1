Return-Path: <linux-kernel-owner+w=401wt.eu-S1754352AbZBNWcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352AbZBNWcv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 17:32:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbZBNWcn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 17:32:43 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:49327 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220AbZBNWcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 17:32:42 -0500
Date: Sat, 14 Feb 2009 17:32:37 -0500
From: Andres Salomon <dilinger@queued.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Chris Ball <cjb@laptop.org>, Harvey Harrison <harvey.harrison@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] olpc: fix model detection without OFW
Message-ID: <20090214173237.29407661@ephemeral>
In-Reply-To: <20090214221429.GB5200@elte.hu>
References: <1222208409.16003.25.camel@brick>
	<m3mycpye65.fsf@pullcord.laptop.org>
	<20090213231900.4f22008a@ephemeral>
	<20090214214312.GB31928@elte.hu>
	<20090214165311.5cf5b8bf@ephemeral>
	<20090214221429.GB5200@elte.hu>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Feb 2009 23:14:29 +0100
Ingo Molnar <mingo@elte.hu> wrote:
[...]
> Where did my git grepping skills go wrong?
> 
> I git-grepped the code and this is the scope i found:
> 
> olpc_platform_info.boardrev is used for:
> 
>  - a printk
>  - olpc_board_at_least() which is used in:
>     - drivers/input/mouse/hgpk.c:                mouse driver quirk
>     - sound/pci/cs5535audio/cs5535audio_olpc.c:  audio quirk
> 
> aha. I missed this roundabout impact:
> 
>     - arch/x86/kernel/olpc.c:                    OLPC_F_DCON flag
>       - which is used in olpc_has_dcon(), which is used in:
>         - drivers/video/geode/gxfb_core.c:       GX modes db
>                                                  [ouch if this goes
> wrong!]
>         - drivers/video/geode/lxfb_core.c:       ditto
> 
> So i guess the mouse and audio quirk point was correct too, but the
> major impact is the graphics mode array mismatch and the resulting
> nonsensical mode setting, right?
> 
> 	Ingo


Yep.
