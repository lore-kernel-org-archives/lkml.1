Return-Path: <linux-kernel-owner+w=401wt.eu-S1753621Ab0AQJ2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621Ab0AQJ2E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 04:28:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751655Ab0AQJ2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 04:28:01 -0500
Received: from lider.pardus.org.tr ([193.140.100.216]:51703 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab0AQJ17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 04:27:59 -0500
Message-ID: <4B52D822.1010700@pardus.org.tr>
Date: Sun, 17 Jan 2010 11:28:02 +0200
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Xiaotian Feng <dfeng@redhat.com>, damm@igel.co.jp,
       hsweeten@visionengravers.com, akpm@linux-foundation.org,
       venkatesh.pallipadi@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] clockevents: fix clockevent_devices list corruption
 after cpu hotplug
References: <1260450459-18072-1-git-send-email-dfeng@redhat.com> <alpine.LFD.2.00.0912101431380.3089@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0912101431380.3089@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:

> 
> I'm not happy about that churn. Why don't we simply scan the
> clockevent_devices list for leftovers of the dead CPU ?
> 
> Untested patch below solves the same problem.


Hi, I have 3 bug reports about a clockevent failure while halting the system (2.6.31.11 kernel).
It exactly pinpoints to the line 262 which got changed with this patch merged to 2.6.31.10 (and also 2.6.32.3):

[4406.986777] kernel BUG at kernel/time/clockevents.c:262!
[4406.986777] invalid opcode: 0000 [#1] SMP
[4406.986777] last sysfs file: /sysfs/module/ip_tables/initstate


All 3 systems have Pentium 4 processors with different clock speeds.

Here's a screenshot of the full stacktrace:
http://bugs.pardus.org.tr/attachment.cgi?id=4820

and the relevant bugzilla report:
http://bugzilla.kernel.org/show_bug.cgi?id=15073

Thanks,
Ozan Caglayan
Pardus Linux -- http://www.pardus.org.tr/eng
