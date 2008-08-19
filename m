Return-Path: <linux-kernel-owner+w=401wt.eu-S1754869AbYHSUBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869AbYHSUBw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 16:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753037AbYHSUBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 16:01:45 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:40982 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763AbYHSUBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 16:01:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:cc:subject:references:from:date:in-reply-to:message-id
         :user-agent:mime-version:content-type:sender;
        b=F+Y35Yg3vK2W6yFnMr4CAt2+KXT86Z+KVPQNVYCW2zvNB0S/YNLugGW0oTmhXO0VUN
         K/6mt7dD7GZM6aR1s0/x812gkJy5MGMpztAj0X8PMuQZHoqM/EkFXwySuL68b69epu4J
         muznmV1ftfRieLZVFDKvIUlJNwcfrn5G+m1L8=
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
       Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Subject: Re: [PATCH 1/2] rtc: rtc-ds1374: fix 'no irq' case handling
References: <20080812161733.GA32164@oksana.dev.rtsoft.ru>
From: Peter Korsgaard <jacmet@sunsite.dk>
Date: Tue, 19 Aug 2008 22:01:37 +0200
In-Reply-To: <20080812161733.GA32164@oksana.dev.rtsoft.ru> (Anton Vorontsov's message of "Tue\, 12 Aug 2008 20\:17\:33 +0400")
Message-ID: <87d4k4n59a.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Anton" == Anton Vorontsov <avorontsov@ru.mvista.com> writes:

 Anton> On a PowerPC board with ds1374 RTC I'm getting this error while
 Anton> RTC tries to probe:

 Anton> rtc-ds1374 0-0068: unable to request IRQ

 Anton> This happens because I2C probing code (drivers/of/of_i2c.c) is
 Anton> specifying IRQ0 for 'no irq' case, which is correct.

 Anton> The driver handles this incorrectly, though. This patch fixes it.

Great, I was just about to send a similar patch. Another advantage of
using 0 for 'no irq' is for I2C_BOARD_INFO(). With that you can simply
not assign anything to .irq instead of having to set it to -1.

Acked-by: Peter Korsgaard <jacmet@sunsite.dk>

-- 
Bye, Peter Korsgaard
