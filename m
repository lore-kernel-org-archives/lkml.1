Return-Path: <linux-kernel-owner+w=401wt.eu-S1757217AbXJJUrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217AbXJJUrb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 16:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756150AbXJJUrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 16:47:23 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:42667 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756141AbXJJUrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 16:47:22 -0400
Message-ID: <470D2E92.8050606@oracle.com>
Date: Wed, 10 Oct 2007 12:57:06 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Stephen Smalley <sds@tycho.nsa.gov>, James Morris <jmorris@namei.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] SELinux: change Kconfig to use select instead of
 depends
References: <Xine.LNX.4.64.0710100917010.14862@us.intercode.com.au> <Xine.LNX.4.64.0710100918520.14862@us.intercode.com.au> <20071009162812.00e80a0c.randy.dunlap@oracle.com> <1192018350.2687.16.camel@moss-spartans.epoch.ncsc.mil>            <470CF26F.10606@oracle.com> <27818.1192045982@turing-police.cc.vt.edu>
In-Reply-To: <27818.1192045982@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> On Wed, 10 Oct 2007 08:40:31 PDT, Randy Dunlap said:
> 
>>>>>  config SECURITY_SELINUX
>>>>>  	bool "NSA SELinux Support"
>>>>> -	depends on SECURITY_NETWORK && AUDIT && NET && INET
>>>>> +	depends on SECURITY
>>>>> +	select SECURITY_NETWORK
>>>>> +	select AUDIT
>>>>> +	select NET
>>>>> +	select INET
>>>>>  	select NETWORK_SECMARK
> 
>> AUDIT isn't quite library code, still I don't have a (big) problem with
>> selecting it or NETWORK_SECMARK.  (other than select is evil :)
>>
>> OTOH, NET and INET are large config options, not library-like code, and
>> should not be selected.
> 
> If it does a 'select SECURITY_NETWORK' but NET=n, does the resulting kernel
> actually build?  The problem seems to be that select isn't transitive - if
> you select something, it won't automagically select that something's pre-reqs
> (modulo the recent patches I've seen posted, have those been mainlined?).

Good point.

I haven't tested that, but it's most likely still a problem.
"select" does not follow its dependency chain...


-- 
~Randy
