Return-Path: <linux-kernel-owner+w=401wt.eu-S1754030AbYAQSwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030AbYAQSwp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 13:52:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752706AbYAQSwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 13:52:36 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:39372 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbYAQSwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 13:52:35 -0500
Date: Thu, 17 Jan 2008 19:52:34 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Andi Kleen <ak@suse.de>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de
Subject: Re: [PATCH] Print which shared library/executable faulted in segfault
 etc. messages v3
In-Reply-To: <20080116231534.GA25995@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0801171948280.9008@fbirervta.pbzchgretzou.qr>
References: <20080116231534.GA25995@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 17 2008 00:15, Andi Kleen wrote:
>
>The previously posted version was missing all the 64bit hunks. Fix
>that. Please use over previous version.
>
>They now look like
>
>hal-resmgr[13791]: segfault at 3c rip 2b9c8caec182 rsp 7fff1e825d30
>error 4 in libacl.so.1.1.0[2b9c8caea000+6000]

Can this also be done for executables?

>This makes it easier to pinpoint bugs to specific libraries.

[But it may very well mean improper usage (e.g. passing NULL where
NULL is definitely not expected) on behalf of the library user ;-)]

>And printing the offset into a mapping also always allows to find
>the correct fault point in a library even with randomized mappings.
>Previously there was no way to actually find the correct code
>address inside the randomized mapping.

Previously, one had to ptrace the process, wait for the crash to
happen, then inspect /proc/XXX/maps and calculate the address. It's
not like developers were left in the dark with random mappings.

