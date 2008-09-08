Return-Path: <linux-kernel-owner+w=401wt.eu-S1753424AbYIHJq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbYIHJq4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 05:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752376AbYIHJqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 05:46:47 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:31500 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752035AbYIHJqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 05:46:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=vvCs6SVlLfM0mqEr3ghWo9PSB73kmqcRRXzvaHdDNJk53fWu9N2vjeZ9AU2rpkGlTWt03glKps8IpBzfvPm+zJHkXlDIA2uoo6/3Umc4amPhOt73ZUDlE2uipDk2oBIQDjx5lIYlkvsmlL2XILyZXxICarkTs0/Ne3lRJ40VCuc=  ;
X-YMail-OSG: iAsQnO0VM1lHxyhYYp.lzQ2AEsDx_kpBQAfyd7oY.8kv5DDO3b_K8SvoLp2HV.U6JWc9j.M6s2jUO7kmLgAnK.YbyyiiNKkM2Am..aq3z_XDsBlrmn5swNqOxTF3CbzKaqo-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] [RESEND] x86_64: add memory hotremove config option
Date: Mon, 8 Sep 2008 19:46:30 +1000
User-Agent: KMail/1.9.5
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>, Gary Hade <garyhade@us.ibm.com>,
       linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
       Badari Pulavarty <pbadari@us.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
       Chris McDermott <lcm@us.ibm.com>, linux-kernel@vger.kernel.org,
       x86@kernel.org, Ingo Molnar <mingo@elte.hu>
References: <20080905215452.GF11692@us.ibm.com> <200809081552.50126.nickpiggin@yahoo.com.au> <20080908093619.GC26079@one.firstfloor.org>
In-Reply-To: <20080908093619.GC26079@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809081946.31521.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 September 2008 19:36, Andi Kleen wrote:
> > You use non-linear mappings for the kernel, so that kernel data is
> > not tied to a specific physical address. AFAIK, that is the only way
> > to really do it completely (like the fragmentation problem).
>
> Even with that there are lots of issues, like keeping track of
> DMAs or handling executing kernel code.

Right, but the "high level" software solution is to have nonlinear
kernel mappings. Executing kernel code should not be so hard because
it could be handled just like executing user code (ie. the CPU that
is executing will subsequently fault and be blocked until the
relocation is complete).

DMAs aren't trivial at all, but I guess there could be say, a method
to submit and revoke areas of memory for DMA, and the submit would
block if the memory is currently being relocated underneath it (then
it would be able to find the new address).

Anwyay, whatever the case, yeah I'm not trying to say it is trivial
at all. Even without thinking about DMA it would be costly.


> > Of course, I don't think that would be a good idea to do that in the
> > forseeable future.
>
> Agreed.

Same as the "anti-frag" patches. We must not proceed with this kind of
thing on the justification that "in future we'll be able to unplug any
bit of memory". Because it is not just a matter of logical steps to
reach that point, but basically a fundamental rethink of how the kernel
memory mapping should work.

Other realistic justifications are OK, but if someone wants to unplug
everything, then please put effort into *first* making the kernel
mapping nonlinear, and then we can look at the complexity and
performance costs of that fundamental step.
