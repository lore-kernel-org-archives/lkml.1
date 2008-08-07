Return-Path: <linux-kernel-owner+w=401wt.eu-S1758403AbYHGW3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758403AbYHGW3M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 18:29:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753664AbYHGW25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 18:28:57 -0400
Received: from mail.ocs.com.au ([202.134.241.204]:12430 "EHLO mail.ocs.com.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753065AbYHGW24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 18:28:56 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 (debian 1:2.7.2-12) with nmh-1.2
From: Keith Owens <kaos@ocs.com.au>
To: Andi Kleen <andi@firstfloor.org>
cc: Jay Lan <jlan@sgi.com>, Christoph Lameter <cl@linux-foundation.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>, jmerkey@wolfmountaingroup.com,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
       Takenori Nagano <t-nagano@ah.jp.nec.com>,
       Vivek Goyal <vgoyal@redhat.com>, Bernhard Walle <bwalle@suse.de>
Subject: Re: [ANNOUNCE] Merkey's Kernel Debugger 
In-reply-to: Your message of "Thu, 07 Aug 2008 22:06:59 +0200."
             <20080807200659.GJ24801@one.firstfloor.org> 
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Fri, 08 Aug 2008 08:28:54 +1000
Message-ID: <23175.1218148134@ocs10w>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen (on Thu, 7 Aug 2008 22:06:59 +0200) wrote:
>> To merge KDB or any other RAS tools, you need to deal with kdump. Kdump
>> hijack panic() before the die calling chain. For KDB or a RAS tool to
>
>Imho kdump should just be fixed to use die chains.

Violently agree, especially since the IA64 handling of NMI type
events is significantly different from x86 and requires at least two
callbacks via the die chain.

Alas the kdump authors are adamant that they will not use die chains,
which makes it almost impossible for any other RAS code to coexist with
kdump.  This intransigence on the part of kdump is one of the reasons
that I gave up on getting _any_ RAS code (not just KDB) into the Linux
kernel.

See http://kerneltrap.org/node/14050 and
http://marc.info/?l=linux-arch&m=116304508731232&w=2, the latter
explains why you need die chains to handle IA64 correctly.  x86
debugging is relatively easy, ia64 is hard due to interactions between
the firmware and the OS, either can stop the other cpus.  If your
debugging framework does not handle ia64 INIT and MCA events, then you
cannot debug most of the interesting ia64 events.

In any case, we have gone round this loop too many times for me to care
about it any more.  I have given up on Linux RAS code.

