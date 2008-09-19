Return-Path: <linux-kernel-owner+w=401wt.eu-S1757114AbYISIoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114AbYISIoN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 04:44:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751016AbYISIn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 04:43:58 -0400
Received: from cnmailgate04.alcatel-sbell.com.cn ([211.144.215.47]:59380 "EHLO
	cnshjsmin03.cn.alcatel-lucent.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750868AbYISIn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 04:43:57 -0400
X-AuditID: ac189297-a9f7fbb000000fe5-47-48d37430338d
Message-ID: <48D36622.8080307@alcatel-lucent.com>
Date: Fri, 19 Sep 2008 16:43:14 +0800
From: gshan <gshan@alcatel-lucent.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: bash hanged on serial port
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Sep 2008 08:43:12.0525 (UTC) FILETIME=[C0186BD0:01C91A33]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All, When I'm booting my card while keeping connect to serial port, 
everything is ok.
However, when I issued "reboot" command and disconnect connection to 
serial port and
waited for several minutes, shell (bash) hanged. Finally I found it 
hanged in following line
of /etc/init.d/rc.

stty onlcr 0>&1

Then I replace this line in /etc/init.d/rc with "strace stty onlcr 0>&1" 
and got following cached
output. However sys_ioctl of kernel wasn't called ever.

brk(0x1003b000)                         = 0x1003b000
brk(0x1003c000)                         = 0x1003c000
ioctl(0, TCGETS, {B9600 opost isig icanon echo ...}) = 0
ioctl(0, TCGETS, {B9600 opost isig icanon echo ...}) = 0
ioctl(0, TCSETSW


