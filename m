Return-Path: <linux-kernel-owner+w=401wt.eu-S1759629AbXIYEQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759629AbXIYEQx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 00:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752190AbXIYEQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 00:16:44 -0400
Received: from stinky.trash.net ([213.144.137.162]:55877 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbXIYEQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 00:16:43 -0400
Message-ID: <46F8897C.5010504@trash.net>
Date: Tue, 25 Sep 2007 06:07:24 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051019)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: [PATCH] Remove broken netfilter binary sysctls from bridging
 code
References: <20070918011841.2381bd93.akpm@linux-foundation.org>	<20070921020554.GE31759@nineveh.local>	<m1fy18k5ru.fsf@ebiederm.dsl.xmission.com>	<46F7EC0A.9030506@trash.net> <20070924131458.0daa4562@freepuppy.rosehill>
In-Reply-To: <20070924131458.0daa4562@freepuppy.rosehill>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger wrote:
> On Mon, 24 Sep 2007 18:55:38 +0200
> Patrick McHardy <kaber@trash.net> wrote:
> 
>>Eric W. Biederman wrote:
>>
>>>A really good fix would be to remove the binary side and then to
>>>modify brnf_sysctl_call_tables to allocate a temporary ctl_table and
>>>integer on the stack and only set ctl->data after we have normalized
>>>the written value.  But since in practice nothing cares about
>>>the race a better fix probably isn't worth it.
>>
>>
>>I seem to be missing something, the entire brnf_sysctl_call_tables
>>thing looks purely cosmetic to me, wouldn't it be better to simply
>>remove it?
> 
> 
> I agree, removing seems like a better option.  But probably need to go
> through a 3-6mo warning period, since sysctl's are technically an API.


I meant removing brnf_sysctl_call_tables function, not the sysctls
themselves, all it does is change values != 0 to 1. Or did you
actually mean that something in userspace might depend on reading
back the value 1 after writing a value != 0?
