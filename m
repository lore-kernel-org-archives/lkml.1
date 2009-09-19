Return-Path: <linux-kernel-owner+w=401wt.eu-S1757251AbZISLLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251AbZISLLu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 07:11:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751277AbZISLLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 07:11:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32125 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930AbZISLLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 07:11:47 -0400
Message-ID: <4AB4BC6A.3020104@redhat.com>
Date: Sat, 19 Sep 2009 14:11:38 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Jim Meyering <jim@meyering.net>, Theodore Tso <tytso@mit.edu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: efficient access to "rotational";  new fcntl?
References: <87vdjgqcbd.fsf@meyering.net>	<20090918221658.GB28781@mit.edu>	<87pr9npdlc.fsf@meyering.net>	<20090919103149.54258081@infradead.org>	<87k4zvpak6.fsf@meyering.net> <20090919111912.34a35f95@infradead.org>
In-Reply-To: <20090919111912.34a35f95@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2009 12:19 PM, Arjan van de Ven wrote:
>> However, sort *would* benefit, and some UCLA students implemented that
>> for a term project.  Unfortunately, the project is stalled because the
>> implementation was not efficient enough, and no one has found the
>> time to improve it since.
>>      
> parallel sort... call me skeptical. My gut feeling is that you'll get
> killed by communication overhead.
> (sort seems to be more communication than raw cpu use)
>
>    

Why?  a sort that fits in memory is purely cpu and memory access.

Instead of O(N log N) you'd get K * O(N/K log N/K) followed by an O(N) 
merge.  For large N and small K, you get a speedup of roughly K (since 
the O(N) merge is dominated by the preceding sort.


-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

