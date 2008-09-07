Return-Path: <linux-kernel-owner+w=401wt.eu-S1751973AbYIGXk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973AbYIGXk4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 19:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750823AbYIGXks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 19:40:48 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45736 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbYIGXks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 19:40:48 -0400
Date: Mon, 8 Sep 2008 01:44:18 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>,
       Xen Devel <xen-devel@lists.xensource.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 6 of 7] x86: use early_ioremap in __acpi_map_table
Message-ID: <20080907234418.GB26079@one.firstfloor.org>
References: <patchbomb.1220826072@localhost> <944fe7ea3da7707eb90f.1220826078@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <944fe7ea3da7707eb90f.1220826078@localhost>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 07, 2008 at 03:21:18PM -0700, Jeremy Fitzhardinge wrote:
> __acpi_map_table() effectively reimplements early_ioremap().  Rather
> than have that duplication, just implement it in terms of
> early_ioremap().
> 
> However, unlike early_ioremap(), __acpi_map_table() just maintains a
> single mapping which gets replaced each call, and has no corresponding
> unmap function.  Implement this by just removing the previous mapping
> each time its called.  Unfortunately, this will leave a stray mapping
> at the end.

It would be better to just fix the ACPI code to unmap.

-Andi
