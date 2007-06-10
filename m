Return-Path: <linux-kernel-owner+w=401wt.eu-S1763507AbXFJVST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763507AbXFJVST (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 17:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756069AbXFJVSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 17:18:06 -0400
Received: from tresys.irides.com ([216.250.243.126]:10970 "HELO
	exchange.columbia.tresys.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754140AbXFJVSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 17:18:04 -0400
Message-ID: <466C6A64.4050901@manicmethod.com>
Date: Sun, 10 Jun 2007 17:17:24 -0400
From: Joshua Brindle <method@manicmethod.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Crispin Cowan <crispin@novell.com>
CC: david@lang.hm, Greg KH <greg@kroah.com>,
       Andreas Gruenbacher <agruen@suse.de>,
       Stephen Smalley <sds@tycho.nsa.gov>, Pavel Machek <pavel@ucw.cz>,
       jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
 pathname matching
References: <20070514110607.549397248@suse.de> <200706042303.28785.agruen@suse.de> <1181136386.3699.70.camel@moss-spartans.epoch.ncsc.mil> <200706090003.57722.agruen@suse.de> <20070609001703.GA17644@kroah.com> <Pine.LNX.4.64.0706082207260.6675@asgard.lang.hm> <466C6518.9070501@novell.com>
In-Reply-To: <466C6518.9070501@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Jun 2007 21:18:02.0044 (UTC) FILETIME=[D3D757C0:01C7ABA4]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Crispin Cowan wrote:
> david@lang.hm wrote:
>   
>> On Fri, 8 Jun 2007, Greg KH wrote:
>>     
>>> I still want to see a definition of the AA "model" that we can then use
>>> to try to implement using whatever solution works best.  As that seems
>>> to be missing the current argument of if AA can or can not be
>>> implemented using SELinux or something totally different should be
>>> stopped.
>>>       
>> the way I would describe the difference betwen AA and SELinux is:
>>
>> SELinux is like a default allow IPS system, you have to describe
>> EVERYTHING to the system so that it knows what to allow and what to stop.
>>
>> AA is like a default deny firewall, you describe what you want to
>> happen, and it blocks everything else without you even having to
>> realize that it's there.
>>     
> That's not quite right:
>
>     * SELinux Strict Policy is a default-deny system: it specifies
>       everything that is permitted system wide, and all else is denied.
>     * AA and the SELinux Targeted Policy are hybrid systems:
>           o default-deny within a policy or profile: confined processes
>             are only permitted to do what the policy says, and all else
>             is denied.
>           o default-allow system wide: unconfined processes are allowed
>             to do anything that classic DAC permissions allow.
>   
Still not completely correct, though the targeted policy has an 
unconfined domain (unconfined_t) the policy still has allow rules for 
everything unconfined can do, 2 examples of things unconfined still 
can't do (because they aren't allowed by the targeted policy) is execmem 
and a while back when there was a /proc exploit that required setattr on 
/proc/self/environ; unconfined_t wasn't able to do that either (and 
therefore the exploit didn't work on a targeted system).

That said, the differentiation between strict and targeted is going away 
soon so that one can have some users be unconfined (but still with a few 
restrictions) and others can be fully restricted.

