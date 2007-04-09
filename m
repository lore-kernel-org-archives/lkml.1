Return-Path: <linux-kernel-owner+w=401wt.eu-S1753558AbXDIWWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558AbXDIWWX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 18:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbXDIWWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 18:22:23 -0400
Received: from iasrv1.idleaire.net ([63.78.244.180]:52516 "EHLO
	iasrv1.idleaire.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558AbXDIWWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 18:22:22 -0400
Subject: Re: I give up
From: Dave Dillow <dave@thedillows.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Jeff Garzik <jeff@garzik.org>
In-Reply-To: <Pine.LNX.4.61.0704092334410.22295@yvahk01.tjqt.qr>
References: <200704091007.58535.gene.heskett@gmail.com>
	 <Pine.LNX.4.61.0704091848150.21426@yvahk01.tjqt.qr>
	 <461A71FA.40900@zytor.com> <200704091538.44253.gene.heskett@gmail.com>
	 <Pine.LNX.4.61.0704092334410.22295@yvahk01.tjqt.qr>
Content-Type: text/plain
Date: Mon, 09 Apr 2007 18:22:10 -0400
Message-Id: <1176157330.4767.12.camel@dillow.idleaire.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 (2.6.3-1.fc5.5) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Apr 2007 22:21:37.0494 (UTC) FILETIME=[706A4F60:01C77AF5]
X-TM-AS-Product-Ver: SMEX-7.0.0.1345-3.6.1039-14858.000
X-TM-AS-Result: No--8.354800-8.000000-31
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-09 at 23:35 +0200, Jan Engelhardt wrote:
> On Apr 9 2007 15:38, Gene Heskett wrote:
> >On Monday 09 April 2007, H. Peter Anvin wrote:
> >>Jan Engelhardt wrote:
> >>> dm is on 254 for me.. in opensuse with a 2.6.20 that is. I wonder why
> >>> it even moves around. However, even then, those who use udev and
> >>> device names rather than (major,minor) tuples should not have any
> >>> problem.
> >>
> >>It moves around because someone at some point thought it was a great
> >>idea to assign dynamic majors to core functionality.
> >>
> >What were they smoking, I want some of that!
> 
> Do you actually use udev?

udev doesn't help the problem he is having (and he is using it, since he
is using Fedora).

His problem is that GNU tar stores the device number of the file in a
database that it uses to perform incremental updates, and considers the
file new (and re-dumps it) when the device number changes.

So, when he changes the kernel config, adding any block device that uses
a dynamic major (and is loaded before device-mapper), or goes between
kernels that have the reserve-LANANA numbers patch, his incremental
dumps become full ones because device-mapper gets a different dynamic
major.
-- 
Dave Dillow <dave@thedillows.org>

