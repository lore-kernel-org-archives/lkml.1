Return-Path: <linux-kernel-owner+w=401wt.eu-S1756746AbYLET2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746AbYLET2P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 14:28:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753421AbYLET16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 14:27:58 -0500
Received: from cs-studio.ru ([195.178.208.66]:34716 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752641AbYLET16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 14:27:58 -0500
Date: Fri, 5 Dec 2008 22:27:55 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: Runaway loop with the current git.
Message-ID: <20081205192755.GA27712@ioremap.net>
References: <20081205180350.GA25236@ioremap.net> <20081205181610.518ecd13@lxorguk.ukuu.org.uk> <ac3eb2510812051032g6b5ea866q30f097d765854196@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac3eb2510812051032g6b5ea866q30f097d765854196@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2008 at 07:32:15PM +0100, Kay Sievers (kay.sievers@vrfy.org) wrote:
> > Your modprobe is for some reason triggering a load of /dev/ttyS* (ie the
> > serial 8250 stuff) from within the module loading scripts. You'll need to
> > debug the user space and work out why the loop is happening then it
> > should be fairly easy to fix.
> 
> Why do you think it's serial? 5-1 looks more like /dev/console.
> 
> This also seems to happen only in initramfs for people who see this.
> People say that compiling-in some modules (unfortunately they don't
> remember which) makes it work again.
> 
> Can this be some init order problem, that the /dev/console is not
> initialized but, we fork a process which tries to access it?

Getting that the same userspace runs ok in 2.6.27 and config changes do
not show immediate reason, I would blame some internal changes in some
kernel subsystem. Why at first it infinitely loops in tty/console loading?

I can not run bisect, since reboot requires vnc and I'm far from fast
channel. Build of the fresh tree with existing config takes almost
one hour, but it should not be a major problem.

I can do bisection after the weekend, but can test some changes before
machine froze with unsuccessful patch.

-- 
	Evgeniy Polyakov
