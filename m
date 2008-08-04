Return-Path: <linux-kernel-owner+w=401wt.eu-S1754880AbYHDNrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880AbYHDNrT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 09:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753259AbYHDNrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 09:47:04 -0400
Received: from nebensachen.de ([195.34.83.29]:55168 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627AbYHDNrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 09:47:01 -0400
X-Hashcash: 1:20:080804:alan@lxorguk.ukuu.org.uk::vr7ciEL680FSbLef:00000000000000000000000000000000000002rRk
X-Hashcash: 1:20:080804:htejun@gmail.com::Wg2yZh3WT9TITmTN:03NC2
X-Hashcash: 1:20:080804:jeff@garzik.org::G2afxLzamiZ3v6G6:002acV
X-Hashcash: 1:20:080804:bzolnier@gmail.com::XTcd8oEQO7sVeVjU:000000000000000000000000000000000000000000017ka
X-Hashcash: 1:20:080804:james.bottomley@hansenpartnership.com::pxOvw1Jvn61Wbb7o:00000000000000000000000053IZ
X-Hashcash: 1:20:080804:pavel@ucw.cz::Y+9LWocXcY8YlSlz:000002d+s
X-Hashcash: 1:20:080804:linux-ide@vger.kernel.org::2f8gLAn6E+RQB6KH:000000000000000000000000000000000000B/bx
X-Hashcash: 1:20:080804:linux-kernel@vger.kernel.org::gMuE6mxDQOnKvjX2:000000000000000000000000000000000E6M3
From: Elias Oltmanns <eo@nebensachen.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Pavel Machek <pavel@ucw.cz>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] libata: Implement disk shock protection support
References: <87prp1kvyy.fsf@denkblock.local>
	<20080726062142.29070.10413.stgit@denkblock.local>
	<4892B8FE.1070400@gmail.com>
	<20080801233459.11e9b254@lxorguk.ukuu.org.uk>
Date: Mon, 04 Aug 2008 15:43:38 +0200
In-Reply-To: <20080801233459.11e9b254@lxorguk.ukuu.org.uk> (Alan Cox's message
	of "Fri, 1 Aug 2008 23:34:59 +0100")
Message-ID: <87ljzcopyt.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> However, SATA or not, there simply isn't a way to abort commands in ATA.
>
>>  Issuing random command while other commands are in progress simply is
>> state machine violation and there will be many interesting results
>> including complete system lockup (ATA controller dying while holding the
>> PCI bus).  The only reliable way to abort in-flight commands are by
>> issuing hardreset.  However, ATA reset protocol is not designed for
>> quick recovery.  The machine is gonna hit the ground hard way before the
>> reset protocol is complete.
>
> Actually you cau can issue idle immediate on older ATA devices. I am not
> clear if that was stuck back into the current accelerometer friendly
> drives or not. Would need to check with IBLenovo

In ide_atapi_error() IDLE IMMEDIATE is issued even if busy bit is still
set. This made me hope that we could do something similar wrt disk head
unloading. However, since I haven't found anything about this in the
specs and considering Tejun's comments, I'm now wondering whether the
code in ide_atapi_error() isn't a little imprudent. Also, as long as
nothing definite is said about it in the specs, we can only issue IDLE
IMMEDIATE in parallel to other commands on devices we know to support
it, right?

Regards,

Elias
