Return-Path: <linux-kernel-owner+w=401wt.eu-S1761552AbYBZADl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761552AbYBZADl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 19:03:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757690AbYBZADd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 19:03:33 -0500
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:39789 "EHLO
	QMTA04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757582AbYBZADc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 19:03:32 -0500
X-Authority-Analysis: v=1.0 c=1 a=bojhYoMd2USPMMK5XVEeMQ==:17
 a=I32hiVmxfGwGof6X2SAA:9 a=C5d9wZs2RrfI6Fr3wDU-BdSAQT0A:4 a=8t_6ZPhla3UA:10
From: kelk1@comcast.net (Quel Qun)
To: Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
Cc: Dave Young <hidave.darkstar@gmail.com>,
       Marcel Holtmann <marcel@holtmann.org>,
       LKML <linux-kernel@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Kernel oops with bluetooth usb dongle
Date: Tue, 26 Feb 2008 00:03:28 +0000
Message-Id: <022620080003.1247.47C35750000085C8000004DF2207300793CE05040A05@comcast.net>
X-Mailer: AT&T Message Center Version 1 (Oct 30 2007)
X-Authenticated-Sender: a2VsazFAY29tY2FzdC5uZXQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 -------------- Original message ----------------------
From: Thomas Gleixner <tglx@linutronix.de>
> On Fri, 22 Feb 2008, David Woodhouse wrote:
>  
> > On Fri, 2008-02-22 at 08:23 +0100, Thomas Gleixner wrote:
> > > 
> > > +       del_timer(&conn->info_timer);
> > > +
> > >         hcon->l2cap_data = NULL;
> > >         kfree(conn);
> > 
> > Shouldn't that be del_timer_sync() ?
> 
> Hmm, probably yes.
> 
Hi,

Great news: only adding adding del_timer_sync() to 2.6.25-rc3 does prevent the crash.

Bad news: I still cannot use the device.

hcitool inq, hcitool scan, hcitool name <btaddr> and hcitool info <btaddr> 
commands work.

hcitool cc <btaddr>, sdptool <btaddr>, rfcomm connect command fail, most of them 
with a 'Connection reset by peer' error.

# rpm -q bluez-utils
bluez-utils-3.27-1mdv2008.1

Thank you,
--
Eric
