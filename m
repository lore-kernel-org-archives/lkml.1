Return-Path: <linux-kernel-owner+w=401wt.eu-S1755440AbYLESc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440AbYLESc2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 13:32:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756383AbYLEScR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 13:32:17 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:61511 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756346AbYLEScQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 13:32:16 -0500
Message-ID: <ac3eb2510812051032g6b5ea866q30f097d765854196@mail.gmail.com>
Date: Fri, 5 Dec 2008 19:32:15 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: Runaway loop with the current git.
Cc: "Evgeniy Polyakov" <zbr@ioremap.net>, linux-kernel@vger.kernel.org
In-Reply-To: <20081205181610.518ecd13@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081205180350.GA25236@ioremap.net>
	 <20081205181610.518ecd13@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 5, 2008 at 19:16, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Fri, 5 Dec 2008 21:03:50 +0300
> Evgeniy Polyakov <zbr@ioremap.net> wrote:

>> I've built current (aaad07763) git tree with config, which worked ok
>> with 2.6.27 (pressed enter several times when 'make oldconfig' asked)
>> and now system fails to boot.
>>
>> Attached screen dump and config.
>>
>> I'm not subscribed, please add to copy.
>
> Your modprobe is for some reason triggering a load of /dev/ttyS* (ie the
> serial 8250 stuff) from within the module loading scripts. You'll need to
> debug the user space and work out why the loop is happening then it
> should be fairly easy to fix.

Why do you think it's serial? 5-1 looks more like /dev/console.

This also seems to happen only in initramfs for people who see this.
People say that compiling-in some modules (unfortunately they don't
remember which) makes it work again.

Can this be some init order problem, that the /dev/console is not
initialized but, we fork a process which tries to access it?

Kay
