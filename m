Return-Path: <linux-kernel-owner+w=401wt.eu-S1756923AbXFMHtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923AbXFMHtR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 03:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756081AbXFMHtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 03:49:07 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:54936 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756059AbXFMHtF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 03:49:05 -0400
Message-Id: <466FBDC1.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Wed, 13 Jun 2007 09:49:53 +0200
From: "Jan Beulich" <jbeulich@novell.com>
To: "Satyam Sharma" <satyam.sharma@gmail.com>
Cc: "Venkatesh Pallipadi" <venkatesh.pallipadi@intel.com>,
       "Sam Ravnborg" <sam@ravnborg.org>, "Andi Kleen" <ak@suse.de>,
       <linux-kernel@vger.kernel.org>, <patches@x86-64.org>
Subject: Re: [PATCH] x86: fix improper .init-type section references
References: <466E6BDF.76E4.0078.0@novell.com>
 <a781481a0706120509k89c331ela81f57ad0f0e29eb@mail.gmail.com>
 <466EB12B.76E4.0078.0@novell.com>
 <a781481a0706120632p54ad83d0ka0a07a9fd9b276b4@mail.gmail.com>
 <466EC08A.76E4.0078.0@novell.com>
 <a781481a0706120709v5a2d1147m9d372a8056aeba6d@mail.gmail.com>
 <20070612180002.GC15329@uranus.ravnborg.org>
 <a781481a0706122018i6273cd17y61cd95e269b5c7c9@mail.gmail.com>
 <20070613043526.GA20088@uranus.ravnborg.org>
 <466FB20D.76E4.0078.0@novell.com>
 <a781481a0706130039r26e9522q98d9645809136ea7@mail.gmail.com>
In-Reply-To: <a781481a0706130039r26e9522q98d9645809136ea7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>But then why not simply lose the __exit (and .exit.*) altogether? Because
>__exit becomes redundant in the suggested changed semantics -- just mark
>all the cleanup code as __init too (when it's built-in, the only
>callsite for the
>cleanup code would be from the startup code in .init.*, and when modular,
>__init and __exit lose all relevance anyway).

Because of the non-builtin case (__init still has significance in the modular case,
it's only __exit that doesn't). For the builtin case, __init could certainly be
identical to __exit.

Jan

