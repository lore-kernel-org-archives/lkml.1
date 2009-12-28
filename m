Return-Path: <linux-kernel-owner+w=401wt.eu-S1751357AbZL1Ajp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751357AbZL1Ajp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 19:39:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751151AbZL1Ajo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 19:39:44 -0500
Received: from smtp823.mail.ird.yahoo.com ([217.146.188.233]:48764 "HELO
	smtp823.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751271AbZL1Ajn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 19:39:43 -0500
X-Yahoo-SMTP: wO4aNJCswBB5athVY5koleRHnQGAGXzypUn810ZIOib5snxb3dzfDFiUTzJ8
X-YMail-OSG: d.SIZvYVM1kJIwV8EcWcw2_Z._OHZunhmQSohlz1Obbya_Be5qT_JfTff1OOiN.GuaMV6taz5ZdOoAdc.nPPy_kIs.M6RYOXRnDf5PToD8p3yrspAOuQ.8OCjg4DwvP8GTBimg.21gOy11kTMFDb2RwQLKHKmCicLqWHWHtycww0XOlAa7wrggWhU.UFleNOB12W6_diVA--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4B37FCB3.9000800@linuxfromscratch.org>
Date: Mon, 28 Dec 2009 00:32:51 +0000
From: Matthew Burgess <matthew@linuxfromscratch.org>
Organization: Linux From Scratch
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: netdev@vger.kernel.org
CC: davem@davemloft.net, ben@decadent.org.uk, linux-kernel@vger.kernel.org
Subject: Compilation issues using netlink.h
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The test case below simplifies a failure I see when trying to compile 
strace using kernel headers from Linux-2.6.32.2:

#include <linux/netlink.h>
struct sockaddr_nl nl;
int main() {
   return 0;
}

$ gcc -o test test.c
In file included from test.c:1:
/usr/include/linux/netlink.h:34: error: expected 
specifier-qualifier-list before 'sa_family_t'

The comment in netlink.h suggests that 'sa_family_t' is expected to be 
found in linux/socket.h, but since commit 9c501935a3 ("net: Support 
inclusion of <linux/socket.h> before <sys/socket.h>") that appears to 
not be true anymore, it's now in sys/socket.h.  Sure enough, if I change 
the include in netlink.h to pull in sys/socket.h instead of 
linux/socket.h, that enables the test case (and strace) to compile 
again, but I wasn't sure if it was really the right thing to do.

Thanks,

Matt.
