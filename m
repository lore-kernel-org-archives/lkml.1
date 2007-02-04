Return-Path: <linux-kernel-owner+w=401wt.eu-S1752202AbXBDJxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202AbXBDJxu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 04:53:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbXBDJxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 04:53:49 -0500
Received: from wx-out-0506.google.com ([66.249.82.236]:2377 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196AbXBDJxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 04:53:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=EfwO9KdYvoC7bszaN/nFahY58xMRyl0moOHKbMOLoGeADm8PTkZ/43446/U/wJtHR5GSvwntJhR5zpN9wnw9Nc1takeMlDmb4aIx0cg3ho1ezKJ629gPABrbKPEQQCwpn2lcIy0fxtL4vXTr65SLBeHM5v2b76ZCRDjjsdirfeI=
Message-ID: <45C5AD27.5080008@gmail.com>
Date: Sun, 04 Feb 2007 18:53:43 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Keenan Pepper <keenanpepper@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Timeouts on ICH7 PATA drive with ata_piix; ide_generic works
 perfectly
References: <767314830702032132m4172ddfbmb2519ad90e7ae578@mail.gmail.com>
In-Reply-To: <767314830702032132m4172ddfbmb2519ad90e7ae578@mail.gmail.com>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Keenan Pepper wrote:
> I just upgraded the kernel on my System76 Gazelle laptop (basically an
> ASUS Z62FP without the Microsoft tax) and the hard drive began
> freezing every few minutes. I blacklisted ata_piix and the problem
> went away, so that really narrows down where the bug has to be. Here's
> the relevant part of the dmesg:
> 
> [  924.000000] ata1.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
> frozen
> [  924.000000] ata1.01: cmd a0/01:00:00:00:00/00:00:00:00:00/b0 tag 0
> cdb 0x25 data 8 in
> [  924.000000]          res 40/00:03:00:00:00/00:00:00:00:00/b0 Emask
> 0x4 (timeout)
> [  931.004000] ata1: port is slow to respond, please be patient (Status
> 0xd0)
> [  954.028000] ata1: port failed to respond (30 secs, Status 0xd0)

It seems that something is issuing READ_CAPACITY to your drive or trying
to open the device triggering media revalidation periodically and your
drive doesn't like it.  Your harddisk is sharing the channel with the
ODD so it can't be accessed till the command times out and the ODD gets
recovered.

* Does putting in a readable CD or DVD make any difference?

* Does the problem occur in single mode where no HAL or whatever is running?

PS: It *really* helps if you include full dmesg including the detection
messages and whole error messages when reporting bugs.  If you need
snippet of it to explain, copy that part but keep the whole dmesg at the
end.  Kernel developers are usually pretty good at filtering useful info
from tons of kernel messages.

-- 
tejun
