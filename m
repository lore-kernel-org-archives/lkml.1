Return-Path: <linux-kernel-owner+w=401wt.eu-S1752005AbZAZHvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbZAZHvB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 02:51:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751301AbZAZHuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 02:50:52 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:10168 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbZAZHuw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 02:50:52 -0500
Message-Id: <497D798C.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Mon, 26 Jan 2009 07:51:24 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Xen-devel" <xen-devel@lists.xensource.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: [Xen-devel] [PATCH 2/2] x86: add
	 pte_set_flags/clear_flags	 forpteflag manipulation
References: <4978F216.5040803@goop.org> <49798A5E.76E4.0078.0@novell.com>
 <497A3117.2070809@goop.org>
In-Reply-To: <497A3117.2070809@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Jeremy Fitzhardinge <jeremy@goop.org> 23.01.09 22:05 >>>
>Jan Beulich wrote:
>> I think a comment (or event a BUG_ON()) should be added here to make
>> clear that this absolutely must not be used to toggle the present bit. I
>> even view toggling _PAGE_PSE as dangerous this way.
>>
>> And alternative would be to make these macros and #undef them (or keep
>> them inline functions but add destructive #define-s) after all their users.
>>   
>
>I don't see any particular problem with changing PSE or even Present 
>with these functions; they don't operate on live in-memory ptes, so its 
>not like they could ever be used to modify a pte unless followed with 
>some kind of set_pte operation.  It is unwise to change any pte flag 
>without knowing what you're doing (though P or PSE would probably have 
>less subtle effects than some of the others).

Whether a pte is live doesn't matter here: If you change P on Xen, the
frame number representation *must* change from/to PFN to/from MFN.
In no case (other than iomem pages) is it allowed to flip just this bit.

Jan

