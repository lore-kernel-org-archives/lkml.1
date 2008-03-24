Return-Path: <linux-kernel-owner+w=401wt.eu-S1756679AbYCXHrw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679AbYCXHrw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 03:47:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753980AbYCXHro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 03:47:44 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36217
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753947AbYCXHrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 03:47:43 -0400
Date: Mon, 24 Mar 2008 00:47:42 -0700 (PDT)
Message-Id: <20080324.004742.24756426.davem@davemloft.net>
To: lizf@cn.fujitsu.com
Cc: vladislav.yasevich@hp.com, sri@us.ibm.com,
       lksctp-developers@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SCTP: fix compile warning building without CONFIG_IPV6
From: David Miller <davem@davemloft.net>
In-Reply-To: <47E751B2.1090002@cn.fujitsu.com>
References: <47E74608.7080007@cn.fujitsu.com>
	<20080323.235110.197600762.davem@davemloft.net>
	<47E751B2.1090002@cn.fujitsu.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m2O7m1nq008981

From: Li Zefan <lizf@cn.fujitsu.com>
Date: Mon, 24 Mar 2008 15:01:06 +0800

> David Miller wrote:
> > From: Li Zefan <lizf@cn.fujitsu.com>
> > Date: Mon, 24 Mar 2008 14:11:20 +0800
> > 
> >> include/net/sctp/sctp.h: In function â€˜sctp_v6_pf_initâ€™:
> >> include/net/sctp/sctp.h:392: warning: 'return' with a value, in function returning void
> >>
> >> This warning repeats several times.
> >>
> >> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> > 
> > Fixed in net-2.6 for several days already.
> 
> I looked into the git-log of net-2.6-26 and didn't find the fix.

The net-2.6 tree, not net-2.6.26, holds bug fixes and the change in
question was checked in on Friday.

commit 1233823b0847190976d69a86d7bb1287992ba2c7
Author: David S. Miller <davem@davemloft.net>
Date:   Fri Mar 21 15:40:47 2008 -0700

    [SCTP]: Fix build warnings with IPV6 disabled.
    
    Introduced by 270637abff0cdf848b910b9f96ad342e1da61c66
    ("[SCTP]: Fix a race between module load and protosw access")
    
    Reported by Gabriel C:
    
    In file included from net/sctp/sm_statetable.c:50:
    include/net/sctp/sctp.h: In function 'sctp_v6_pf_init':
    include/net/sctp/sctp.h:392: warning: 'return' with a value, in function returning void
    In file included from net/sctp/sm_statefuns.c:62:
    include/net/sctp/sctp.h: In function 'sctp_v6_pf_init':
    include/net/sctp/sctp.h:392: warning: 'return' with a value, in function returning void
     ...
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index 57ed3e3..ea80673 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -389,7 +389,7 @@ void sctp_v6_del_protocol(void);
 
 #else /* #ifdef defined(CONFIG_IPV6) */
 
-static inline void sctp_v6_pf_init(void) { return 0; }
+static inline void sctp_v6_pf_init(void) { return; }
 static inline void sctp_v6_pf_exit(void) { return; }
 static inline int sctp_v6_protosw_init(void) { return 0; }
 static inline void sctp_v6_protosw_exit(void) { return; }
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
