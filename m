Return-Path: <linux-kernel-owner+w=401wt.eu-S1760880AbZBEUBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760880AbZBEUBo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 15:01:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948AbZBEUBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 15:01:35 -0500
Received: from movementarian.org ([79.99.65.163]:40120 "EHLO movementarian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103AbZBEUBe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 15:01:34 -0500
Date: Thu, 5 Feb 2009 14:58:17 -0500
From: wli@movementarian.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Hugh Dickins <hugh@veritas.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: pud_bad vs pud_bad
Message-ID: <20090205195817.GF10229@movementarian.org>
References: <498B2EBC.60700@goop.org> <20090205184355.GF5661@elte.hu> <498B35F9.601@goop.org> <20090205191017.GF20470@elte.hu> <Pine.LNX.4.64.0902051921150.30938@blonde.anvils> <20090205194932.GB3129@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090205194932.GB3129@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Hugh Dickins <hugh@veritas.com> wrote:
>> Simpler and more compact, but not as strict: in particular, a value of
>> 0 or 1 is identified as bad by that 64-bit test, but not by the 32-bit.

On Thu, Feb 05, 2009 at 08:49:32PM +0100, Ingo Molnar wrote:
> yes, indeed you are right - the 64-bit test does not allow the KERNPG_TABLE 
> bits to go zero.
> Those are the present, rw, accessed and dirty bits. Do they really matter 
> that much? If a toplevel entry goes !present or readonly, we notice that 
> _fast_, without any checks. If it goes !access or !dirty - does that matter?
> These checks are done all the time, and even a single instruction can count. 
> The bits that are checked are enough to notice random memory corruption.
> ( albeit these days with large RAM sizes pagetable corruption is quite rare 
>   and only happens if it's specifically corrupting the pagetable - and then 
>   it's not just a single bit. Most of the memory corruption goes into the 
>   pagecache. )

The RW bit needs to be allowed to become read-only for hugetlb COW.
Changing it over to the 32-bit method is a bugfix by that token.


-- wli
