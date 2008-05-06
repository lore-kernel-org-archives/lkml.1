Return-Path: <linux-kernel-owner+w=401wt.eu-S1761559AbYEFOfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761559AbYEFOfx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 10:35:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754454AbYEFOfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 10:35:43 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:50594 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936AbYEFOfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 10:35:42 -0400
Message-ID: <48206C73.80509@s5r6.in-berlin.de>
Date: Tue, 06 May 2008 16:34:27 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.13) Gecko/20080313 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Alistair John Strachan <alistair@devzero.co.uk>, Robin Holt <holt@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.26-rc1
References: <alpine.LFD.1.10.0805031205330.2971@woody.linux-foundation.org>	<20080504160904.GF19717@sgi.com>	<Pine.LNX.4.64.0805051656180.3218@bombadil.infradead.org>	<200805060902.25835.alistair@devzero.co.uk> <20080506073134.424780a3@gaivota>
In-Reply-To: <20080506073134.424780a3@gaivota>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mauro Carvalho Chehab wrote:
> the Kconfig logic for V4L/DVB is complex. It tries to address two
> different issues:
> 	- an easy board selection for the end-user (just selecting CX88 should
> allow his board to work);
> 	- an advanced selection for embedded set-top-boxes, where you can
> select just what you really need.
> 
> Due to that, there are several "select" clauses, that don't consider the
> "depends on". So, it is very easy to break it, unfortunately.

No, it is not easy to break, it /is/ broken.

But it is /trivial/ to fix.  If A selects B, you have to copy all of B's
dependencies to A or select these dependencies by A.

So it's totally simple to do it right.  The only nuisance is that you
always have to update B's dependencies and selections whenever A's
dependencies are changed.

Furthermore:  If you are worried that people don't figure out how to
switch on support for board XYZ because it has several dependencies
which may hide CONFIG_XYZ, there is a very simple trick.

comment "XYZ cards need ABC"
	depends on ABC=n

config XYZ
	tristate "XYZ cards"
	depends on ABC

This way you avoid "select ABC", but still see how to get XYZ support
while ABC is off.  See for example drivers/ieee1394/Kconfig for an
application of this comment trick.
-- 
Stefan Richter
-=====-==--- -=-= --==-
http://arcgraph.de/sr/
