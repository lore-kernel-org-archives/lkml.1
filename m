Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757840Ab0BCU0M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 15:26:12 -0500
Received: from zrtps0kp.nortel.com ([47.140.192.56]:38581 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383Ab0BCU0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 15:26:07 -0500
Message-ID: <4B69DAAB.9070301@nortel.com>
Date: Wed, 03 Feb 2010 14:20:59 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Need help tracking down memory consumption increase
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Feb 2010 20:25:55.0837 (UTC) FILETIME=[16C1C2D0:01CAA50F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm seeing a slow increase in memory consumption and I'm trying to
narrow down the possible causes.

In my test, I got the system into steady-state and then started
monitoring /proc/meminfo.

After 14 hrs:
MemFree had dropped by 594MB.
Active + Inactive + Slab increased by 594MB
Buffers + Cached + AnonPages + Mapped + Slab increased by 290MB

The other categories in /proc/meminfo didn't change significantly.

I've done some experimenting and it seems that pages allocated in the
kernel via alloc_page() and friends don't show up in /proc/meminfo
except that they're deducted from the MemFree category.  Specifically,
they don't seem to show up in the Active/Inactive category.  Can someone
confirm this?

Given the above, what types of pages are in Active/Inactive other than
Buffers + Cached + AnonPages + Mapped?

Thanks,

Chris
