Return-Path: <linux-kernel-owner+w=401wt.eu-S1758134AbYDBFT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134AbYDBFT2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 01:19:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbYDBFTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 01:19:20 -0400
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:39226 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbYDBFTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 01:19:19 -0400
X-Greylist: delayed 572 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Apr 2008 01:19:19 EDT
Date: Wed, 2 Apr 2008 08:09:44 +0300 (EEST)
From: Kai Makisara <Kai.Makisara@kolumbus.fi>
X-X-Sender: makisara@kai.makisara.local
To: Carlo Nyto <carlonyto@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Slow tape drive timeout
In-Reply-To: <9d95d80e0804011330w53652286j1349ef7fda29bedb@mail.gmail.com>
Message-ID: <alpine.LSU.1.10.0804020758230.6904@kai.makisara.local>
References: <9d95d80e0804011330w53652286j1349ef7fda29bedb@mail.gmail.com>
User-Agent: Alpine 1.10 (LSU 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Antivirus: VAMS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Apr 2008, Carlo Nyto wrote:

> I am experiencing a two minute timeout open()ing a tape device when
> there is no tape in the drive.
> 
> open() with O_NONBLOCK succeeds immediately, however.
> 
This is how open() is supposed to work according to standards (e.g., SUS) 
if O_NONBLOCK is supported. (Well, actually open() should wait 
indefinitely but the non-linux systems I tested had a timeout.) The linux 
st driver was changed to comply with standards at 2.5.3. I.e., the 2.4 
kernels did return immediately but the 2.6 kernels have always waited.

> The problem is that I am trying to set up Legato on a system that has
> multiple tape drives. For certain common operations, Legato tries to
> open() each tape drive multiple times. On a system with multiple tape
> drives, this adds up to a significant amount of time wasted due to
> this timeout.
> 
You are not the only person who has noticed this. At work we had to 
install a distribution using 2.4 kernel to our backup server in order to 
use Legato ;-(

But this is a Legato problem, not a kernel problem.

> Solaris does not have this problem, and Legato support advises that
> they are at the mercy of the operating system.
> 
Solaris does return EIO. Either it does not support O_NONBLOCK or it is 
not compliant with SUS.

Legato would not be so much "at the mercy of the operating system" if they 
would write their software to work according to standards, not according 
to some operating system.

-- 
Kai
