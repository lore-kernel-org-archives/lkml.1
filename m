Return-Path: <linux-kernel-owner+w=401wt.eu-S1754033AbXIYOgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbXIYOgn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 10:36:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756112AbXIYOgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 10:36:25 -0400
Received: from stinky.trash.net ([213.144.137.162]:36337 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756065AbXIYOgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 10:36:23 -0400
Message-ID: <46F91AAD.9090801@trash.net>
Date: Tue, 25 Sep 2007 16:26:53 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051019)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] Remove broken netfilter binary sysctls from bridging
 code
References: <20070918011841.2381bd93.akpm@linux-foundation.org>	<20070921020554.GE31759@nineveh.local>	<m1fy18k5ru.fsf@ebiederm.dsl.xmission.com>	<46F7EC0A.9030506@trash.net> <m1641ydeqr.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1641ydeqr.fsf@ebiederm.dsl.xmission.com>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Patrick McHardy <kaber@trash.net> writes:
> 
>>I seem to be missing something, the entire brnf_sysctl_call_tables
>>thing looks purely cosmetic to me, wouldn't it be better to simply
>>remove it?
> 
> 
> Well it is cosmetic in a user space visible way.  Which means I don't
> have a clue which if any user space programs or scripts care if we change
> the behavior. 
>
> I just looked in the git history and brnf_sysctl_call_tables has been
> that way since sysctl support was added to the bridge netfilter code.
> 
> The only comment I can found about the addition is:
> 
>     2003/12/24 19:32:34-08:00 bdschuym
>     [BRIDGE]: Add 4 sysctl entries for bridge netfilter behavioral control:
>     bridge-nf-call-arptables - pass or don't pass bridged ARP traffic to
>     arptables' FORWARD chain.
>     bridge-nf-call-iptables - pass or don't pass bridged IPv4 traffic to
>     iptables' chains.
>     bridge-nf-filter-vlan-tagged - pass or don't pass bridged vlan-tagged
>     ARP/IP traffic to arptables/iptables.
> 
> So since forcing the values to 0 or 1 doesn't seem hard to maintain
> I am uncomfortable with removing that check.


OK lets keep it then. Fixing the race seems overkill to me though.
