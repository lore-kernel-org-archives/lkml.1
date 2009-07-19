Return-Path: <linux-kernel-owner+w=401wt.eu-S1754548AbZGSODA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548AbZGSODA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 10:03:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754437AbZGSOC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 10:02:59 -0400
Received: from mail-yx0-f184.google.com ([209.85.210.184]:54728 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357AbZGSOC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 10:02:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:subject:message-id:user-agent:mime-version
         :content-type;
        b=bTTDsxyWvs77SY2KRM++o/PhmUyQ9G8qBFC4n1IOQbYqndUbPIiuCbkcxI5ZYLYEJ2
         R/UWSk2bdsYDpv3kJZIvwkEpvnvM5NE96c2nokTYnIEv6f0+KTMCzgmuYBaBXbyO0XF6
         Wq5bIfWQv2hSwG6ymVydJxt1MokmlLlF1ER7c=
Date: Sun, 19 Jul 2009 16:04:48 +0300 (EAT)
From: Dan Carpenter <error27@gmail.com>
X-X-Sender: dcarpenter@bicker
To: linux-kernel@vger.kernel.org
Subject: potential null dereference in sysfs_override_clocksource()
Message-ID: <alpine.DEB.2.00.0907191545580.12306@bicker>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am testing a source checker (http://repo.or.cz/w/smatch.git).

It found an issue in sysfs_override_clocksource() from 
kernel/time/clocksource.c.  If "len" is zero then "ovr" is null and 
checking ovr->flags will oops on line 517.

kernel/time/clocksource.c
   516          if (tick_oneshot_mode_active() &&
   517              !(ovr->flags & CLOCK_SOURCE_VALID_FOR_HRES)) {
   518                  printk(KERN_WARNING "%s clocksource is not HRT compatible. "

regards,
dan carpenter



