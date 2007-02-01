Return-Path: <linux-kernel-owner+w=401wt.eu-S1422804AbXBAL2K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422804AbXBAL2K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 06:28:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422810AbXBAL2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 06:28:10 -0500
Received: from patroclus.tjworld.net ([84.12.34.246]:55482 "EHLO phwoarrr.tv"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422804AbXBAL2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 06:28:09 -0500
Subject: Re: [PATCH 1/1] filesystem: Disk Errors at boot-time caused by
	probe of partitions
From: TJ <linux@tjworld.net>
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
In-Reply-To: <45C16AA5.7050808@shaw.ca>
References: <fa.vUjkpPQXmle+uox6D228qG85KCU@ifi.uio.no>
	 <45C16AA5.7050808@shaw.ca>
Content-Type: text/plain
Organization: TJworld
Date: Thu, 01 Feb 2007 11:27:49 +0000
Message-Id: <1170329269.30563.10.camel@butch.lan.tjworld.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
X-Server: High Performance Mail Server - http://surgemail.com r=-2006397171
X-Authenticated-User: tj@tjworld.net 
X-DNS-Paranoid: DNS lookup didn't match (84.12.34.243)->(dns2.hornytunes.com)->()
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-01-31 at 22:20 -0600, Robert Hancock wrote:

> It seems pretty unlikely that telling a hard drive to seek past its 
> capacity would cause it to damage itself, that would be some pretty 
> moronic firmware. Though, you never know - if it's true, let me know 
> what kind of drives these are, so I know never to buy one :-)
> 

Hi Robert,

Yes, I'd have expected that too. I'm particularly surprised the
drive-logic doesn't refuse to move the heads and just report the failure
based on the LBA value.

These are Maxtor drives, but its also happened with IBM drives in
another system with similar configuration, as a test.

During the bug-hunt (which started end of December) I built about 100
kernels trying to track down the root cause, and therefore went through
many reboot cycles.

Several times the drives were 'knocked out' and would refuse to
initialise during POST. The only remedy was to leave the system powered
down for a while - the rest seemed to do them good.

The difficulty I had in debugging was the errors are generated on the
work-queue and interrupt handling side, and it was extremely difficult
to pin-point the root cause because the symptoms (drive seek errors)
occur well after the partition tables have been scanned, and also repeat
themselves several times during system start-up.

TJ.

