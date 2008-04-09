Return-Path: <linux-kernel-owner+w=401wt.eu-S1754949AbYDINeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949AbYDINeX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 09:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753206AbYDINeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 09:34:15 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:47157 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752226AbYDINeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 09:34:15 -0400
Date: Wed, 9 Apr 2008 09:34:14 -0400
To: Arne Georg Gleditsch <arne.gleditsch@dolphinics.no>
Cc: Andi Kleen <andi@firstfloor.org>, Zhao Forrest <forrest.zhao@gmail.com>,
       discuss@x86-64.org, linux-kernel@vger.kernel.org, yhlu.kernel@gmail.com,
       mingo@elte.hu, ak@suse.de
Subject: Re: Does Linux have plan to support memory hole remapping?
Message-ID: <20080409133414.GA2160@csclub.uwaterloo.ca>
References: <ac8af0be0804090054w47f48ddel387d80a0331d16e1@mail.gmail.com> <87iqyro3rc.fsf@basil.nowhere.org> <kjmr6dfxsqf.fsf@pelargir.dolphinics.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <kjmr6dfxsqf.fsf@pelargir.dolphinics.no>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2008 at 11:50:00AM +0200, Arne Georg Gleditsch wrote:
> Hm, wouldn't the given e820 map and mtrr listing indicate that 512M were
> actually remapped to 32G+ in this case?

The mtrr does list the 512MB as being remapped.  It sais there was 32GB
starting at 0, and 512MB starting at 32GB, and then that there was an
uncacheable 512MB hole at 3.5GB.  So the mtrr does say everything looks
right.

The e820 map also shows it:
BIOS-e820: 0000000000000000 - 0000000000098c00 (usable)
       625,664 bytes
BIOS-e820: 0000000000100000 - 00000000dffa0000 (usable)
 3,756,654,592 bytes
BIOS-e820: 0000000100000000 - 0000000820000000 (usable)
30,601,641,984 bytes

Total of 34,358,922,240 bytes or 32767.221 MiB.  Seems rather close to
the full 32768 MiB in the system.  So looks to me like the mtrr and e820
covers all the ram.  Maybe the kernel looses some of it somewhere for
other purposes.

Isn't there usually a line in dmesg similar to this:
Memory: 1023120k/1048256k available (1927k kernel code, 24748k reserved, 868k data, 176k init)

Maybe it can show how much the kernel reserved for itself in this case.

-- 
Len Sorensen
