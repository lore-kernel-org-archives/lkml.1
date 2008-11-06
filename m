Return-Path: <linux-kernel-owner+w=401wt.eu-S1754455AbYKFKab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455AbYKFKab (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 05:30:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753287AbYKFKaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 05:30:23 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:35876 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbYKFKaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 05:30:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YvWr7Z80c4a9/bu/B5o7KkE13cqAxzEqEZweVF6K+P18GC2Ep6xXDIX7lwexyUSwY0
         Qsker3RWk3gTX04LWFDv87LpinWY9rMmnqtcuLJOYEkS4Ru8yo8UsQG3dCNOtmXaq99P
         U6wmmr1TNKjx6cdE1w9wUC2xHzp8AT0RL5b+A=
Date: Thu, 6 Nov 2008 10:29:58 +0000
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, mingo@elte.hu,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] scripts: script from kerneloops.org to pretty print
	oops dumps
Message-ID: <20081106102958.GA6052@hack.voiplan.pt>
References: <20081105190726.31952581@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081105190726.31952581@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2008 at 07:07:26PM -0800, Arjan van de Ven wrote:
>Hi,
>

Hi,

thanks for your work!

>
>diff --git a/scripts/markup_oops.pl b/scripts/markup_oops.pl
>new file mode 100644
>index 0000000..c8a2200
>--- /dev/null
>+++ b/scripts/markup_oops.pl
>@@ -0,0 +1,165 @@
>+#!/usr/bin/perl -w
>+
>+# Copyright 2008, Intel Corporation
>+#
>+# This file is part of the Linux kernel
>+#
>+# This program file is free software; you can redistribute it and/or modify it
>+# under the terms of the GNU General Public License as published by the
>+# Free Software Foundation; version 2 of the License.
>+#
>+# Authors:
>+# 	Arjan van de Ven <arjan@linux.intel.com>
>+
>+
>+my $vmlinux_name = $ARGV[0];
>+
>+#
>+# Step 1: Parse the oops to find the EIP value
>+# 
>+
>+my $target = "0";
>+while (<STDIN>) {
>+  if ($_ =~ /EIP: 0060:\[\<([a-z0-9]+)\>\]/) {
>+      $target = $1;
>+  }
>+}
>+
>+if ($target =~ /^f8/) {
>+  print "This script does not work on modules ... \n";
>+  exit;
>+}
>+
>+if ($target eq "0") {
>+  print "No oops found!\n";
>+  print "Usage: \n";
>+  print "    dmesg | perl scripts/markup_oops.pl vmlinux\n";
>+  exit;


One thing to note here, no oops doesn't always mean wrong usage. :)
So I think usage should be printed only when the usage is actually
wrong, e.g. ARGV[0] is missed.



>+$start = $center;
>+$codelines = 0;
>+$binarylines = 0;

Why not fold these lines into their definitions?


-- 
"Sometimes the only way to stay sane is to go a little crazy."

