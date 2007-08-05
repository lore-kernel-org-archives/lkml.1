Return-Path: <linux-kernel-owner+w=401wt.eu-S1759245AbXHEP3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759245AbXHEP3b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 11:29:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752528AbXHEP3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 11:29:24 -0400
Received: from Powered.by.Root24.eu ([81.169.180.23]:47903 "EHLO Root24.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752334AbXHEP3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 11:29:23 -0400
Reply-To: <jh2000@Root24.eu>
From: =?iso-8859-1?Q?J=F6rg_Hoffmann?= <jh2000@Root24.eu>
To: <linux-kernel@vger.kernel.org>
Subject: [Patch] panic.c
Date: Sun, 5 Aug 2007 17:28:45 +0200
Organization: Root24
Message-ID: <006701c7d775$53137cc0$6800a8c0@jhnotebook>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0068_01C7D786.169C4CC0"
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook, Build 10.0.4024
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.2180
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_0068_01C7D786.169C4CC0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hello everybody,
(This is the first time i send in a patch, so correct me if I=92m doing
something wrong)
This patch causes the cpu to stop instead of using an endless loop =
(I=92m
not sure if this works with the watchdog so please take a review).
The idea behind this is to keep the power usage on panic=92d machines
(without auto-reboot) low. Another point is in an Virtual Machine
environment the process of the VM is using 100% of the host-cpu. This
would stuck other programs or VMs. This patch brings the VM to stop and
keeps the cpu usage below 1%.
=A0
I have tested the patch in an VM, the only change is mdelay(); to
cpu_idle(); it doesn=92t need more libs and should have no special
depencies to consider.
The panic-blink doesn=92t work further so it might be removed if there =
is
no better way.
=A0
Maybe someone has an better idea for this =91problem=92
=A0
Greetings
J=F6rg Hoffmann
=A0

------=_NextPart_000_0068_01C7D786.169C4CC0
Content-Type: application/octet-stream;
	name="panic.c.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="panic.c.diff"

10a11,15=0A=
> =0A=
> /*=0A=
>  * Modification History kernel/panic.c=0A=
>  * 05/08/07	The Kernel stops the CPU on panic if the reboot=3D =
parameter isn't set to keep the cpu/power usage low.	- J=C3rg Hoffmann=0A=
>  */=0A=
22d26=0A=
< =0A=
137c141=0A=
< 		mdelay(1);=0A=
---=0A=
> 		cpu_idle();=0A=

------=_NextPart_000_0068_01C7D786.169C4CC0--


