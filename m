Return-Path: <linux-kernel-owner+w=401wt.eu-S1755770AbZJJIjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755770AbZJJIjM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 04:39:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755567AbZJJIjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 04:39:09 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:60377 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755521AbZJJIjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 04:39:07 -0400
From: Thomas Schlichter <thomas.schlichter@web.de>
To: Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [RFC Patch] use MTRR for write combining if PAT is not available
Date: Sat, 10 Oct 2009 10:31:15 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.28.10-modified-ioremap; KDE/4.3.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Thomas Hellstrom <thellstrom@vmware.com>
References: <200910100322.36857.thomas.schlichter@web.de> <4AD00C89.3000503@linux.intel.com>
In-Reply-To: <4AD00C89.3000503@linux.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910101031.15620.thomas.schlichter@web.de>
X-Provags-ID: V01U2FsdGVkX19kHg6H/WNTnc1r0s0urTqHtbMk2D0XfJPA5aNI
	uITX0N1m2cYz/U8knArrEOWM01AlzGjQtIoIAv0b5HUUwwX0ss
	lh+SMsaQEaR3BQLr4tyQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag 10 Oktober 2009 06:24:41 schrieb Arjan van de Ven:
> Thomas Schlichter wrote:
> > Hi,
> >
> > I've found a problem with X.org not setting up MTRR for the framebuffer
> > memory. After I investigated I think this is not a X.org problem, but a
> > kernel issue.
> 
> is there any CPU left that does not support PAT ?
> 
> eg in other words, should we try instead to get PAT working for you?

Hmm, my CPU (VIA Nano) seems to support PAT, but Ubuntu disables this
feature in its kernel config. I'm using 9.04, but even 9.10 will have PAT
disabled:

http://kernel.ubuntu.com/git?p=ubuntu/ubuntu-
karmic.git;a=blob;f=debian.master/config/config.common.ubuntu;h=a43cbabd02bfdf5412de6fea232db86aa5d3e742;hb=HEAD

The patch I sent does nothing if PAT is enabled, so it should be quite
safe for this case. And for the case when PAT is not enabled, it simply
tries to set up MTRR entries, if this fails it will still behave like
it does today...

So, convincing Ubuntu to enable PAT would be a workaround, but I think
the problem would still exist and should be fixed.

Kind regards,
  Thomas
