Return-Path: <linux-kernel-owner+w=401wt.eu-S1758289AbYFEPeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758289AbYFEPeX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 11:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753223AbYFEPeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 11:34:16 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:41546 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391AbYFEPeP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 11:34:15 -0400
Message-Id: <484823BD.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Thu, 05 Jun 2008 16:34:53 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "Stable Kernel" <stable@kernel.org>, <x86@kernel.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: set PAE PHYSICAL_MASK_SHIFT to match 64-bit
References: <4848046A.5060006@goop.org>
In-Reply-To: <4848046A.5060006@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>The 46-bit mask used in 64-bit seems pretty arbitrary.  The physical
>size could be between 40 and 52 bits.  Setting the mask to 40 bits
>would restrict the physical size to 1TB, which is definitely too
>small.  Setting it to 52 would be ridiculously large, and runs the
>risk that one of the vendors may decide to put flags rather than
>physical address in one of the upper reserved bits.

Hmm? There's 11 bits available - why would anyone want to assign bits
from the sufficiently official (at least as far as AMD is concerned, I'm not
sure I saw a precise statement on Intel's side) frame number bits? And
even if they would, it would certainly take some control register bit to
enable the feature, so shrinking the mask if that would ever happen
would seem more appropriate.

Bottom line - I'd suggest pushing both 32- and 64-bits up to 52.

Jan

