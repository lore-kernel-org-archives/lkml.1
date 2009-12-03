Return-Path: <linux-kernel-owner+w=401wt.eu-S1755661AbZLCDDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661AbZLCDDQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 22:03:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754688AbZLCDDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 22:03:15 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46795 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291AbZLCDDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 22:03:14 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.4.0
Message-ID: <4B172ACE.7080806@np.css.fujitsu.com>
Date: Thu, 03 Dec 2009 12:04:46 +0900
From: Jin Dongming <jin.dongming@np.css.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Simon Kagstrom <simon.kagstrom@netinsight.net>
CC: LKLM <linux-kernel@vger.kernel.org>
Subject: Question about kmsg_dump for OOPS
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Simon

I am Jin Dongming.

I have a question about kmsg_dump which needs your help.
The question is as following:
    Why not put the kmsg_dump() for OOPS into oops_end() and before the branch
    of crash_kexec()?

The reason for the question is as following:
    Now the kmsg_dump() for OOPS is added in oops_exit(). When OOPS happened,
    kernel will call oops_end(). If the crash_kexec() is executed first in
    oops_end(), the oops_exit() could not be called. And also the kmsg_dump()
    for PANIC could not be executed. So I think that the kmsg_dump() for OOPS
    will lose its real meaning.
    
    The function tree for OOPS is as following:
      oops_end()
        |
        |-- if (crash_kexec is valid)
        |      |
        |      |-- crash_kexec()    ==> reboot (and the following function will
        |                                       not be executed)
        |
        |-- oops_exit
        |      |
        |      |-- kmsg_dump(OOPS)
        |
        |-- if (panic is valid)
        |      |
        |      |-- kmsg_dump(PANIC)
        |

    The function tree for PANIC is as following:
      panic()
        |
        |-- kmsg_dump(PANIC)
        |
        |-- crash_kexec()
        |
        |-- notifier()


When kernel paniced, kmsg_dump() for PANIC is executed before crash_kexec(). So
I think before crash_kexec() is executed, kmsg_dump() for OOPS should be called
too. How do you think?

Best regards,
Jin Dongming

