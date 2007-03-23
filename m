Return-Path: <linux-kernel-owner+w=401wt.eu-S1752615AbXCWAIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615AbXCWAIy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 20:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752619AbXCWAIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 20:08:54 -0400
Received: from smtpout.mac.com ([17.250.248.174]:60521 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615AbXCWAIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 20:08:53 -0400
In-Reply-To: <20070321161140.457a3cd7.akpm@linux-foundation.org>
References: <20061214223718.GA3816@elf.ucw.cz> <20061216094421.416a271e.randy.dunlap@oracle.com> <20061216095702.3e6f1d1f.akpm@osdl.org> <458434B0.4090506@oracle.com> <1166297434.26330.34.camel@localhost.localdomain> <20061219063413.GI24090@1wt.eu> <1166511171.26330.120.camel@localhost.localdomain> <20070106103331.48150aed.randy.dunlap@oracle.com> <459FF60D.7080901@zytor.com> <1168112266.2821.2.camel@entropy> <20070106121301.d07de0c9.akpm@osdl.org> <45A0041F.4060903@zytor.com> <20070319122740.286f602e.randy.dunlap@oracle.com> <20070319133613.9f4881db.akpm@linux-foundation.org> <45FEF5BC.90809@oracle.com> <45FF6189.9080508@zytor.com> <20070321160132.983812ac.randy.dunlap@oracle.com> <20070321161140.457a3cd7.akpm@linux-foundation.org>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <CDF579E6-342C-4B99-916A-3CE118ABD02F@mac.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "J.H." <warthog9@kernel.org>,
       kernel list <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCH] sysctl: vfs_cache_divisor
Date: Thu, 22 Mar 2007 20:07:56 -0400
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 21, 2007, at 19:11:40, Andrew Morton wrote:
> On Wed, 21 Mar 2007 16:01:32 -0700 Randy Dunlap  
> <randy.dunlap@oracle.com> wrote:
>> I prefer the fixed-point values for pressure and dirty* to having  
>> duplicated entries for each of them.  I'll proceed with that idea.
>
> Problem is, if a read of /proc/sys/vm/dirty_ratio is changed to  
> return 7.457 then existing userspace might get confused.
>
> This might be acceptable if we are careful to ensure that reads of / 
> proc/sys/vm/dirty_ratio will always return an integer if it was  
> previously initialised with an integer.

What about instead adding support for fractions (IE: "1/1000") in / 
proc/sys/vm/dirty_ratio?  If the denominator is 100, the default,  
then it prints in the form "$NUMERATOR", otherwise it prints answers  
of the form "$NUMERATOR/$DENOMINATOR".  Input could be of either  
form, with the kernel auto-setting the denominator to 100 if none is  
specified.

Cheers,
Kyle Moffett
