Return-Path: <linux-kernel-owner+w=401wt.eu-S1752688AbYHBDG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688AbYHBDG4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 23:06:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753084AbYHBDGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 23:06:39 -0400
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:42759 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752866AbYHBDGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 23:06:38 -0400
Message-ID: <4893CF3D.1070504@lwfinger.net>
Date: Fri, 01 Aug 2008 22:06:37 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: "David S. Miller" <davem@davemloft.net>
CC: wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: p54usb broken by commit b19fa1f
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In testing 2.6.27-rc1, I found that p54usb caused my machine to freeze. A few
times, I was able to use the KDE system status applet to see that the system was
using essentially 100% of the CPU's. One other time, the system responded a 
little - enough for me to see tha wpa_supplicant was consuming 100% of the my 
AMD Turion 64 X2 running an x86_64 kernel. From bisection, the problem is due to

commit b19fa1fa91845234961c64dbd564671aa7c0fd27
Author: David S. Miller <davem@davemloft.net>
Date:   Tue Jul 8 23:14:24 2008 -0700

     net: Delete NETDEVICES_MULTIQUEUE kconfig option.

     Multiple TX queue support is a core networking feature.

     Signed-off-by: David S. Miller <davem@davemloft.net>

Obviously, something in the driver cannot handle multiqueues, but I
have not found anything, and I have not been able to get any logged events that
show what is going wrong.

Thanks,

Larry

