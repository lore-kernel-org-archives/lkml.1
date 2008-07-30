Return-Path: <linux-kernel-owner+w=401wt.eu-S1756350AbYG3L1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350AbYG3L1m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 07:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753601AbYG3L1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 07:27:33 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:16599 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820AbYG3L1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 07:27:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=qKE4tp2Mm/XMnzW962ysg+k7JIV9Feoo+iMbl1IDwbC/wnrAiSzmUTqH2Bx3/9b4eL
         lOi6bk757Pu9RzylmBCJ55gw53/714cjI32jai/a7yErS7kHSjv49cioF1aWHSumA75U
         SQTbocIs8e0XNZYwNJzvTEwwihN3Fi1Oo+PUY=
Message-ID: <48905028.5060908@gmail.com>
Date: Wed, 30 Jul 2008 13:27:36 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, xsonnek@gmail.com,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/1] semaphore: declare down_try
References: <1217417115-28574-1-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1217417115-28574-1-git-send-email-jirislaby@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby napsal(a):
> Maybe you already fixed this, in todays mmotm there is a fix of duplicate
> down_try definiton, but this problem still persist.

BTW. there is still bunch of down_trylock(); users, are you about to 
eliminate them?

    2    182  /home/latest/xxx/drivers/watchdog/ar7_wdt.c <<ar7_wdt_open>>
              if (down_trylock(&open_semaphore))
    3    309  /home/latest/xxx/drivers/watchdog/it8712f_wdt.c
              <<it8712f_wdt_open>>
              if (down_trylock(&it8712f_wdt_sem))
    4    214  /home/latest/xxx/drivers/watchdog/s3c2410_wdt.c
              <<s3c2410wdt_open>>
              if(down_trylock(&open_lock))
    5    154  /home/latest/xxx/drivers/watchdog/sc1200wdt.c <<sc1200wdt_open>>
              if (down_trylock(&open_sem))
    6     95  /home/latest/xxx/drivers/watchdog/scx200_wdt.c <<scx200_wdt_open>>
              if (down_trylock(&open_semaphore))
    7    429  /home/latest/xxx/drivers/watchdog/wdt_pci.c <<wdtpci_open>>
              if (down_trylock(&open_sem))
