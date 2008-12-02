Return-Path: <linux-kernel-owner+w=401wt.eu-S1755151AbYLBQOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151AbYLBQOa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 11:14:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751746AbYLBQOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 11:14:22 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56885 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751275AbYLBQOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 11:14:21 -0500
Date: Tue, 2 Dec 2008 08:13:47 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: =?ISO-8859-15?Q?Alejandro_Riveira_Fern=E1ndez?= 
	<ariveira@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dmitry Baryshkov <dbaryshkov@gmail.com>
Subject: Re: Linux 2.6.28-rc7
In-Reply-To: <20081202165637.09984819@varda>
Message-ID: <alpine.LFD.2.00.0812020804590.3256@nehalem.linux-foundation.org>
References: <alpine.LFD.2.00.0812012004370.3256@nehalem.linux-foundation.org> <20081202131442.42e7df48@varda> <alpine.LFD.2.00.0812020748310.3256@nehalem.linux-foundation.org> <20081202165637.09984819@varda>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 2 Dec 2008, Alejandro Riveira Fernández wrote:
> 
>  from my reply to pazke <pazke@ports.donpac.ru>
>  "
> I took the sanpshot of the dmesg after loading the module if my word is not
> enough i can reboot with the module disabled but i do not see the point...
> The truth is that the bug prevented me from loading/installing the nvidia
> module becouse i could not use sudo. Only when i rebooted into single mode
> where the problems went away i could build and install the module...

Ahh, ok. I did wonder if something was up from the timing (ie it was 
loaded almost two minutes after bootup).

Since you are apparently a git user, and 2.6.28-rc6-00007-ged31348 was 
fine, there's really only 270 commits in between that and 2.6.28-rc7. Can 
I ask you to bisect for a couple of runs, which would cut it down to a 
handful? (Ie you don't even need to do a full bisect, although that should 
really only require about 8 reboots).

Just do

	git bisect start
	git bisect bad v2.6.27
	git bisect good v2.6.28-rc6-00007-ged31348

and off you go. That would help enormously.

There are very few console-related changes in that range, and the most 
notably one is actually radeon-specific so it shouldn't be an issue for 
you. I'd _suspect_ bca404afdc5206c3bb30168315ee8a98a579ec65 ("fbdev: fix 
FB console blanking"), but quite frankly, it could be something random 
that just interacted badly. A bisection would narrow things down.

			Linus
