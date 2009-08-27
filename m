Return-Path: <linux-kernel-owner+w=401wt.eu-S1751461AbZH0HcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461AbZH0HcN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 03:32:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751297AbZH0HcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 03:32:12 -0400
Received: from mail-ew0-f227.google.com ([209.85.219.227]:41590 "EHLO
	mail-ew0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbZH0HcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 03:32:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=Ncp8+hQLnA5bAB/jJPrbRXFENSyFBMFl9jaLbGS3heVDCPw6oBCOfQa1bLBe2Fr/xB
         iMWdYQesI3vc8/cq8HjKFN5HQfebE+aBEAB/i55NtbcFutpTMi5tYIRrJ+4FkiTQiH+g
         rWQy+8oAKw1tZJHu4+hdtPs6VO/5UUJb7seNw=
Message-ID: <4A9637B7.1080707@gmail.com>
Date: Thu, 27 Aug 2009 09:37:27 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: ysato@users.sourceforge.jp, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: h8300: bad test of memory_end in setup_arch()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

in arch/h8300/kernel/setup.c:116:
	if ((memory_end < CONFIG_BLKDEV_RESERVE_ADDRESS) && 
            (memory_end > CONFIG_BLKDEV_RESERVE_ADDRESS))
            /* overlap userarea */
            memory_end = CONFIG_BLKDEV_RESERVE_ADDRESS;

This will always evaluate to false. what is this supposed to do?
is this &&/|| confusion? Can we simply replace this with:

	memory_end = CONFIG_BLKDEV_RESERVE_ADDRESS;

Roel
