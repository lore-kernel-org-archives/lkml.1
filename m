Return-Path: <linux-kernel-owner+w=401wt.eu-S1755907AbYCBQ61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907AbYCBQ61 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 11:58:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754124AbYCBQ6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 11:58:17 -0500
Received: from mga09.intel.com ([134.134.136.24]:23041 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753767AbYCBQ6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 11:58:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,435,1199692800"; 
   d="scan'208";a="214114211"
Message-ID: <47CADC9D.9090403@linux.intel.com>
Date: Sun, 02 Mar 2008 08:58:05 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>,
       Gabriel C <nix.or.die@googlemail.com>,
       Laurent Riffard <laurent.riffard@free.fr>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Stuart Bennett <sb476@cam.ac.uk>, Len Brown <lenb@kernel.org>,
       tglx@linutronix.de, mingo@redhat.com
Subject: Re: 2.6.25-rc2-mm1: WARNING at arch/x86/mm/ioremap.c:129
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org> <47B7553D.5040601@free.fr> <47C0BDE2.4020402@googlemail.com> <47C0DB7D.70407@linux.intel.com> <47C2ED51.4000105@googlemail.com> <47C344E5.5050205@linux.intel.com> <20080302155348.GA74305@gandalf.sssup.it>
In-Reply-To: <20080302155348.GA74305@gandalf.sssup.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fabio Checconi wrote:
> [cc'd relevant maintainers]
> 
> Hi,
> 
>> From: Arjan van de Ven <arjan@linux.intel.com>
>> Date: Mon, Feb 25, 2008 02:44:53PM -0800
>>
>> Gabriel C wrote:
> ...
>>> With your patch from 
>>> http://marc.info/?l=linux-kernel&m=120336371506283&w=2 I don't have a 
>>> warning anymore.
>>>
>> that is ... odd since it's the same in theory, just with some added 
>> printk's ;-(
> 
> the same here on 2.6.25-rc3, with the innocent ibmphp_access_ebda()
> that fires the WARN_ON() in __ioremap() asking for the pfn 0, even
> after the page_is_ram() change.  With your patch the warning
> disappears.
> 
> I think this is because the pfn checked by the original code (before
> your patch) is the one after the last iteration, while your patch
> checks for each pfn that is going to be mapped.  The latter should
> be the intended behavior.  If I've understood the problem, the
> (trivial) patch below should fix it.
> 
> Also, note that if last_addr is at the beginning of a page we can
> __ioremap() normal RAM (in fact we only emit the warning with the
> old code, instead of returning NULL.)  Is that possible/intended
> behavior?  If not the loop should do one more iteration.
> 
> 
> __ioremap() emits a warning if the pfn after the last one it's going
> to map is of normal ram.  Correct this and emit the warning (once)
> only if one of the asked pages is.
> 


looks good to me; Ingo please apply
(Note: if no legit users show up I want to just remove support for mapping ram altogether
in 2.6.26 or so)
