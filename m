Return-Path: <linux-kernel-owner+w=401wt.eu-S1755767AbYIIPsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767AbYIIPsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 11:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753393AbYIIPsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 11:48:08 -0400
Received: from gw.goop.org ([64.81.55.164]:36626 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753370AbYIIPsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 11:48:08 -0400
Message-ID: <48C69AB6.20500@goop.org>
Date: Tue, 09 Sep 2008 08:48:06 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Keir Fraser <keir.fraser@eu.citrix.com>
CC: Avi Kivity <avi@qumranet.com>, Ingo Molnar <mingo@elte.hu>,
       Xen Devel <xen-devel@lists.xensource.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] Re: [PATCH 1 of 7] x86: add _PAGE_IOMAP pte flag
 for IO mappings
References: <C4EC54D0.26EEA%keir.fraser@eu.citrix.com>
In-Reply-To: <C4EC54D0.26EEA%keir.fraser@eu.citrix.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keir Fraser wrote:
> That's basically what our _PAGE_IO flag (in our old Linux patchset) means.
> We use it to cause pte_pfn() to return an invalid pfn and hence avoid
> reference counting that way. Since kernel mappings are never reference
> counted (I think?) perhaps we could use _PAGE_SPECIAL even if it is
> restricted to use on user mappings.

Well, _PAGE_IOMAP's most important semantic from Xen's perspective is
that the frame number is considered to already be an MFN and so isn't
converted.  It may be that _PAGE_SPECIAL is also useful for its "no
refcount" properties, but we could set both in that case.

At present we can't set _PAGE_SPECIAL on kernel mappings because we
assume its usermode only, and its shared with _PAGE_CPA_TEST which is
kernel-only.  Most _PAGE_IOMAP mappings are in kernel space, but I
wouldn't discount user mappings if we end up allowing direct access to
passthrough devices.

    J
