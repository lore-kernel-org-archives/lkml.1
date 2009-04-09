Return-Path: <linux-kernel-owner+w=401wt.eu-S1756218AbZDIACw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbZDIACw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 20:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753498AbZDIACl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 20:02:41 -0400
Received: from fmailhost02.isp.att.net ([207.115.11.52]:36663 "EHLO
	fmailhost02.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583AbZDIACl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 20:02:41 -0400
X-Originating-IP: [69.76.240.125]
Message-ID: <49DD3B0F.2080108@lwfinger.net>
Date: Wed, 08 Apr 2009 19:02:23 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: alan-jenkins@tuffmail.co.uk, Rusty Russell <rusty@rustcorp.com.au>,
       Arjan van de Ven <arjan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       wireless <linux-wireless@vger.kernel.org>
Subject: Re: Regression in 2.6.30-rc1 since commit acae0515 - wireless broken
References: <49DC2DF5.3010603@lwfinger.net> <49DC31EA.8050208@linux.intel.com>	 <200904081631.09150.rusty@rustcorp.com.au>	 <49DCB976.4020200@lwfinger.net> <9b2b86520904081006m6e6b5276v834c3565b0f6f4c7@mail.gmail.com> <49DCDF9E.8000605@lwfinger.net> <49DD380B.5080101@oracle.com>
In-Reply-To: <49DD380B.5080101@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> 
> Here's a quick explanation (Linus explained this to me 6-8 years ago;
> I bet his was better than mine, but I can't find his).
> 
> 256 = 0x0100
> 
> Inside the kernel, a program's exit code/status is split into 2 8-bit fields,
> so this exit status is (0x01, 0x00).  The low 8 bits (0x00 in this example)
> store an internal code for why the program is exiting (or did exit).  E.g.:
> 
> 0xlow_7_bits = 0 => exited, exit status is in "high" 8 bits
> else 0x80 bit set => core dumped, else killed, with exit status in low 7 bits
> 
> 
> So it looks like /sbin/modprobe exited with an exit status of 1...
> whatever that means (fatal error or usage() printed or module not found).
> 
> 
> See kernel/[signal.c & exit.c] for uses of 0x80...

Thanks for the explanation. In all the cases where the returned value was
0x0100, the corresponding module does not exist. The comment is still wrong, but
at least non-zero is an error.

Larry

