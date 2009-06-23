Return-Path: <linux-kernel-owner+w=401wt.eu-S1753029AbZFWRKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029AbZFWRKz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 13:10:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbZFWRKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 13:10:44 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:57785 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607AbZFWRKm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 13:10:42 -0400
X-SpamScore: -24
X-BigFish: VPS-24(z34a4jz1432R98dR4015L1805Mzz1202hzzz32i17ch6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KLPBP7-03-SKN-01
Date: Tue, 23 Jun 2009 19:10:22 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <marcelo@kvack.org>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] kvm/mmu: make direct mapping paths aware of
	mapping levels
Message-ID: <20090623171022.GI5139@amd.com>
References: <1245417389-5527-1-git-send-email-joerg.roedel@amd.com> <1245417389-5527-6-git-send-email-joerg.roedel@amd.com> <20090623164728.GB3651@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090623164728.GB3651@amt.cnet>
User-Agent: Mutt/1.5.19 (2009-01-05)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 23 Jun 2009 17:10:23.0436 (UTC) FILETIME=[7EC1B0C0:01C9F425]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 01:47:28PM -0300, Marcelo Tosatti wrote:
> On Fri, Jun 19, 2009 at 03:16:26PM +0200, Joerg Roedel wrote:
> > @@ -254,7 +254,7 @@ static int is_last_spte(u64 pte, int level)
> >  {
> >  	if (level == PT_PAGE_TABLE_LEVEL)
> >  		return 1;
> > -	if (level == PT_DIRECTORY_LEVEL && is_large_pte(pte))
> > +	if (is_large_pte(pte))
> >  		return 1;
> 
> Wouldnt it be safer to check for bit 7 only on the levels
> we're sure it means large page?

If we are not on PT_PAGE_TABLE_LEVEL and this bit does not mean "large page"
then bit 7 is MBZ and harware would fault. So it should be safe to just check
for bit 7 here.


> >  	kvm_get_pfn(pfn);
> >  	mmu_set_spte(vcpu, spte, page->role.access, pte_access, 0, 0,
> > -		     gpte & PT_DIRTY_MASK, NULL, largepage,
> > +		     gpte & PT_DIRTY_MASK, NULL, level,
> >  		     gpte_to_gfn(gpte), pfn, true);
> 
> It would be better to just turn off updates to large sptes via          
> update_pte path, so just nuke them and let the pagefault path
> handle.

Yeah true. Thats in the shadow paging patch. Maybe I can get it into a state to
be postable again ;-)

Thanks,

	Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

