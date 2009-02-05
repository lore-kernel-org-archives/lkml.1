Return-Path: <linux-kernel-owner+w=401wt.eu-S1752828AbZBEUmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbZBEUmU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 15:42:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbZBEUmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 15:42:11 -0500
Received: from gw.goop.org ([64.81.55.164]:52676 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984AbZBEUmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 15:42:09 -0500
Message-ID: <498B4F1F.5070306@goop.org>
Date: Thu, 05 Feb 2009 12:42:07 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Ingo Molnar <mingo@elte.hu>, William Lee Irwin III <wli@movementarian.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: pud_bad vs pud_bad
References: <498B2EBC.60700@goop.org> <20090205184355.GF5661@elte.hu> <498B35F9.601@goop.org> <20090205191017.GF20470@elte.hu> <Pine.LNX.4.64.0902051921150.30938@blonde.anvils>
In-Reply-To: <Pine.LNX.4.64.0902051921150.30938@blonde.anvils>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> However... I forget how the folding works out.  The pgd in the 32-bit
> PAE case used to have just the pfn and the present bit set in that
> little array of four entries: if pud_bad() ends up getting applied
> to that, I guess it will blow up.
>   

Ah, that's a good point.

> If so, my preferred answer would actually be to make those 4 entries
> look more like real ptes; but you may think I'm being a bit silly.
>   

Hardware doesn't allow it.  It will explode (well, trap) if you set 
anything other than P in the top level.

By the by, what are the chances we'll be able to deprecate non-PAE 32-bit?

    J
