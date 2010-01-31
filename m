Return-Path: <linux-kernel-owner+w=401wt.eu-S1751884Ab0AaCI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884Ab0AaCI6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 21:08:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400Ab0AaCI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 21:08:57 -0500
Received: from mail-pz0-f172.google.com ([209.85.222.172]:57337 "EHLO
	mail-pz0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab0AaCIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 21:08:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=cRCR+DrxZF7zt3mmezrkaTzSrXpWgrGk5GlUwPfS9b1kh9aVO9/sUJXi4yCyvrbJ3w
         a3nEPa6vyv9NPvcdRwzqkT7qg+Qrh/TaKlV4ZFfjylJywf+CMrm7d2C/DIcJkzHsTfqA
         09U6NGkFAncM8Y4c6bRhHK/PaWtH0E1PZ8+nE=
Message-ID: <4B64E732.3090507@gmail.com>
Date: Sun, 31 Jan 2010 10:13:06 +0800
From: "Helight.Xu" <helight.xu@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20091109)
MIME-Version: 1.0
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org,
       Patrick McHardy <kaber@trash.net>, coreteam@netfilter.org
CC: linux-kernel@vger.kernel.org
Subject: [REPORT] may be wrong place #endif in include/linux/netfilter_ipv4.h
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi all gys:

    when I make LKM with netfilter on "NF_IP_PRE_ROUTING" point, but it 
was reported that "NF_IP_PRE_ROUTING" is not defined.

    but I am surely including <linux/netfilter_ipv4.h>, when I opened 
include/linux/netfilter_ipv4.h I found that
"NF_IP_PRE_ROUTING" is in this lable :
#ifndef __KERNEL__
.....
/* IP Hooks */
/* After promisc drops, checksum checks. */
#define NF_IP_PRE_ROUTING       0
/* If the packet is destined for this box. */
#define NF_IP_LOCAL_IN          1
/* If the packet is destined for another interface. */
#define NF_IP_FORWARD           2
/* Packets coming from a local process. */
#define NF_IP_LOCAL_OUT         3
/* Packets about to hit the wire. */
#define NF_IP_POST_ROUTING      4
#define NF_IP_NUMHOOKS          5
#endif /* ! __KERNEL__ */

So I think the "endif" is ended a little early!

-- 
Zhenwen Xu - Seven Helight
Home Page: http://zhwen.org

