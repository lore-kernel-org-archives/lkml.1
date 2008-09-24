Return-Path: <linux-kernel-owner+w=401wt.eu-S1753977AbYIXPIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbYIXPIR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 11:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751681AbYIXPIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 11:08:05 -0400
Received: from mail.agmk.net ([91.192.224.71]:54632 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550AbYIXPIE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 11:08:04 -0400
To: linux-kernel@vger.kernel.org
Subject: [kernel-abi] symbol versioning vs. out-of-tree modules.
Date: Wed, 24 Sep 2008 17:07:59 +0200
X-Mailer: IlohaMail/0.8.13 (On: agmk.net)
Message-ID: <Y165ES5i.1222268879.9618400.pluto@agmk.net>
From: "=?ISO-8859-2?Q?Pawe=B3?= Sikora" <pluto@agmk.net>
Bounce-To: "=?ISO-8859-2?Q?Pawe=B3?= Sikora" <pluto@agmk.net>
MIME-Version: 1.0 
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

with out-of-tree kernel modules we (users and linux distributions)
have a problem - with every frequent kernel release we need
to rebuild them all due to vermagic and possible abi changes.
this leads to lot of useless work (bumping rpm specs releases,
preparing rpm packages and so on).

naturally we could workaround the modprobe vermagic errors
but we currently can't detect the big-bang kernel abi changes.
e.g., some kernel function changes its parameter list while
the exported function(symbol) name still staying unchanged.
finally we get a modprobe-big-bang.

in fact, we can't use a c++ symbol name mangling to avoid
such problems but kernel build system could use a linker script
to versioning symbols (like glibc/libgcc). during the abi change,
kernel developers could just bump the symbol version and
external modules could be refused during loading with
'unresolved symbol' error which is imho much better solution
that an oops.

is it acceptable and possible to introducing such solution?
thanks for comments.

BR,
pawel.
