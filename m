Return-Path: <linux-kernel-owner+w=401wt.eu-S1751870AbXCUIQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870AbXCUIQk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 04:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668AbXCUIQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 04:16:40 -0400
Received: from [218.104.33.231] ([218.104.33.231]:3188 "HELO
	centecnetworks.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with SMTP id S1751870AbXCUIQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 04:16:39 -0400
X-Greylist: delayed 954 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Mar 2007 04:16:39 EDT
Message-ID: <4600E5E0.3020507@centecnetworks.com>
Date: Wed, 21 Mar 2007 15:59:28 +0800
From: Miao Qingjun <qmiao@centecnetworks.com>
User-Agent: Thunderbird 1.5.0.5 (Windows/20060719)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: tpacket_rcv
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Can anybody explain what the following code does and why needs it??

Thanks

tpacket_rcv()
{
....
h->tp_status = status;
smp_mb();

{
struct page *p_start, *p_end;
u8 *h_end = (u8 *)h + macoff + snaplen - 1;

p_start = virt_to_page(h);
p_end = virt_to_page(h_end);
while (p_start <= p_end) {
flush_dcache_page(p_start);
p_start++;
}
}

sk->sk_data_ready(sk, 0);
...
}

