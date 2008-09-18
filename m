Return-Path: <linux-kernel-owner+w=401wt.eu-S1755706AbYIRHYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706AbYIRHYU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 03:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751809AbYIRHYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 03:24:12 -0400
Received: from relay03.mail-hub.dodo.com.au ([123.2.6.238]:56809 "EHLO
	relay03.mail-hub.dodo.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751626AbYIRHYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 03:24:11 -0400
From: Grant Coady <grant_lkml@dodo.com.au>
To: linux-kernel@vger.kernel.org
Subject: Query: is there an official location for jiffies per second value?
Date: Thu, 18 Sep 2008 17:23:58 +1000
Organization: http://bugsplatter.id.au/
Reply-To: Grant Coady <gcoady.lk@gmail.com>
Message-ID: <5b04d4pl2658h9duetqehv5tklog1v5f2s@4ax.com>
X-Mailer: Forte Agent 2.0/32.652
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

I found I can get jiffies per second with this on one box:

grant@deltree:~$ uname -r
2.6.26.5a

grant@deltree:~$ awk 'FNR==NR{up=$1};/^jiffies:/{print up, $2, $2/up}' \
	/proc/uptime /proc/timer_list
420389.04 126026727 299.786


But this value is very different on another box:

grant@pooh64:~$ uname -r
2.6.26.5a

grant@pooh64:~$ awk 'FNR==NR{up=$1}/^jiffies:/{print up, $2, $2/up}' \
	/proc/uptime /proc/timer_list
73830.36 4317026409 58472.2
73830.36 4317026409 58472.2

Is there a reliable way to determine this jiffies value across different 
x86 boxes?

The 'sysconf(_SC_CLK_TCK)' doesn't return the right answer either.  It 
says 100Hz when it is 300Hz.

Thanks,
Grant.
