Return-Path: <linux-kernel-owner+w=401wt.eu-S1755451AbZE0UcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbZE0UcY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 16:32:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750928AbZE0UcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 16:32:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53159 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750868AbZE0UcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 16:32:13 -0400
Date: Wed, 27 May 2009 13:31:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Martin Knoblauch <knobi@knobisoft.de>
Cc: efault@gmx.de, viro@ZenIV.linux.org.uk, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kay.sievers@vrfy.org,
       shemminger@vyatta.com, jbarnes@virtuousgeek.org, matthew@wil.cx,
       mike.miller@hp.com
Subject: Re: Analyzed/Solved/Bisected: Booting 2.6.30-rc2-git7 very slow
Message-Id: <20090527133125.c36381b5.akpm@linux-foundation.org>
In-Reply-To: <488605.71443.qm@web32605.mail.mud.yahoo.com>
References: <488605.71443.qm@web32605.mail.mud.yahoo.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 May 2009 04:25:57 -0700 (PDT)
Martin Knoblauch <knobi@knobisoft.de> wrote:

>  FWIW, I compiled the CCISS driver into the kernel. This makes the second "/sys" line in /proc/mounts go away, dmesg attached. But does it prove anything? The initialization of the CCISS hardware now happens about 2 seconds earlier in the bootup sequence. Does this hint to a problem with CCISS, or just confirms that the whole issue is really timing dependent? Anyway, I add Mike to CC.
> 

It seems that the PCI change caused timing changes which triggered a
udev/sysfs/whatever problem, which manifests as the duplicated
/proc/mounts entry to turn up.

What we don't know (afaik) is why the kernel permitted two entries in
/proc/mounts.  That might be a bug.

It could be that if dual /proc/mounts problem gets fixed, everything
works OK - by intent or by accident, the userspace startup scripts may
then work acceptably.

I think Al asked you a few questions around the behaviour of mount(8)
and the mount syscall, so we could delve further into why /proc/mounts
is getting mucked up.  Did you end up running those tests?

