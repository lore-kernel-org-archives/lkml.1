Return-Path: <linux-kernel-owner+w=401wt.eu-S1757297AbZAWVFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297AbZAWVFj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 16:05:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755136AbZAWVFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 16:05:31 -0500
Received: from gw.goop.org ([64.81.55.164]:34479 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753730AbZAWVFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 16:05:31 -0500
Message-ID: <497A3117.2070809@goop.org>
Date: Fri, 23 Jan 2009 13:05:27 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: Ingo Molnar <mingo@elte.hu>, Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [Xen-devel] [PATCH 2/2] x86: add pte_set_flags/clear_flags	 for
 pteflag manipulation
References: <4978F216.5040803@goop.org> <49798A5E.76E4.0078.0@novell.com>
In-Reply-To: <49798A5E.76E4.0078.0@novell.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> I think a comment (or event a BUG_ON()) should be added here to make
> clear that this absolutely must not be used to toggle the present bit. I
> even view toggling _PAGE_PSE as dangerous this way.
>
> And alternative would be to make these macros and #undef them (or keep
> them inline functions but add destructive #define-s) after all their users.
>   

I don't see any particular problem with changing PSE or even Present 
with these functions; they don't operate on live in-memory ptes, so its 
not like they could ever be used to modify a pte unless followed with 
some kind of set_pte operation.  It is unwise to change any pte flag 
without knowing what you're doing (though P or PSE would probably have 
less subtle effects than some of the others).

But it probably wouldn't hurt to have a __ prefix to indicate they're 
"internal" and not for general use.

    J
