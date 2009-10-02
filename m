Return-Path: <linux-kernel-owner+w=401wt.eu-S1757011AbZJBHvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757011AbZJBHvR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 03:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756893AbZJBHvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 03:51:15 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:47789 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756887AbZJBHvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 03:51:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TrI9ReeK8tj0KbWBixgm3O3CpeIH4cIWwE6jmcF3gwmQ/PgOj9qYxfNQZg0/eOlZVZ
         H5bIR1QgRdFDqyJ+5rik+HYZ42eFCKf7C05T0tyW8h1s3sjcVxFE5j/DNWBxD9O9WFqF
         Ni5f62cJcxAtneZueV51ctw7rxNELtLld+xA4=
MIME-Version: 1.0
In-Reply-To: <e2e108260910012341v5eab14c5o29da95ec52e75183@mail.gmail.com>
References: <200909261428.06802.bart.vanassche@gmail.com>
	 <e2e108260910012341v5eab14c5o29da95ec52e75183@mail.gmail.com>
Date: Fri, 2 Oct 2009 09:51:16 +0200
Message-ID: <19f34abd0910020051h5a831729vcfca50b7bd9f9104@mail.gmail.com>
Subject: Re: [PATCH 2.6.31.1] include/linux/kmemcheck.h: fix a sparse warning
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: linux-kernel@vger.kernel.org, Vegard Nossum <vegardno@ifi.uio.no>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n927pR16025925

2009/10/2 Bart Van Assche <bart.vanassche@gmail.com>:> On Sat, Sep 26, 2009 at 2:28 PM, Bart Van Assche> <bart.vanassche@gmail.com> wrote:>>>> Checking a 2.6.31.1 kernel configured with allyesconfig/allmodconfig>> with sparse (make C=2) triggers a sparse warning on code that uses the>> kmemcheck_annotate_bitfield() macro. An example of such a warning:>>>> include/net/inet_sock.h:208:17: warning: do-while statement is not a compound statement>>>> Signed-off-by: Bart Van Assche <bart.vanassche@gmail.com>>> Cc: Vegard Nossum <vegardno@ifi.uio.no>>> Cc: Andrew Morton <akpm@linux-foundation.org>>>>> --- linux-2.6.31.1/include/linux/kmemcheck-orig.h       2009-09-26 13:53:44.000000000 +0200>> +++ linux-2.6.31.1/include/linux/kmemcheck.h    2009-09-26 13:53:56.000000000 +0200>> @@ -137,13 +137,13 @@ static inline void kmemcheck_mark_initia>>        int name##_end[0];>>>>  #define kmemcheck_annotate_bitfield(ptr, name)                         \>> -       do if (ptr) {                                                   \>> +       do { if (ptr) {                                                 \>>                int _n = (long) &((ptr)->name##_end)                    \>>                        - (long) &((ptr)->name##_begin);                \>>                BUILD_BUG_ON(_n < 0);                                   \>>                                                                        \>>                kmemcheck_mark_initialized(&((ptr)->name##_begin), _n); \>> -       } while (0)>> +       } } while (0)>>>>  #define kmemcheck_annotate_variable(var)                               \>>        do {                                                            \>> (ping)>> Did anyone already have the time to review the patch above ?>> Bart.
Hi,
A patch for this problem has already been applied in latest mainline.Thanks anyway, and sorry for not responding sooner.

Vegard���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
