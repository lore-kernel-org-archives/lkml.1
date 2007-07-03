Return-Path: <linux-kernel-owner+w=401wt.eu-S1761469AbXGCU3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761469AbXGCU3n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 16:29:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758059AbXGCU3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 16:29:34 -0400
Received: from hobbit.corpit.ru ([81.13.94.6]:20759 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757891AbXGCU3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 16:29:33 -0400
Message-ID: <468AB1A7.9010201@msgid.tls.msk.ru>
Date: Wed, 04 Jul 2007 00:29:27 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: Some NCQ numbers...
References: <468392CE.6010206@msgid.tls.msk.ru> <468A06A0.1020802@gmail.com>
In-Reply-To: <468A06A0.1020802@gmail.com>
X-Enigmail-Version: 0.94.2.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Michael Tokarev wrote:
[]
>> A test drive is Seagate Barracuda ST3250620AS "desktop" drive,
>> 250Gb, cache size is 16Mb, 7200RPM.
[test shows that NCQ makes no difference whatsoever]

> And which elevator?

Well.  It looks like the results does not depend on the
elevator.  Originally I tried with deadline, and just
re-ran the test with noop (hence the long delay with
the answer) - changing linux elevator changes almost
nothing in the results - modulo some random "fluctuations".

In any case, NCQ - at least in this drive - just does
not work.  Linux with its I/O elevator may help to
speed things up a bit, but the disk does nothing in
this area.  NCQ doesn't slow things down either - it
just does not work.

The same's for ST3250620NS "enterprise" drives.

By the way, Seagate announced Barracuda ES 2 series
(in range 500..1200Gb if memory serves) - maybe with
those, NCQ will work better?

Or maybe it's libata which does not implement NCQ
"properly"?  (As I shown before, with almost all
ol'good SCSI drives TCQ helps alot - up to 2x the
difference and more - with multiple I/O threads)

/mjt
