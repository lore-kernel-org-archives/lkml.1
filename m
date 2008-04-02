Return-Path: <linux-kernel-owner+w=401wt.eu-S1760224AbYDBHAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760224AbYDBHAn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 03:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758840AbYDBHAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 03:00:12 -0400
Received: from relay.gothnet.se ([82.193.160.251]:3765 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757560AbYDBHAK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 03:00:10 -0400
Message-ID: <47F32EDD.1080306@tungstengraphics.com>
Date: Wed, 02 Apr 2008 08:59:41 +0200
From: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@tungstengraphics.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080306)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Andi Kleen <andi@firstfloor.org>, Dave Airlie <airlied@redhat.com>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com
Subject: Re: [PATCH] x86: create array based interface to change page attribute
References: <1206940788.7250.13.camel@clockmaker.usersys.redhat.com> <87myof8ief.fsf@basil.nowhere.org> <47F098E8.1050605@tungstengraphics.com> <20080331083816.GC29105@one.firstfloor.org> <47F0A988.7010707@tungstengraphics.com> <20080331091829.GD29105@one.firstfloor.org> <47F0C6C2.2000004@tungstengraphics.com> <47F10C62.7040500@linux.intel.com> <47F11443.7050302@tungstengraphics.com> <47F11616.3020403@linux.intel.com> <47F11ED3.40803@tungstengraphics.com> <47F2A202.1040900@linux.intel.com> <47F2A948.5070108@tungstengraphics.com> <47F2B788.1030101@linux.intel.com> <47F32816.4060806@tungstengraphics.com> <47F3294E.8090805@linux.intel.com>
In-Reply-To: <47F3294E.8090805@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
X-BitDefender-Scanner: Mail not scanned due to license constraints
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> Thomas Hellström wrote:
>
>> But what mappings are there,  immediately after alloc_page(), that 
>> set_memory_np won't catch? 
>
> For example on x86 64bit, the kernel text is mapped (to allow 
> relocatable) in another
> space as well.. and to allow 2Mb tlbs for this, that second mapping is 
> bigger than it strictly needs to be.
> So your alloc_page() could get a page from the free pool that comes 
> from the pages that have a second mapping
> due to this rounding.
> (and more fun, since it's close to frequently accessed memory, the hw 
> prefetchers may actually just decide to pull
> such pages into the cache preemptively)
>
>
>> Drivers relying on set_memory_uc touching all mappings the driver 
>> hasn't set up itself must then have the same problem and needs to be 
>> fixed; referring in particular to agpgart for which driver the old 
>> CPA functionality was once created, IIRC.
>
> "uc" is different than "np"; for "uc" the implementation, if your cpu 
> needs this, will fix
> up the shadow text mappings already today.
>
> for "present" this doesn't make sense, since no cpu needs this.
If this is the checkalias() thingy in x86/pageattr.c, it looks like it 
doesn't handle np different from the uc case. It does obviously skip NX 
bit manipulations, though.

Anyway, a more direct question: If we were to fix whatever's missing for 
the code to fixup the x86-64 shadow text mapping, would you be opposing 
this way to fix the long standing uc/wc aliasing issue, provided we 
don't hit any other problems, like clflush() refusing to run on an NP page?

/Thomas



