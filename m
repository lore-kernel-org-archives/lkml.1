Return-Path: <linux-kernel-owner+w=401wt.eu-S1754201AbZDUHOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbZDUHOH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 03:14:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbZDUHNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 03:13:52 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:45337 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751644AbZDUHNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 03:13:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=kx2FtPSSIWPahZQm194KEDRk+Oh0K1Hwq5r0re933D1PRgCvb4X7xY70CvS2kMaYnWir4/R5IZ3Ijpv0z14qWUSIrzkjVkBgb3VBSzFqJBqLc0zL0cOnLaVfUaJptIABAR1TW2D9qrzXoulklXB/+hl6xBCNwDtST+ohAHuhYZ4=  ;
X-YMail-OSG: nDlqUUAVM1mAVR5EYTXZ6ufHS4pDWjCMxbWQKUsSw9SbSLbCNKIto61_KK7yDQkbO72clgmU_vbGw8oFScaNFY7iT6C_qDca8uCPjc91LK.U7S4vjHiLDqnDzT1Uh_h3GuJ9TmCbGdEzaHOTLUqRD588xz9AONMTTS98Mnfpp1Q9lr.oE02HSg5Dg7ERFdjG6Q91p8aJxj3m8RBq6aNIGsu9gAwrSI0d5uIxdPm4Xzwc4L1XTuPZJhqLfg0QbjZF5dmWnIfaqOJDKSWFJpfifH67H0p.mFcTuy_3bXUamJgazTdGJd61
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: Wait for console to become available, v3.2
Date: Tue, 21 Apr 2009 00:13:48 -0700
User-Agent: KMail/1.9.10
Cc: David VomLehn <dvomlehn@cisco.com>, Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux USB Mailing List <linux-usb@vger.kernel.org>,
       Linux Embedded Mailing List <linux-embedded@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20090420234006.GA1958@cuplxvomd02.corp.sa.net> <20090421064346.GB8020@elte.hu>
In-Reply-To: <20090421064346.GB8020@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904210013.48551.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 April 2009, Ingo Molnar wrote:
> The proper approach would be to use one of the async_synchronize*() 
> facilities in kernel/async.c to properly order the opening of the 
> console with device init.

Stepping back a moment from "how" to make sure "what" is agreed on.

I think I see three scenarios here:

 - Classic PC or server, where there's a meaningful console;

 - Deeply embedded systems, where there isn't;

 - Development stages of "deeply embedded", where there *may* be one.

If that's correct, then async_synchronize() isn't a full answer...

I think a fair number of cases can be papered over with a serial
console with no hardware flow control, which isn't hooked up to
anything.  Maybe the board needs a test/development jig to get one;
without it, the "console" bits spill out into the aether.  Linux
can dump bits to ttyS0, which will act like /dev/null.

But the problem case here seems to be one where such un-hooked-up
serial ports are not realistic options.  Which is why the regression
in USB console functionality has been troublesome.


Is that correct?

- Dave
