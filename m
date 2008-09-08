Return-Path: <linux-kernel-owner+w=401wt.eu-S1754479AbYIHTl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479AbYIHTl6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 15:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752999AbYIHTlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 15:41:49 -0400
Received: from gw.goop.org ([64.81.55.164]:54154 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254AbYIHTls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 15:41:48 -0400
Message-ID: <48C57FF8.9080802@goop.org>
Date: Mon, 08 Sep 2008 12:41:44 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>,
       Xen Devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH 6 of 7] x86: use early_ioremap in __acpi_map_table
References: <patchbomb.1220826072@localhost> <944fe7ea3da7707eb90f.1220826078@localhost> <20080907234418.GB26079@one.firstfloor.org> <48C46BCB.2060209@goop.org> <20080908142619.GA10580@elte.hu>
In-Reply-To: <20080908142619.GA10580@elte.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> uhm, there's a nasty trap in that route: it can potentially cause a lot 
> of breakage.
>
> It's not robust to assume that the ACPI code is sane wrt. 
> mapping/unmapping, because it currently simply doesnt rely on robust 
> unmapping (in the linear range).
>
> I tried it in the past and i found tons of crappy ACPI code all around 
> that just never unmapped tables. Leaking ACPI maps are hard to find as 
> well, and it can occur anytime during bootup.
>   

Yes, you're right, it's a mess.  I put a unmap and warning in there, but
there's lots of acpi code which doesn't unmap after using its table.  It
doesn't seem to intermix using two tables, fortunately, so the "unmap
previous" behaviour of __acpi_map_table works OK, at least as far as I
can see.

    J
