Return-Path: <linux-kernel-owner+w=401wt.eu-S1755752AbYH1ReM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752AbYH1ReM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 13:34:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751768AbYH1Rdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 13:33:55 -0400
Received: from wbmler1.mail.xerox.com ([13.13.138.216]:51713 "EHLO
	wbmler1.mail.xerox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748AbYH1Rdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 13:33:54 -0400
X-Xerox-Source-Ip: 13.151.210.15
X-Xerox-Source-Name: usa7061gw002.na.xerox.net
X-Xerox-Reported-Name: USA7061GW002.na.xerox.net
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C90934.1740FDE4"
Subject: FW: [linux-pm] select with timeout across S3
Date: Thu, 28 Aug 2008 13:32:47 -0400
Message-ID: <556445368AFA1C438794ABDA8901891C09639B7A@USA0300MS03.na.xerox.net>
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
Thread-Topic: [linux-pm] select with timeout across S3
Thread-Index: AckJJJPdHrQSpEUXRbaAim5GwXxWlwADbpGg
From: "Leisner, Martin" <Martin.Leisner@xerox.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-pm@lists.linux-foundation.org>
X-OriginalArrivalTime: 28 Aug 2008 17:32:50.0124 (UTC) FILETIME=[17EEB8C0:01C90934]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C90934.1740FDE4
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

The behavior of linux (in both 2.4.x and 2.6.x) is when the processor
sleeps, timeouts on select don't take into account the sleep time,
only the run time.

For example, this program should pause for 10 minutes -- however
if we go into S3 in the middle its pausing for (10 minutes + time in
S3)

I saw this on both 2.6.20 and 2.6.22...

marty

-----Original Message-----
From: linux-pm-bounces@lists.linux-foundation.org
[mailto:linux-pm-bounces@lists.linux-foundation.org] On Behalf Of Pavel
Machek
Sent: Thursday, August 28, 2008 10:30 AM
To: Leisner, Martin
Cc: linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] select with timeout across S3

On Wed 2008-08-27 15:23:13, Leisner, Martin wrote:
> What's a good way to "wait" across a transition to/from processor
sleep
> (acpi S3 or other means)?
>=20
>=20
> It seems the timeouts on select(2) only deal with with time correctly
> when the processor is awake -- when the processor is sleeping its not
> subtracted from the request...
>=20
> The desirable behavior out of select would be for it to timeout
whenever
> the system wakes up if the desired interval has elapsed...

That sounds like a bug. Can you write small demo program and post it
to lkml?

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures)
http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
_______________________________________________
linux-pm mailing list
linux-pm@lists.linux-foundation.org
https://lists.linux-foundation.org/mailman/listinfo/linux-pm

------_=_NextPart_001_01C90934.1740FDE4
Content-Type: application/octet-stream;
	name="select.c"
Content-Transfer-Encoding: base64
Content-Description: select.c
Content-Disposition: attachment;
	filename="select.c"

I2luY2x1ZGUgPHN5cy9zZWxlY3QuaD4KI2luY2x1ZGUgPHN0ZGlvLmg+CgptYWluKCkKewoJc3Ry
dWN0IHRpbWV2YWwgdDsKCWludCByZXQ7CgoJdC50dl9zZWMgPSA2MCAqIDEwOwoJdC50dl91c2Vj
ID0gMDsKCglyZXQgPSBzZWxlY3QoMCwgTlVMTCwgTlVMTCwgTlVMTCwgJnQpOwoJcHJpbnRmKCJy
ZXQgPSAlZFxuIiwgcmV0KTsKfQoKCQo=

------_=_NextPart_001_01C90934.1740FDE4--
