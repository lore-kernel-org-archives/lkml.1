Return-Path: <linux-kernel-owner+w=401wt.eu-S1760388AbXKMRzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760388AbXKMRzW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 12:55:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760084AbXKMRzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 12:55:00 -0500
Received: from main.gmane.org ([80.91.229.2]:57017 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760054AbXKMRy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 12:54:59 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Florian Boelstler <kernel@boelstler.net>
Subject: Re: Strange delays / what usually happens every 10 min?
Date: Tue, 13 Nov 2007 18:54:12 +0100
Message-ID: <fhcocb$jv0$1@ger.gmane.org>
References: <fhcc39$51b$1@ger.gmane.org> <4739CF81.8050704@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: fw-emea.rohde-schwarz.com
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
In-Reply-To: <4739CF81.8050704@cosmosbay.com>
Cc: netdev@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

Eric Dumazet wrote:
> Instead of using less RAM, you could just boot with rhash_entries=1024 
> to lower the size of this table.

I just tried that and it seems to reduce the scan time. This is the 
result for the first 40 minutes of runtime:

root@mpc0:/# /tmp/wait.rt
looping 1 milli seconds nanosleep ...
17:10:11/425384 #1 MAX 1996/83117/-268599896 us/tick/usec (at 2107848557)
17:10:11/427385 #2 MAX 2001/83327/2001 us/tick/usec (at 2107931884)
17:10:11/433534 #5 MAX 2149/89477/2150 us/tick/usec (at 2108187839)
17:27:02/5897 #505291 MAX 2512/104576/2513 us/tick/usec (at 1223589469)

The first ~10ms delay usually occurred after ~15 minutes. So one could 
argue that the reported HIGH-value at 17:27:02 (GMT) is the first flush 
of IP route cache. And all later flushes weren't longer than 2,5ms.

Thanks to all of you, especially Eric. Now it seems I got an instrument 
to lower system response time.

Cheers,

   Florian

PS: Unfortunately I had to remove some CC:-entries since the local 
firewall seems to not allow anything but NNTP (for gmane) and HTTP.

