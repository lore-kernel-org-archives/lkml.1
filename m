Return-Path: <linux-kernel-owner+w=401wt.eu-S1764455AbYCELOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764455AbYCELOU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 06:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751316AbYCELOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 06:14:08 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:17862
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751324AbYCELOH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 06:14:07 -0500
Message-Id: <47CE8EAD.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 Beta 
Date: Wed, 05 Mar 2008 11:14:37 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: <linux-kernel@vger.kernel.org>
Subject: profile_pc() bogus since <= 2.6.19 (x86 at least)?
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

while the comment at the top of kernel/spinlock.c states so:

 * Note that some architectures have special knowledge about the
 * stack frames of these functions in their profile_pc. If you
 * change anything significant here that could change the stack
 * frame contact the architecture maintainers.

the actual code doesn't seem to match this anymore. With all (and
even before that, many) functions being written in C, there cannot
be validly made assumptions about the stack frame layout. Indeed,
if I check the disassembly framed by __lock_text_{start,end} on
x86, there are a number of functions that push one or two registers
(in lock_kernel() even stack variables are being allocated), which
clearly breaks profile_pc()'s assumptions.

Since it's been this way for so long, I wonder how frequently this
code is actually being exercised...

Jan

