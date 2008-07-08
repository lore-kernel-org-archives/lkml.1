Return-Path: <linux-kernel-owner+w=401wt.eu-S1757639AbYGHXOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757639AbYGHXOu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:14:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755367AbYGHXOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:14:37 -0400
Received: from gw.goop.org ([64.81.55.164]:51185 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754692AbYGHXOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:14:37 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 00 of 55] xen64: implement 64-bit Xen support
Message-Id: <patchbomb.1215554782@localhost>
Date: Tue, 08 Jul 2008 15:06:22 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Here's the set of patches to implement 64-bit Xen support.

The first part of the series is some more (fairly minor) x86 arch
updates which here missed in the previous series.

Following that are the Xen-specific changes to implement 64-bit
support.  It works fairly well, but I know of a couple of bugs:

 - 32-bit emulation doesn't work properly yet.  Something goes wrong
   with %gs, and a userspace %gs: reference segfaults.

 - It crashes when bringing up secondary CPUs under some combinations
   of config.  I think it isn't quite setting up all the CPU sibling
   topology stuff for the various scheduler policies.  It's trying to
   set up the most simple of arrangements (every CPU is a singleton
   with no shared cache or anything else).  It was quite tricky to
   arrange this...

I hope to have followup patches to address both of these in the next
couple of days.  I expect both fixes will be small.

Thanks,
	  J

