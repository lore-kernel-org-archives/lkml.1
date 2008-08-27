Return-Path: <linux-kernel-owner+w=401wt.eu-S1754957AbYH0SwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957AbYH0SwK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 14:52:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752228AbYH0Sv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 14:51:57 -0400
Received: from mail2.shareable.org ([80.68.89.115]:37247 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbYH0Sv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 14:51:57 -0400
Date: Wed, 27 Aug 2008 19:51:42 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Bruce_Leonard@selinc.com
Cc: dedekind@infradead.org, linux-mtd-bounces@lists.infradead.org,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Bruce Leonard <brucle@earthlink.net>
Subject: Re: [PATCH 2/2] Add support for > 2GiB MTD devices
Message-ID: <20080827185142.GE27491@shareable.org>
References: <1219815617.18027.132.camel@sauron> <OF5BDBDD21.E5375C78-ON882574B2.0061B127-882574B2.00648B63@selinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OF5BDBDD21.E5375C78-ON882574B2.0061B127-882574B2.00648B63@selinc.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bruce_Leonard@selinc.com wrote:
> I'm still reluctant to change size to a 64-bit value.  There's a vague 
> recolection of early conversations on the list that there would be little 
> acceptance for that.  And that probably has to do with the ongoing 
> conversation about ABI changes.  What I could do to eliminate the 
> multiplication is introduce the same concept that the NAND layer uses, 
> shift values.  After all, erasesize should always be a power of 2, making 
> that a power of 2 multiplication which can be done via shifts.  By 
> changing erasesize to erasesize_shift, I'd get something like this:
> 
> return a->num_eraseblocks == 0 ? a->size : a->num_eraseblocks << 
> a->erasesize_shift
> 
> How would that suit you?

Are you sure it's always going to be a power of 2?

What if someone targets a board with 3 chips wired to shared address
and parallel data buses?

Or if someone makes a weird chip?  Or if you can format it in
different ways according to desired ECC level (like you can with CDs)?

If there's ongoing conversation about ABI changes, it sounds like it
would be good for this change to be done together that, instead of
doing this change then changing the ABI _again_ shortly after and
having to support 3 different ABIs in tools instead of 2.

-- Jamie
