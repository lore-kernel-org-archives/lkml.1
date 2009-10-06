Return-Path: <linux-kernel-owner+w=401wt.eu-S1756666AbZJFLtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666AbZJFLtU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 07:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756100AbZJFLtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 07:49:19 -0400
Received: from smtp.nokia.com ([192.100.105.134]:43431 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756063AbZJFLtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 07:49:19 -0400
Date: Tue, 6 Oct 2009 14:45:28 +0300
From: Felipe Balbi <felipe.balbi@nokia.com>
To: "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       "dbrownell@users.sourceforge.net" <dbrownell@users.sourceforge.net>
Subject: Re: TTY loosing bytes ?
Message-ID: <20091006114528.GV4452@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <20091006094845.GT4452@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091006094845.GT4452@nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 06 Oct 2009 11:47:07.0893 (UTC) FILETIME=[BB7C7250:01CA467A]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06, 2009 at 11:48:45AM +0200, Balbi Felipe (Nokia-D/Helsinki) wrote:
> Hi all,
> 
> I'm facing a weird issue with TTY when using u_serial gadget.
> 
> The problem seems to be related to ldisc's buffer getting full. Imagine
> a situation where you have 510 bytes available on N_TTY's buffer and you
> try to flush 512 bytes then the code path would look like:
> 
> --> flush_to_ldisc();
> 	--> n_tty_receive_buf(512 bytes);
> 		--> i = 510;
> 		--> memcpy(i);
> 
> 		--> i = 0;
> 		--> memcpy(i);
> 	<-- wake_up_interruptible();
> 
> What happens is that we loose those 2 extra bytes. I tried digging this
> problem and try to find a fix for it but it's been really complicated
> for me.
> 
> Hope you guys can help. Actually, I've been reproducing the problem on
> 2.6.28 but looking at the code current mainline should have the same
> problem. I also cherry-picked the relevant patches to my 2.6.28 tree
> (hope I got all of them) and it still failed.
> 
> Sorry I'm reporting such a problem with such an old kernel but upgrading
> the kernel right now is just impossible.
> 
> If you guys could give any pointers I would be really glad.

one more information/question:

why doesn't receive_buf() return the amount of bytes actually received ?
I see flush_to_ldisc() believes it can flush everything before even
calling receive_buf() then it will never act on the possibility of
receive_buf() not being able to receive the entire data.

Am I right ? Should receive_buf() return the amount of bytes actually
received ? Also, why isn't receive_room enough to be sure there's
enough space to really receive that block of data ?

-- 
balbi
