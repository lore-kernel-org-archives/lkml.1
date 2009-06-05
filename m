Return-Path: <linux-kernel-owner+w=401wt.eu-S1754311AbZFEDaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311AbZFEDaK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 23:30:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753538AbZFED35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 23:29:57 -0400
Received: from mga03.intel.com ([143.182.124.21]:61020 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752999AbZFED35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 23:29:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,308,1241420400"; 
   d="scan'208";a="150927269"
From: "Gao, Yunpeng" <yunpeng.gao@intel.com>
To: Greg KH <greg@kroah.com>
CC: Greg KH <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 5 Jun 2009 11:31:21 +0800
Subject: RE: linux-next: Tree for June 3 (staging)
Thread-Topic: linux-next: Tree for June 3 (staging)
Thread-Index: AcnlPf4bVOgWFwcgR36TluNcU9yBrgARKOSw
Message-ID: <38D9F46DFF92C54980D2F2C1E8EE313001A45F49F3@pdsmsx503.ccr.corp.intel.com>
References: <20090603190952.2dd0cc70.sfr@canb.auug.org.au>
 <4A2695C1.2060104@oracle.com> <20090603152558.GA25725@suse.de>
 <4A269971.1050004@oracle.com> <20090603231152.GA18701@suse.de>
 <20090604232610.GA16053@intel.com> <20090604175219.GA18605@kroah.com>
In-Reply-To: <20090604175219.GA18605@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n553Uw54030400

Hi Greg,

Thanks for your quick response.

The root cause of the build-errors in ffsport.c is that the kernel block layer APIs are different in linux-next tree (.../linux/kernel/git/sfr/linux-next.git) than in Linus' kernel tree (.../linux/kernel/git/torvalds/linux-2.6.git).

Yesterday, after modify code in ffsport.c to sync up with the block layer APIs changes, I have make the kernel against linux-next tree and found no build error / warnings.

Then I generated the patch again Linus' kernel tree, tag 'v2.6.30-rc8' and sent the patch to you. This patch uses the new block layer APIs and is target for the linux-next tree.

I guess the below build errors are caused by compiling the patch code in Linus' kernel tree. As the block layer API's in Linus' kernel tree is still the old one, it'll report this kind of 'implicit declaration of function ...' error. I'm sorry for the mis-communication.

Now, I'm a bit confused with the process :-) Which git tree should I select to generate patch against and submit to? The linux-next tree or Linus' kerner tree?

Thanks for your time.

Rgds,
Yunpeng

>-----Original Message-----
>From: Greg KH [mailto:greg@kroah.com]
>Sent: 2009Äê6ÔÂ5ÈÕ 1:52
>To: Gao, Yunpeng
>Cc: Greg KH; linux-kernel@vger.kernel.org
>Subject: Re: linux-next: Tree for June 3 (staging)
>
>Are you sure you included the fixed up patch?
>
>With the patch you submitted below, I get the following build errors:
>
>drivers/staging/mrst_nand/ffsport.c: In function ¡®do_transfer¡¯:
>drivers/staging/mrst_nand/ffsport.c:360: error: implicit declaration of
>function ¡®blk_rq_pos¡¯
>drivers/staging/mrst_nand/ffsport.c:376: error: implicit declaration of
>function ¡®blk_rq_cur_sectors¡¯
>drivers/staging/mrst_nand/ffsport.c: In function ¡®spectra_trans_thread¡¯:
>drivers/staging/mrst_nand/ffsport.c:499: error: implicit declaration of
>function ¡®blk_fetch_request¡¯
>drivers/staging/mrst_nand/ffsport.c:499: warning: assignment makes pointer
>from integer without a cast
>drivers/staging/mrst_nand/ffsport.c:515: error: implicit declaration of
>function ¡®__blk_end_request_cur¡¯
>drivers/staging/mrst_nand/ffsport.c:520: error: implicit declaration of
>function ¡®__blk_end_request_all¡¯
>drivers/staging/mrst_nand/ffsport.c: In function ¡®SBD_setup_device¡¯:
>drivers/staging/mrst_nand/ffsport.c:741: error: implicit declaration of
>function ¡®blk_queue_logical_block_size¡¯
>make[3]: *** [drivers/staging/mrst_nand/ffsport.o] Error 1
>make[3]: *** Waiting for unfinished jobs....
>
>
>I'll just drop this patch for now, can you resend it to me when it is
>fixed up properly?
>
>thanks,
>
>greg k-h
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
