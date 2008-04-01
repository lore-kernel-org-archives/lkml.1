Return-Path: <linux-kernel-owner+w=401wt.eu-S1759963AbYDAVac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759963AbYDAVac (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 17:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755194AbYDAVaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 17:30:23 -0400
Received: from relay.gothnet.se ([82.193.160.251]:4380 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750868AbYDAVaX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 17:30:23 -0400
Message-ID: <47F2A948.5070108@tungstengraphics.com>
Date: Tue, 01 Apr 2008 23:29:44 +0200
From: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@tungstengraphics.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080306)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Andi Kleen <andi@firstfloor.org>, Dave Airlie <airlied@redhat.com>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com
Subject: Re: [PATCH] x86: create array based interface to change page attribute
References: <1206940788.7250.13.camel@clockmaker.usersys.redhat.com> <87myof8ief.fsf@basil.nowhere.org> <47F098E8.1050605@tungstengraphics.com> <20080331083816.GC29105@one.firstfloor.org> <47F0A988.7010707@tungstengraphics.com> <20080331091829.GD29105@one.firstfloor.org> <47F0C6C2.2000004@tungstengraphics.com> <47F10C62.7040500@linux.intel.com> <47F11443.7050302@tungstengraphics.com> <47F11616.3020403@linux.intel.com> <47F11ED3.40803@tungstengraphics.com> <47F2A202.1040900@linux.intel.com>
In-Reply-To: <47F2A202.1040900@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
X-BitDefender-Scanner: Mail not scanned due to license constraints
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> Thomas Hellström wrote:
>> Given this problem, the previously mentioned use-case, and the fact 
>> that we mostly really use user-space mappings,
>> Is there a possibility we could add the following functions to Dave's 
>> patch (provided they would work as intended, of course, namely 
>> invalidate / bring back the kernel mapping).
>
> sadly there are multiple mappings, both in theory and practice.
> Especially the _np / _p functions specifically work on only the 
> mapping you specify.
>
> For this to work we would need to somehow make a "mark all mappings 
> NP, but please only do the kernel ones" kind of thing.
> The semantics of that are... lets say messy at best.
Hmm, I'm not sure I follow you here. Are you saying that it's illegal to 
have an NP mapping of a page (which, If I understand it correctly, means 
no mapping at all) at the same time as you have a, say user-space WC 
mapping pointing to the same physical page?

Or are you saying that it's very hard to keep track of all mappings to a 
page, and change only the ones you really want to change?

If you mean the latter, for the DRM case, the DRM memory manager has 
already made sure all user-space mappings of a page are killed before 
calling CPA on it, (using unmap_mapping_range()) and they are faulted 
back once CPA is done.

I was under the impression that calling CPA on the kernel mapping of 
that page would do the rest?

/Thomas




