Return-Path: <linux-kernel-owner+w=401wt.eu-S1756090AbXKFM5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090AbXKFM5q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 07:57:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754578AbXKFM5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 07:57:38 -0500
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:58332 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153AbXKFM5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 07:57:37 -0500
Message-ID: <4730649E.2020405@linux.vnet.ibm.com>
Date: Tue, 06 Nov 2007 18:27:02 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org, pbadari@us.ibm.com,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: mm snapshot broken-out-2007-11-06-02-32.tar.gz uploaded - build
 fails on powerpc
References: <200711061033.lA6AXrhT018804@imap1.linux-foundation.org>
In-Reply-To: <200711061033.lA6AXrhT018804@imap1.linux-foundation.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@linux-foundation.org wrote:
> powerpc-move-_rtc_time-routines-under-config_adb_cuda.patch

  CC      net/9p/error.o
arch/powerpc/platforms/powermac/time.c:168: error: implicit declaration of function ‘from_rtc_time’
arch/powerpc/platforms/powermac/time.c:225: error: implicit declaration of function ‘to_rtc_time’
make[2]: *** [arch/powerpc/platforms/powermac/time.o] Error 1
make[1]: *** [arch/powerpc/platforms/powermac] Error 2
make: *** [arch/powerpc/platforms] Error 2

The above patch causes the build failure, because the from_rtc_time() and to_rtc_time() are
moved under the ifdef CONFIG_ADB_CUDA, but they are begin called in the pmu_set_rtc_time() and
pmac_get_rtc_time() under CONFIG_ADB_PMU.

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
