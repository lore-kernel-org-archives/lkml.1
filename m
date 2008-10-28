Return-Path: <linux-kernel-owner+w=401wt.eu-S1753409AbYJ1Qis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbYJ1Qis (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 12:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbYJ1Qik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 12:38:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50472 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751954AbYJ1Qij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 12:38:39 -0400
Date: Tue, 28 Oct 2008 09:37:55 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Helge Hafting <helge.hafting@aitel.hist.no>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.28-rc2 i/o error on /dev/ttyUSB0
In-Reply-To: <4906F54A.7020909@aitel.hist.no>
Message-ID: <alpine.LFD.2.00.0810280928320.3386@nehalem.linux-foundation.org>
References: <alpine.LFD.2.00.0810261221350.3386@nehalem.linux-foundation.org> <4906F54A.7020909@aitel.hist.no>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 28 Oct 2008, Helge Hafting wrote:
>
> I have gps unit connected via USB-serial (pl2303).
> This does not work with 2.6.28-rc2
> 
> 2.6.27 is fine. I skipped 2.6.28-rc1 due to known breakage.
> I can test it if that might help.

Don't bother with -rc1, but bisecting it may be relevant. You might of 
course hit the breakage, but it's fairly unlikely.

That said, the whole "error on USB serial device" sounds like it's 
squarely in the "oops, kref's are screwed up" corner, and you should talk 
to Alan about your particular USB dongle. I bet that bisection would just 
show you one of the kref commits (eg 4a90f09b "tty: usb-serial krefs" or 
maybe 7d7b93c14 "tty: kref the tty driver object"). 

Alan, pls help.

		Linus
