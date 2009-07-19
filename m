Return-Path: <linux-kernel-owner+w=401wt.eu-S1754119AbZGSCI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119AbZGSCI7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 22:08:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754067AbZGSCI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 22:08:57 -0400
Received: from zola.planet-work.net ([79.99.160.15]:45801 "EHLO
	zola.planet-work.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbZGSCI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 22:08:57 -0400
X-Greylist: delayed 1833 seconds by postgrey-1.27 at vger.kernel.org; Sat, 18 Jul 2009 22:08:57 EDT
Message-ID: <4A6278FD.20807@cr0.org>
Date: Sat, 18 Jul 2009 18:38:05 -0700
From: Julien TINNES <jt@cr0.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       Julien Tinnes <jt@cr0.org>, Tavis Ormandy <taviso@sdf.lonestar.org>,
       Christoph Hellwig <hch@infradead.org>, Kees Cook <kees@ubuntu.com>,
       Eugene Teo <eugene@redhat.com>, Athanasius <link@miggy.org>
Subject: Re: [link@miggy.org: Re: [patch 2/8] personality: fix	PER_CLEAR_ON_SETID
 (CVE-2009-1895)]
References: <20090718202512.GA19587@suse.de> <alpine.LFD.2.01.0907181342500.13838@localhost.localdomain> <20090718212812.GI6722@miggy.org>
In-Reply-To: <20090718212812.GI6722@miggy.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Athanasius a écrit :
> On Sat, Jul 18, 2009 at 01:48:06PM -0700, Linus Torvalds wrote:
>> On Sat, 18 Jul 2009, Greg KH wrote:
>>> and you have the whole idea of personalities being some kind of security
>>> mechanism exposed as a joke.
>> It's _not_ a "security mechanism". It never was.
> ...
>> In the absense of raised capabilities, the personality flags don't matter: 
>> because they aren't security. If you have a personality flag that says "I 
>> want to mmap at virtual address zero", you're still going to be limited by 
>> the security layer, and if the security layer says "nope, you can't do 
>> that", then your personality doesn't matter.
>>
>> See?
> 
>   I can understand and appreciate that, yes.
> 
>   However the content of 'cat /proc/execdomains' is mis-leading for
> the default Execution Domain.  The string '0-0' implies either that you
> can only set 1 of 3 personalities whilst this Execution Domain is current
> OR that this Execution Domain will only be used whilst the set personality
> is one of those 3.  But neither is actually true as this default Execution
> Domain (being the only one in vanilla kernel tree) is a special case.
>   If you don't see a valid reason to change personality(2) behaviour (thus
> still allowing setting aribtrary personality values) then surely it would
> make more sense for the default domain to set pers_high to PER_MASK ?
> I'd suggest it actually be 0xffffffff but the field is only a char.
> 

So I think we all agree that this is not a security boundary and that
there is no security problem here.
A process should be able to change it's own personality, there is no
issue with this as long as we restrict the set of personalities which
are preserved when the process gets new privileges.

Currently, all the personalities are being implemented inside one
execution domain, the default one.

To address your concerns:
- pers_low and pers_high are compared to the *base* personality (without
flags), so it's correct to define them as uchar. pers should perhaps be
defined as uchar as well in lookup_exec_domain
- since all personalities are implemented inside the default execution
domain, it would indeed make sense to set default_exec_domain.pers_high
to PER_MASK. It would not change anything in practice, but it would make
sense.

Julien
