Return-Path: <linux-kernel-owner+w=401wt.eu-S1759014AbXIXPT3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759014AbXIXPT3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 11:19:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752619AbXIXPTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 11:19:23 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1430 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753532AbXIXPTW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 11:19:22 -0400
Subject: Re: [RFC] New kernel-message logging API
From: Joe Perches <joe@perches.com>
To: holzheu@linux.vnet.ibm.com
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Rob Landley <rob@landley.net>,
       Dick Streefland <dick.streefland@altium.nl>
In-Reply-To: <1190625742.12666.30.camel@localhost.localdomain>
References: <19f34abd0709221227v67443c0bg2cd2010e5bd5a6c1@mail.gmail.com>
	 <1190625742.12666.30.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 24 Sep 2007 08:19:16 -0700
Message-Id: <1190647156.30132.92.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-09-24 at 11:22 +0200, Michael Holzheu wrote:
> Together with the idea of not allowing multiple lines in the kprint_xxx
> functions, that would go with our approach having message numbers to
> identify a message.

How does this equate/give message numbers?

> If you do it like that, you can't support "%s", since then you would
> store only the pointer and not the whole string. I think, that we can't
> live without %s.

long long would not work either.

Perhaps it's better to scan the format string or indirect the
printk formatting logic.

Another possibility:

An added pass between gcc preprocessor and compiler could compact
or compress the format string without modifying the conversion
specifications so __attribute__ ((format (printf)) would still work.

printk could expand the compacted/compressed format.


