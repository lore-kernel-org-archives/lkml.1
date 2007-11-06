Return-Path: <linux-kernel-owner+w=401wt.eu-S1755424AbXKFG0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424AbXKFG0g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 01:26:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754185AbXKFG00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 01:26:26 -0500
Received: from fep02.mfe.bur.connect.com.au ([203.63.86.22]:63648 "EHLO
	fep02.mfe.bur.connect.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751929AbXKFG0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 01:26:25 -0500
Message-ID: <47301739.3010604@ii.net>
Date: Tue, 06 Nov 2007 15:26:49 +0800
From: Cliffe <cliffe@ii.net>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Crispin Cowan <crispin@crispincowan.com>
CC: Simon Arlott <simon@fire.lp0.eu>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: Defense in depth: LSM *modules*, not a static interface
References: <10965.80.126.27.205.1193684677.squirrel@webmail.xs4all.nl>    <4726377A.4080807@crispincowan.com>    <e7d8f83e0710292213h4cf9cddw6e373d60fbab41f9@mail.gmail.com>    <4726D9D9.2000909@ii.net> <29685.simon.1193747418@5ec7c279.invalid> <472FE383.70103@crispincowan.com>
In-Reply-To: <472FE383.70103@crispincowan.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Crispin Cowan wrote:
> Simon Arlott wrote:
>   
>> On Tue, October 30, 2007 07:14, Cliffe wrote:
>>   
>>     
>>> And while I acknowledge that many of these layers are currently buried
>>> within the kernel (netfilter...) they are security layers which in many
>>> cases would probably make sense as stackable security modules.
>>>
>>> Making the interface static forces mammoth solutions which then must
>>> attempt to solve all of the above in one ls*m*. What happened to
>>> dividing tasks into easy to manage chunks?
>>>       
...
>> Alternatively the M in LSM can be restored and modules can be stacked.
>> It should be possible for the primary LSM to check the security_ops of the
>> secondary LSM(s) and complain if it considers there to be an incompatiblity.
>>   
>>     
> That is what I advocate. Restore the modular feature immediately, this
> static interface is lots of cost (mostly opportunity cost) and very
> little benefit (mostly defense against contrived FUD threats).
>
> Crispin
>   

Security can (and should) be implemented in a layered approach. Not 
allowing stacking means that, rather than creating modules which 
complement each other, certain layers need to be migrated into the 
mainline kernel code. This would be ok if every situation had the same 
security requirements; however, they do not.

For example small LSMs that provide hooks for Malware scanners (like 
dazuko), certain security improvements (such as RaceGuard, PaX ...) and 
POSIX capabilities could be stacked with other larger lsms (traditional 
access control, IDS, firewalls) rather than copying these techniques 
into all the large lsms (such as SELinux and AppArmor) or putting them 
into the mainline kernel. Obviously it would be easier to maintain one 
capability lsm which stacks, than capabilities being implemented in 
every access control lsm.

It may be possible to compile stacked LSMs together (I don't know), but 
modules provide greater flexibility and either way stacking should be 
pursued.

I agree with Crispin, restore modules. Then discussions of suitable ways 
of providing stacking can occur / continue.

Cliffe wrote:
> Al Viro wrote:
>> On Tue, Oct 30, 2007 at 03:14:33PM +0800, Cliffe wrote:
>>  
>>> Defense in depth has long been recognised as an important secure 
>>> design principle. Security is best achieved using a layered approach.
>>>     
>>  
>> "Layered approach" is not a magic incantation to excuse any bit of snake
>> oil.  Homeopathic remedies might not harm (pure water is pure water),
>> but that's not an excuse for quackery.  And frankly, most of the
>> "security improvement" crowd sound exactly like woo-peddlers.
>>   
>
> I agree completely; but layers that provide actual security 
> improvements are important. 

Just to clarify, I was agreeing with Al that layers for the sake of 
layers does not improve security if the layers are flawed. I was not 
implying that the specific LSMs that are being proposed currently 
(AppArmor etc) are flawed. I personally think that AppArmor provides 
security improvements which are particularly suitable in some situations.

However, if you do have defense in depth then a flaw in one layer may be 
compensated by another layer. For example if you have a system wide 
firewall that does not allow any incoming traffic to enter a system, and 
an AppArmor profile denies all network traffic to a specific 
application, then a flaw in the firewall which would ordinarily result 
in a compromise of the systems policy would not cause that specific 
application to be exposed. Granted this may be a poor example, but it 
does illustrate that layers provide security improvements. Of course 
this kind of setup does provide management and usability challenges but 
that is an area for improvement.

Anyway I hope that my opinion is helpful,

Cliffe.


-- 
Z. Cliffe Schreuders
BSc Comp Sci (Hons) & Int Comp
PhD Candidate, Casual Tutor
School of IT
Murdoch University
