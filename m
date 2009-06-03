Return-Path: <linux-kernel-owner+w=401wt.eu-S1756638AbZFCVpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638AbZFCVpK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 17:45:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754715AbZFCVo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 17:44:59 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:34589 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706AbZFCVo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 17:44:58 -0400
To: Greg KH <gregkh@suse.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 3 (driver core)
References: <20090603190952.2dd0cc70.sfr@canb.auug.org.au>
	<4A269BB2.4050508@oracle.com> <20090603212206.GA20804@suse.de>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 03 Jun 2009 14:44:55 -0700
In-Reply-To: <20090603212206.GA20804@suse.de> (Greg KH's message of "Wed\, 3 Jun 2009 14\:22\:06 -0700")
Message-ID: <m1skihm1pk.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: gregkh@suse.de, linux-kernel@vger.kernel.org, linux-next@vger.kernel.org, sfr@canb.auug.org.au, randy.dunlap@oracle.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@suse.de> writes:

> On Wed, Jun 03, 2009 at 08:50:10AM -0700, Randy Dunlap wrote:
>> Stephen Rothwell wrote:
>> > Hi all,
>> > 
>> > Looks like a real rush since -rc7 ...
>> 
>> 
>> drivers/built-in.o: In function `register_mem_sect_under_node':
>> (.text+0x1d305b): undefined reference to `sysfs_create_link_nowarn'
>> 
>> 
>> I can't find this function's implementation when CONFIG_SYSFS=y.
>
> Ah, it looks like this shows up when CONFIG_MEMORY_HOTPLUG_SPARSE is
> set.
>
> Eric, your patch, "sysfs: Remove now unnecessary error reporting
> suppression." caused this.  Turns out it is still used in the tree, and
> you forgot to remove the function from sysfs.h at the same time.
>
> I'm going to drop it, and the other two patches I took from you for
> sysfs, as it doesn't make sense to have them in the tree yet.
>
> Care to rework your series with this fixed?

Sure.

My apologies it looks like sysfs_create_link_nowarn grew an extra
user since last time I audited that patch thoroughly.

How I missed the header I don't know.

Eric
