Return-Path: <linux-kernel-owner+w=401wt.eu-S1423459AbXBPJUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423459AbXBPJUb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 04:20:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423465AbXBPJUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 04:20:31 -0500
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:32883 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1423459AbXBPJU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 04:20:29 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=scYGyuaQPDB80HripQBZ1s3gHU0xLtO/9K1Ws6Sny/ns1wYMenwugR/zGL8PBi8CmkVNmibMz5AC5EDdX88PGT6L0chXcvCJdS6mdZA+IvP/dOxMu2ccw/K4WK5E0ml3gS7FvUZPC90dxDM5rQeORLN3MnG0HOwW7DPJeWuAo/g=  ;
X-YMail-OSG: VYA1UFoVM1kEl43mdx.h3HklZO0xhGMgCOGU.1SM262f99ZQrSEUlKnktrF22iEVuSq_qJgKVRj7GfSV_QXZjf7D3JXvXf0Khu_DMaFKtXaqxqPpemh8djCe1RyakRQQdlDLSaxLb5g0L4I-
Message-ID: <45D57738.9030907@yahoo.com.au>
Date: Fri, 16 Feb 2007 20:19:52 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@muc.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>
Subject: Re: [patch 07/21] Xen-paravirt: remove ctor for pgd cache
References: <20070216022449.739760547@goop.org>	 <20070216022531.047039320@goop.org> <84144f020702160039y11fb1f4dl7b77d4358cc189ee@mail.gmail.com>
In-Reply-To: <84144f020702160039y11fb1f4dl7b77d4358cc189ee@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> On 2/16/07, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
>> Remove the ctor for the pgd cache.  There's no point in having the
>> cache machinery do this via an indirect call when all pgd are freed in
>> the one place anyway.
> 
> 
> The reason we have slab constructors and destructors is to _avoid_
> reinitializing every time we allocate an object. AFAICT your changing
> the code now to do _more_ work than before, so is there some other
> reason why you want to do this than avoiding an indirect call?

Sometimes  it is better for the caches to initialise an object
immediately, but in this case I think it is better to use the
slab ctor because it is very unlikely to use many cachelines
immediately anyway.

It would be nice to put the "why" in the changelogs, rather than
"what". Not everyone wants to go through the whole patchset to
decipher why Xen possibly needs something.

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
