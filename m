Return-Path: <linux-kernel-owner+w=401wt.eu-S1756816AbYEWPCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816AbYEWPCw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 11:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754047AbYEWPCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 11:02:45 -0400
Received: from smtp.nokia.com ([192.100.122.230]:55140 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356AbYEWPCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 11:02:44 -0400
Message-ID: <4836DC57.1020101@yandex.ru>
Date: Fri, 23 May 2008 18:01:43 +0300
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: Lennert Buytenhek <buytenh@wantstofly.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: bad example in Documentation/atomic_ops.txt ?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 23 May 2008 15:02:02.0584 (UTC) FILETIME=[F51BED80:01C8BCE5]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I it looks like the example in the Documentation/atomic_ops.txt
file at line 232 is not quite right. The obj->active = 0 will
be delayed, but not further than spin_unlock() in obj_timeout().
Becaus spin_unlock() has a memory barrier.

I guess you would need to move spin_lock(&global_list_lock) to
obj_list_del() to make the example valid.

This confused me when I read the file.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
