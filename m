Return-Path: <linux-kernel-owner+w=401wt.eu-S1759306AbYAKINY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759306AbYAKINY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 03:13:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754521AbYAKINQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 03:13:16 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:29048
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758238AbYAKINP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 03:13:15 -0500
Message-Id: <4787333F.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Fri, 11 Jan 2008 08:13:35 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Glauber de Oliveira Costa" <glommer@gmail.com>,
       "Andi Kleen" <ak@suse.de>, "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0 of 2] x86: a couple of misc patches
References: <patchbomb.1200004569@localhost>
In-Reply-To: <patchbomb.1200004569@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>2. I noticed the _PAGE_PCD|_PAGE_PWT combination being used a lot, so
>I created _PAGE_NOCACHE to wrap them up.  asm-x86/fb.h uses plain
>_PAGE_PCD; should it be _PAGE_NOCACHE too?

Setting PCD but not PWT (or the other way around) is yielding not fully
defined behavior (model specific) as per the doc, so it doen't seem to be
too good an idea to use this. However, adding PWT here may not be what
is desirable either (as it'll make the referenced memory UC unconditionally,
whereas WC is generally more desirable here). It would seem to me,
though, that PWT alone would be the better choice in this situation
(despite this also yielding model specific behavior).

Jan

