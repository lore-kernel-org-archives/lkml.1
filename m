Return-Path: <linux-kernel-owner+w=401wt.eu-S1754835AbZKHSbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbZKHSbS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 13:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753313AbZKHSbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 13:31:17 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:60985 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153AbZKHSbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 13:31:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:content-type:content-transfer-encoding:subject:date:message-id
         :to:mime-version:x-mailer;
        b=cRQoxindy/sx3gGN3W9a9zrXEiXyk/Mr5s+ecGIMqQFPcms8F7ZHHoRD4OdMNCYyxv
         g7fs/RaK1xKh2DUHVjgIYHOvSuWE8SNENlGK5gZ76CIFXKNcU7zeYngDNXPstMsw1tlc
         rdX8WojYW1RG9JGuV05Vj2ZhmTR/5ymHVhwxg=
From: Ramneek Handa <ramneekhanda@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Subject: msync with MS_ASYNC on same page broken?
Date: Mon, 9 Nov 2009 02:31:17 +0800
Message-Id: <6E48F63F-AB51-4EBE-8A45-E3B5AE8C3BBD@gmail.com>
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1076)
X-Mailer: Apple Mail (2.1076)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I am writing a low latency application which (during the course of  
processing) writes objects into a file in binary mode. I am testing  
the persistence library right now which in single threaded mode can  
achieve about 2 micros per record (if say 100000 records 256 bytes  
each are written and i commit the entire page only once, i.e. one  
commit for 100,000 records).  On the other hand if i write 2 records  
per commit (note there will be 16 records per page), next 15 commits  
will be very slow. If on the other hand i increase my commit size to  
16 per commit the speed becomes 100x.

I read the thread below and looks like the core of the problem.
http://lkml.indiana.edu/hypermail/linux/kernel/0602.1/0500.html

Can some one please shed more light on what decision was eventually  
taken on this and is it already fixed (Andrew's fix seems good for  
such problem)? Any other way i can get around this issue?

BTW, there is no way to predict how many records will be per  
transaction/commit.

Regards,
Ramneek
