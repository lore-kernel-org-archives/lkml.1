Return-Path: <linux-kernel-owner+w=401wt.eu-S1765574AbXLUAlI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765574AbXLUAlI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 19:41:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759140AbXLUAky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 19:40:54 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58090 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758498AbXLUAky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 19:40:54 -0500
Date: Thu, 20 Dec 2007 16:34:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrew Morgan <morgan@kernel.org>
Cc: serue@us.ibm.com, containers@lists.osdl.org, linux-kernel@vger.kernel.org,
       minslinux-mm@kvack.org
Subject: Re: [RFC] [PATCH -mm] oom_kill: remove uid==0 checks
Message-Id: <20071220163442.d93210ea.akpm@linux-foundation.org>
In-Reply-To: <47606969.6060808@kernel.org>
References: <20071212211835.GA24943@sergelap.austin.ibm.com>
	<47606969.6060808@kernel.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Dec 2007 15:06:17 -0800
Andrew Morgan <morgan@kernel.org> wrote:

> Serge E. Hallyn wrote:
> > Andrew, I've cc:d you here bc in doing this patch I noticed that your
> > 64-bit capabilities patch switched this code from an explicit check
> > of cap_t(p->cap_effective) to using __capable().  That means that
> > now being glossed over by the oom killer means PF_SUPERPRIV will
> > be set.  Is that intentional?
> 
> Yes, I switched the check because the old one didn't work with the new
> capability representation.
> 
> However, I had not thought this aspect of this replacement through. At
> the time, it seemed obvious but in this case it actually depends on
> whether you think using privilege (PF_SUPERPRIV) means "benefited from
> privilege", or "successfully completed a privileged operation".
> 
> I suspect, in this case, the correct thing to do is add the equivalent of:
> 
> #define CAPABLE_PROBE_ONLY(a,b)   (!security_capable(a,b))
> 
> and use that in the code in question. That is, return to the old
> behavior in a way that will not break if we ever need to add more bits.

I'm struggling to understand whether the above was an ack, a nack or a
quack.

> Thanks for finding this.

>From that I'll assume ack ;)
