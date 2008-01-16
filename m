Return-Path: <linux-kernel-owner+w=401wt.eu-S1754781AbYAPU03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754781AbYAPU03 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 15:26:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754116AbYAPU0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 15:26:17 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:51949 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826AbYAPU0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 15:26:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=XLvIdHn64e/ZoqKPRDZEUy54C/Nn01TmMrlXBK5xfXNS+r3+2s/bURjmuMsqx8xR8mcxNhfD1VQ5IEPLbmnHK0KZWsgk5jzP0YUSNf9rRlySicbtvVpx4JREcTFDkLFA+7DNV0i3qaGGrlNdqH2pA4zIqLdjRSoCO0/yIsmylyc=
From: Balaji Rao <balajirrao@gmail.com>
Organization: NITK
To: linux-kernel@vger.kernel.org
Subject: setting jiffies as the clocksource stops time
Date: Thu, 17 Jan 2008 02:09:42 +0530
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801170209.42138.balajirrao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When i set jiffies as the current_clocksource, date(1) tells me that wallclock time has stopped, and soon after that, the 
system becomes unresponsive. This is not seen with CONFIG_NO_HZ disabled.

This happens in 2.6.24-rc4,rc5, and even in rc8.

I wonder how can jiffies be used as a clocksource.. Its value depends on the tick and when we turn off ticks, we would stop 
incrementing jiffies and when we come come out of idle, we update the jiffies by reading the current_clocksource which now 
is 'jiffies', and hence jiffies wouldn't get updated. Could this be the explanation ?

I also encountered the same problem when i ran the kernel in qemu, and set pit as the current_clocksource. Why does this 
happen ?

So, i think should we unregister jiffies as a clocksource when we go into NO_HZ ?

Thomas, Ingo what are your thoughts on this ?

regards,
balaji rao
