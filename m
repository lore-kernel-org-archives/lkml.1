Return-Path: <linux-kernel-owner+w=401wt.eu-S1756837AbYKEST7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837AbYKEST7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 13:19:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752019AbYKESTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 13:19:50 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:29777 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754746AbYKESTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 13:19:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BD+vEmAhiZtiNQp0Jz9b/NyeKkO8/2iv3q5abs5c8B3JU7Q/ko+jXUhgSqaDwt/Zw5
         dAr/xR+9OTlhTli0cLmp+lBts1qjTuXr324If0bVlq9KFKCToBiTUcLyv2Kr9ndsct1V
         8+Y52bC9lSWvYPB40krFTeMZxy0g/l3dtf2QE=
Date: Wed, 5 Nov 2008 21:15:58 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Alexander van Heukelum <heukelum@mailshack.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       heukelum@fastmail.fm, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, lguest@ozlabs.org,
       jeremy@xensource.com, Steven Rostedt <srostedt@redhat.com>,
       Mike Travis <travis@sgi.com>
Subject: Re: [PATCH RFC/RFB] x86_64, i386: interrupt dispatch changes
Message-ID: <20081105181558.GF7286@localhost>
References: <20081104122839.GA22864@mailshack.com> <20081104150729.GC21470@localhost> <20081104170501.GE29626@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081104170501.GE29626@one.firstfloor.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Andi Kleen - Tue, Nov 04, 2008 at 06:05:01PM +0100]
| > not taking into account the cost of cs reading (which I
| > don't suspect to be that expensive apart from writting,
| 
| GDT accesses have an implied LOCK prefix. Especially
| on some older CPUs that could be slow.
| 
| I don't know if it's a problem or not but it would need
| some careful benchmarking on different systems to make sure interrupt 
| latencies are not impacted.
| 
| Another reason I would be also careful with this patch is that
| it will likely trigger slow paths in JITs like qemu/vmware/etc.
| 
| Also code segment switching is likely not something that
| current and future micro architectures will spend a lot of time optimizing.
| 
| I'm not sure that risk is worth the small improvement in code
| size.
| 
| An alternative BTW to having all the stubs in the executable
| would be to just dynamically generate them when the interrupt
| is set up. Then you would only have the stubs around for the 
| interrupts which are actually used.
| 
| -Andi
| 

Thanks a lot for comments, Andi!

		- Cyrill -
