Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757680Ab0CKMAH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 07:00:07 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40961 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757664Ab0CKMAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 07:00:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=kJytTUCKDQ9+hZLlrjyfE1Mz+hDPna/d6S6E41qgdRcaL461ZNIEeACM9Rwi+cpLVW
         +PEetMVt4Ff2Xx3W2N9lU3Mx9ssIu2Toq9itH2RqUZQCTCF265qVHg4AbZmpRzBKhs/X
         /88IKdvSzAmuyiBZ6YliZhts6w7fXPPCn2430=
Message-ID: <4B98D9A2.8060603@gmail.com>
Date: Thu, 11 Mar 2010 06:53:06 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       David Miller <davem@davemloft.net>, Michael Chan <mchan@broadcom.com>
Subject: [PATCH v4 2/7] net: remove old tcp_optlen function
References: <4B98D592.6040301@gmail.com>
In-Reply-To: <4B98D592.6040301@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tcp_optlen() function returns a potential *negative* unsigned.

In the only two existing files using the old tcp_optlen() function,
clean up confusing and inconsistent mixing of both byte and word
offsets, and other coding style issues.  Document assumptions.

Quoth David Miller:
    This is transmit, and the packets can only come from the Linux
    TCP stack, not some external entity.

    You're being way too anal here, and adding these checks to
    drivers would be just a lot of rediculious bloat. [sic]

Therefore, there are *no* checks for bad TCP and IP header sizes, nor
any semantic changes.  The drivers should function exactly as existing,
although usage of int should ameliorate the issues.

No response from testers in 21+ weeks.

[removed comment references to commit log]

Requires:
   net: tcp_header_len_th and tcp_option_len_th

Signed-off-by: William.Allen.Simpson@gmail.com
CC: Michael Chan <mchan@broadcom.com>
---
  drivers/net/bnx2.c  |   29 +++++++++++++-----------
  drivers/net/tg3.c   |   60 +++++++++++++++++++++++---------------------------
  include/linux/tcp.h |    5 ----
  3 files changed, 44 insertions(+), 50 deletions(-)
