Return-Path: <linux-kernel-owner+w=401wt.eu-S1758731AbZCAX4D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758731AbZCAX4D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 18:56:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757327AbZCAXzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 18:55:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36245 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757273AbZCAXzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 18:55:43 -0500
Message-ID: <49AB1FB8.607@zytor.com>
Date: Sun, 01 Mar 2009 15:52:24 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen: core dom0 support
References: <1235786365-17744-1-git-send-email-jeremy@goop.org>	<20090227212812.26d02f34.akpm@linux-foundation.org>	<49A8DF28.4050301@goop.org> <87eixi35ew.fsf@basil.nowhere.org> <49AB1B75.2060200@goop.org>
In-Reply-To: <49AB1B75.2060200@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> 
> Unless we're planning on dropping support for processes with no or 
> broken PAT support, we're always going to have to deal with the non-PAT 
> case.  Xen just falls into the "processor with no PAT" case.  And 
> if/when we work out how to paravirtualize PAT, it will no longer be in 
> that case.
> 

In this particular case, this is actually false.  "No PAT" in the 
processor is *not* the same thing as "no cacheability controls in the 
page tables".  Every processor since the 386 has had UC, WT, and WB 
controls in the page tables; PAT only added the ability to do WC (and 
WP, which we don't use).  Since the number of processors which can do WC 
at all but don't have PAT is a small set of increasingly obsolete 
processors, we may very well choose to simply ignore the WC capabilities 
of these particular processors.

	-hpa

