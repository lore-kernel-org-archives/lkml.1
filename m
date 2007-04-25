Return-Path: <linux-kernel-owner+w=401wt.eu-S1423341AbXDYR5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423341AbXDYR5L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 13:57:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423358AbXDYR5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 13:57:11 -0400
Received: from terminus.zytor.com ([192.83.249.54]:60323 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423354AbXDYR5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 13:57:09 -0400
Message-ID: <462F9665.1090602@zytor.com>
Date: Wed, 25 Apr 2007 10:56:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@suse.de>,
       Zachary Amsden <zach@vmware.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i386: For debugging, make the initial page table setup
 less forgiving.
References: <200704132149.l3DLnvUY012097@tazenda.hos.anvin.org>	<20070425044813.f83dde4e.akpm@linux-foundation.org>	<462F73A0.40003@zytor.com> <m1irbks5qa.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1irbks5qa.fsf@ebiederm.dsl.xmission.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
>> This patch only affects the initial page tables, which should have been
>> thrown out *way* long ago at this point.
> 
> Yes.  I noticed this was happening a few days ago.
> I must not have mentioned it loudly enough.

You mentioned the continued use of init_mm.  This is *very* different.

What we're seeing here is that ON PSE-CAPABLE HARDWARE, we continue to
not just use the init_mm page directory, but the actual page *tables*,
which should all have been replaced with PSE large pages to begin with.

Reusing the initial page tables on non-PSE-capable hardware *sort of*
makes sense, but his hardware should not fall in that category, I don't
think?  (Unless it's one of these machines that fall over if you map the
bottom 4 MB with PSE pages?)

	-hpa
