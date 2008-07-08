Return-Path: <linux-kernel-owner+w=401wt.eu-S1757418AbYGHTy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418AbYGHTy7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 15:54:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754548AbYGHTyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 15:54:50 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:33153 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451AbYGHTyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 15:54:49 -0400
Subject: Re: [PATCH] [0/10] Use 64bit x86 machine check code for 32bit too
	v2
From: Max Asbock <masbock@linux.vnet.ibm.com>
To: "H. Peter Anvin" <hpa@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <4872AC70.8030704@kernel.org>
References: <20080708110.487722491@firstfloor.org>
	 <4872AC70.8030704@kernel.org>
Content-Type: text/plain
Date: Tue, 08 Jul 2008 12:54:49 -0700
Message-Id: <1215546889.6036.16.camel@w-amax.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set builds fine. I booted it and started some preliminary
testing by injecting errors through software. So far it looks good.

Max

On Mon, 2008-07-07 at 16:53 -0700, H. Peter Anvin wrote:
> Applied to -tip as x86/unify-mce.
> 
> Thanks!
> 
> 	-hpa
> 
> 
> Andi Kleen wrote:
> > This patchkit uses the 64bit machine check code which is better in many
> > ways on 32bit x86 too. This is also the basis for some future machine
> > check work.
> > 
> > The 64bit machine check code is in many ways much better than 
> > the 32bit machine check code: it is more specification compliant,
> > is cleaner, only has a single code base versus one per CPU, 
> > has better infrastructure for recovery, has a cleaner way to communicate
> > with user space etc. etc.
> > 
> > It requires testing especially on older systems (on newer
> > ones it should be already tested well in 64bit systems). 
> > 
> > The patchkit contains several parts:
> > - It ports over a few needed quirks (for older Intel and older
> > AMD CPUs) to the 64bit kernel.
> > - It changes the 64bit code to be 32bit clean in its data structures
> > (mostly just unsigned long -> u64 where needed) 
> > - It drops some unused functionality that cannot be easily implemented on 32bit
> > and didn't seem worth ifdefing
> > 
> > Tested by doing some software level error injection on a few
> > different machines
> > 
> > I request this code is merged into the appropiate tree for linux-next
> > for wider testing. It's not .27 ready, but hopefully .28, but it requires
> > wider exposure now.
> > 
> > v2: Fix compilation problems noted by hpa in some configurations
> >     Fix strict_strtoul() conversion
> > 
> > -Andi 
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


