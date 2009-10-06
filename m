Return-Path: <linux-kernel-owner+w=401wt.eu-S932653AbZJFN7L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932653AbZJFN7L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 09:59:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932624AbZJFN7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 09:59:10 -0400
Received: from smtp.nokia.com ([192.100.105.134]:55106 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932589AbZJFN7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 09:59:09 -0400
Date: Tue, 6 Oct 2009 16:55:18 +0300
From: Felipe Balbi <felipe.balbi@nokia.com>
To: "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>
Cc: ext Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "dbrownell@users.sourceforge.net" <dbrownell@users.sourceforge.net>
Subject: Re: TTY loosing bytes ?
Message-ID: <20091006135518.GB4452@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <20091006094845.GT4452@nokia.com>
 <20091006114528.GV4452@nokia.com>
 <20091006131230.5301f711@lxorguk.ukuu.org.uk>
 <20091006130150.GY4452@nokia.com>
 <20091006141115.12ad22dd@lxorguk.ukuu.org.uk>
 <20091006132752.GZ4452@nokia.com>
 <20091006144012.1af5744a@lxorguk.ukuu.org.uk>
 <20091006134209.GA4452@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091006134209.GA4452@nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 06 Oct 2009 13:56:57.0899 (UTC) FILETIME=[DEB107B0:01CA468C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06, 2009 at 03:42:09PM +0200, Balbi Felipe (Nokia-D/Helsinki) wrote:
> On Tue, Oct 06, 2009 at 03:40:12PM +0200, ext Alan Cox wrote:
> > > unfortunately it didn't work. Although now I don't the debugging prints
> > > complaining we've lost bytes, the transfer does get stuck in lot earlier
> > > stage.
> > > 
> > > Maybe this is one fix but there's still other problem with that code ?
> > 
> > Or with completely unrelated code. I guess you need to measure what goes
> > into receive_buf versus what appears in userspace
> 
> will do it soonish. Thanks Alan, I'll return to you when I have more
> debugging.

ok, here we are. For some reason the host side seems that it just
stopped sending data to us:

> [  177.413879]    37    37    37: read for 3 bytes
> [  177.413909]    37    37    37: read actually 3 bytes (total 3)
> [  177.413940]    37    37    37: read for 34 bytes
> [  177.413940]    37    37    37: read actually 34 bytes (total 37)
> [  177.414916]    37    37    37: write
> [  177.416992]    40    40    40: read for 3 bytes
> [  177.417022]    40    40    40: read actually 3 bytes (total 3)
> [  177.417053]    40    40    40: read for 37 bytes
> [  177.417053]    40    40    40: read actually 37 bytes (total 40)
> [  178.115966]    40    40    40: write
> [  178.116058]     0     0     0: write
> [  178.175689]    19    19    19: read for 3 bytes
> [  178.175720]    19    19    19: read actually 3 bytes (total 3)
> [  178.175750]    19    19    19: read for 16 bytes
> [  178.175781]    19    19    19: read actually 16 bytes (total 19)
> [  178.175842]    19    19    19: write
> [  180.784820] musb_hdrc periph: enabled ep1out for bulk OUT, maxpacket 512
> [  180.784851] musb_hdrc periph: enabled ep1in for bulk IN, maxpacket 512
> [  180.848358] musb_hdrc periph: enabled ep1out for bulk OUT, maxpacket 512
> [  180.848388] musb_hdrc periph: enabled ep1in for bulk IN, maxpacket 512
> [  186.659851] musb_hdrc periph: enabled ep2in for bulk IN, maxpacket 512
> [  186.659912] musb_hdrc periph: enabled ep2out for bulk OUT, maxpacket 512
> [  186.723907] musb_hdrc periph: enabled ep2in for bulk IN, maxpacket 512
> [  186.723937] musb_hdrc periph: enabled ep2out for bulk OUT, maxpacket 512
> [  186.848602]    37    37    37: read for 3 bytes
> [  186.848632]    37    37    37: read actually 3 bytes (total 3)
> [  186.848663]    37    37    37: read for 34 bytes
> [  186.848663]    37    37    37: read actually 34 bytes (total 37)
> [  186.849182]    37    37    37: write
> [  186.852539]    40    40    40: read for 3 bytes
> [  186.852569]    40    40    40: read actually 3 bytes (total 3)
> [  186.852600]    40    40    40: read for 37 bytes
> [  186.852630]    40    40    40: read actually 37 bytes (total 40)
> [  187.435577]    40    40    40: write
> [  187.435699]     0     0     0: write
> [  187.644683]    47    47    47: read for 3 bytes
> [  187.644714]    47    47    47: read actually 3 bytes (total 3)
> [  187.644744]    47    47    47: read for 44 bytes
> [  187.644775]    47    47    47: read actually 44 bytes (total 47)
> [  187.648620]    47    47    47: write
> [  192.939239]    24    24    24: read for 3 bytes
> [  192.939300]    24    24    24: read actually 3 bytes (total 3)
> [  192.939300]    24    24    24: read for 21 bytes
> [  192.939331]    24    24    24: read actually 21 bytes (total 24)
> [  192.939453]    24    24    24: write
> [  192.940246]    34    34    34: read for 3 bytes
> [  192.940246]    34    34    34: read actually 3 bytes (total 3)
> [  192.940277]    34    34    34: read for 31 bytes
> [  192.940307]    34    34    34: read actually 31 bytes (total 34)
> [  192.943206]    34    34    34: write
> [  192.944152]    34    34    34: read for 3 bytes
> [  192.944183]    34    34    34: read actually 3 bytes (total 3)
> [  192.944213]    34    34    34: read for 31 bytes
> [  192.944213]    34    34    34: read actually 31 bytes (total 34)
> [  192.944488]    34    34    34: write
> [  192.945373]    47    47    47: read for 3 bytes
> [  192.945373]    47    47    47: read actually 3 bytes (total 3)
> [  192.945404]    47    47    47: read for 44 bytes
> [  192.945434]    47    47    47: read actually 44 bytes (total 47)
> [  192.946594]    47    47    47: write
> [  192.981689]  6656  4096  3832: read for 3 bytes
> [  192.981750]  7168  4096  3832: read actually 3 bytes (total 3)
> [  192.981811]  7680  4096  3832: read for 65532 bytes
> [  192.982177] 11264 11264  3832: read actually 3829 bytes (total 3832)

this is weird. Why didn't we get more data ? Where's the rest of this
block ??

> [  194.410125] musb_hdrc periph: enabled ep3in for bulk IN, maxpacket 512
> [  194.410156] musb_hdrc periph: enabled ep3out for bulk OUT, maxpacket 512
> [  194.474456] musb_hdrc periph: enabled ep3in for bulk IN, maxpacket 512
> [  194.474487] musb_hdrc periph: enabled ep3out for bulk OUT, maxpacket 512
> [  200.706115] 65556 65556  3853: read for 3 bytes
> [  200.706176] 65556 65556  3853: read actually 3 bytes (total 3835)
> [  200.706207] 65556 65556  3853: read for 18 bytes
> [  200.706207] 65556 65556  3853: read actually 18 bytes (total 3853)
> [  200.706542] 65556 65556  3853: write

I'll add more messages to be sure what's going on.

-- 
balbi
