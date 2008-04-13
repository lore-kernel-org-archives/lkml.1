Return-Path: <linux-kernel-owner+w=401wt.eu-S1759269AbYDMN7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759269AbYDMN7h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 09:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757434AbYDMN71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 09:59:27 -0400
Received: from hpsmtp-eml15.kpnxchange.com ([213.75.38.115]:1832 "EHLO
	hpsmtp-eml15.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757190AbYDMN70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 09:59:26 -0400
From: Frans Pop <elendil@planet.nl>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: No IDE drivers loaded for Toshiba Satellite 320 CDS
Date: Sun, 13 Apr 2008 15:59:20 +0200
User-Agent: KMail/1.9.9
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
References: <200804021524.27222.elendil@planet.nl> <200804031947.07674.elendil@planet.nl> <48017248.4030600@gmail.com>
In-Reply-To: <48017248.4030600@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804131559.21664.elendil@planet.nl>
X-OriginalArrivalTime: 13 Apr 2008 13:59:24.0310 (UTC) FILETIME=[947AD360:01C89D6E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 13 April 2008, Tejun Heo wrote:
> Please be advised that some modern controllers are dual interfaced.
> Native one and legacy one.  The legacy one is SFF compliant and
> depending on configuration may appear at legacy IO addresses, so if you
> aren't careful, you can end up with two drivers driving the same
> hardware which usually doesn't end too well.  Loading generic drivers
> w/o knowing that it's needed is quite dangerous.  I would strongly
> advise against it.

I totally agree. The problem being discussed here is exactly how to know it 
is needed. If you have better suggestions for that, I'd appreciate it.

As you specifically say "modern controllers", I suspect that the problem is 
limited as I guess those are fairly unlikely to be found in machines that 
have an ISA bus.

I also think the way I've implemented in the Debian installer should be 
relatively safe:
1) ide-generic is only loaded _after_ any otherwise detected modules
2) it is only loaded if an ISA bus is present
3) it is only included in the initrd for the installed system if loading it
   in the installer resulted in additional block devices appearing

I would unload ide-generic in the installer if no additional block devices 
appear, but unfortunately that's not possible as it is marked "permanent".

By loading it after any other drivers I expect there will be no issues 
during the installation (as the other driver will already have claimed the 
device). Making sure it is only loaded for the installed system if actually 
needed should avoid problems there.

ATM I can only see this causing problems in systems that need both 
ide-generic and some other driver as adding ide-generic in the initrd is 
likely to result in it being loaded before that other driver.

Again, if anyone has a better suggestion how to implement this (preferably 
without asking the user whether he has a device that needs ide-generic, 
which most users are unlikely to know anyway), I'd appreciate it.

Cheers,
FJP
