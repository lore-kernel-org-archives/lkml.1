Return-Path: <linux-kernel-owner+w=401wt.eu-S1756747AbYAJWTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747AbYAJWTP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 17:19:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754069AbYAJWTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 17:19:00 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33936 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753242AbYAJWS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 17:18:59 -0500
Date: Thu, 10 Jan 2008 14:15:25 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
cc: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com, gregkh@suse.de,
       airlied@skynet.ie, davej@redhat.com, mingo@elte.hu, tglx@linutronix.de,
       akpm@linux-foundation.org, arjan@infradead.org,
       "Barnes, Jesse" <jesse.barnes@intel.com>, davem@davemloft.net,
       linux-kernel@vger.kernel.org,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Subject: RE: [patch 02/11] PAT x86: Map only usable memory in x86_64 identity
 map and kernel text
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEE5A2958@orsmsx423.amr.corp.intel.com>
Message-ID: <alpine.LFD.1.00.0801101413490.3148@woody.linux-foundation.org>
References: <20080110184840.927409000@intel.com> <20080110184854.787474000@intel.com> <alpine.LFD.1.00.0801101303570.3148@woody.linux-foundation.org> <924EFEDD5F540B4284297C4DC59F3DEE5A2958@orsmsx423.amr.corp.intel.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 10 Jan 2008, Pallipadi, Venkatesh wrote:
> 
> Yes. I had those pages not mapped at all earlier. The reason I switched
> to zero page is to continue support cases like:
>  BIOS-e820: 0000000000000000 - 000000000009cc00 (usable)
>  BIOS-e820: 000000000009cc00 - 00000000000a0000 (reserved)
>  BIOS-e820: 00000000000cc000 - 00000000000d0000 (reserved)
>  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
>  BIOS-e820: 0000000000100000 - 00000000cff60000 (usable)
> 
> In this case if some one does a dd of /dev/mem before they can read the
> contents of usable memory in 0x100000-0xcff60000 range.

Well, I think that /dev/mem should simply give them the right info. That's 
what people use /dev/mem for - doing things like reading BIOS images etc. 

So returning *either* a zero page *or* stopping at the first hole is both 
equally wrong. 

			Linus
