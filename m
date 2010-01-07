Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261Ab0AGLIl (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 7 Jan 2010 06:08:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752196Ab0AGLIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 06:08:40 -0500
Received: from fallback4.mail.ru ([94.100.176.42]:43108 "EHLO
	fallback4.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab0AGLIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 06:08:39 -0500
X-Greylist: delayed 658 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Jan 2010 06:08:39 EST
From: Kirill Afonshin <kirill_nnov@mail.ru>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        Jens Axboe <jens.axboe@oracle.com>,
        Linux-Kernel <linux-kernel@vger.kernel.org>,
        Shaohua Li <shaohua.li@intel.com>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: =?koi8-r?Q?Re=3A_[PATCH]_cfq-iosched=3A_non-rot_devices_do_not_need_read_queue__merging?=
Mime-Version: 1.0
X-Mailer: mPOP Web-Mail 2.19
X-Originating-IP: [95.37.217.228]
Date: Thu, 07 Jan 2010 13:56:40 +0300
References: <4e5e476b1001051348y4637986epb9b56958c738061a@mail.gmail.com>
In-Reply-To: <4e5e476b1001051348y4637986epb9b56958c738061a@mail.gmail.com>
Reply-To: Kirill Afonshin <kirill_nnov@mail.ru>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-Id: <E1NSq2i-0000wY-00.kirill_nnov-mail-ru@foot.mail.ru>
X-Spam: Not detected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think we should not rely on NCQ/non-NCQ or blk_queue_nonrot() because it may be incorrect:
try this:

find /sys/ -name rotational 2>/dev/null
find /sys/ -name rotational 2>/dev/null|xargs cat

all devices are reported as rotational for me including ram, loop and usb flash drive. Physical block size and optimal io size has invalid values for all my usb flash drives.
 
I think it would be better to do a short performance test before mount. It will provide all necessary information for io scheduler. We doesn't need information about NCQ and rotational. We need to predict how much time specific io operation will take in current context.

PS: I'm not native speaker.

Best regards,
Kirill Afonshin
