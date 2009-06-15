Return-Path: <linux-kernel-owner+w=401wt.eu-S1763186AbZFOPy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763186AbZFOPy7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 11:54:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751598AbZFOPyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 11:54:52 -0400
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:43957 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751331AbZFOPyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 11:54:51 -0400
X-Trace: 215590464/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.41.232/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.41.232
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnECAO8LNkpQKSno/2dsb2JhbAAI1iWEDQU
X-IronPort-AV: E=Sophos;i="4.42,223,1243810800"; 
   d="scan'208";a="215590464"
Date: Mon, 15 Jun 2009 16:53:58 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Izik Eidus <ieidus@redhat.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] ksm: write protect pages from inside ksm
In-Reply-To: <4A3651D5.8020100@redhat.com>
Message-ID: <Pine.LNX.4.64.0906151640350.7904@sister.anvils>
References: <1244843100-4128-1-git-send-email-ieidus@redhat.com>
 <Pine.LNX.4.64.0906142217270.6369@sister.anvils> <4A3576C3.2040500@redhat.com>
 <4A358DA7.2080305@redhat.com> <4A35903A.3090508@redhat.com>
 <20090615035749.6f8236cc@woof.tlv.redhat.com> <Pine.LNX.4.64.0906151300160.21984@sister.anvils>
 <4A3651D5.8020100@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jun 2009, Izik Eidus wrote:
> 
> So you dont have mmlist at all?, Good i think i found another problems with
> the usage the RFC made with the mmlist,
> Do you mind to send me the patch that move into diffrent mm list? or you still
> want to wait?

I'd really prefer to wait, there are too many questions I should
resolve one way or another now I can test again e.g. do we need
to put children on to the list when forking or not?

But don't let me hold you up: if you believe you've problems sharing
the mmlist, go ahead and separate out - I called the KSM one ksm_mmlist
(surprise!), hanging off init_mm.ksm_mmlist in the same way mmlist does.
And then you can get rid of the MMF flags etc (I've set aside your 4/4
as not something to get into right now - probably the release after).

At present I'm still using mmlist_lock, but that's probably a mistake:
we don't really want to have to consider unrelated lock ordering
constraints, a ksm_mmlist_lock would be better for now.

None of which precludes someone coming along later and combining
ksm_mmlist with mmlist in order to save space: but for now I
think we do better to keep them separate, and it sounds like
you've seen a strong reason for that.

Hugh
