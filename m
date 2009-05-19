Return-Path: <linux-kernel-owner+w=401wt.eu-S1755114AbZESNcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114AbZESNcu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 09:32:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753467AbZESNci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 09:32:38 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:36637 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699AbZESNcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 09:32:36 -0400
Date: Tue, 19 May 2009 15:32:36 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Michael Abbott <michael@araneidae.co.uk>
Subject: Re: [GIT PULL] cputime patch for 2.6.30-rc6
In-Reply-To: <1242660243.26820.439.camel@twins>
Message-ID: <alpine.LSU.2.00.0905191531370.14681@fbirervta.pbzchgretzou.qr>
References: <20090518160904.7df88425@skybase> <1242660243.26820.439.camel@twins>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 2009-05-18 17:24, Peter Zijlstra wrote:
>> +	for_each_possible_cpu(i)
>> +		idletime = cputime64_add(idletime, kstat_cpu(i).cpustat.idle);
>> +	idletime = cputime64_to_clock_t(idletime);
>>  
>>  	do_posix_clock_monotonic_gettime(&uptime);
>>  	monotonic_to_bootbased(&uptime);
>
>This is a world readable proc file, adding a for_each_possible_cpu() in
>there scares me a little (this wouldn't be the first and only such case
>though).

Well maybe procfs could gain chmod support (with the same lifetime
guarantee that one would have with tmpfs), so that init scripts of
big boxes can chmod it 400 on boot if there is that potential user
threat:

>Then think about userspace doing: 
>  while :; do cat /proc/uptime > /dev/null; done
