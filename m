Return-Path: <linux-kernel-owner+w=401wt.eu-S932201AbXFEIOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201AbXFEIOq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 04:14:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761053AbXFEIOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 04:14:33 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:33359 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758367AbXFEIOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 04:14:32 -0400
Date: Tue, 5 Jun 2007 10:14:07 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Andrew Morton <akpm@osdl.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.03
Message-ID: <20070605081407.GA809@osiris.boeblingen.de.ibm.com>
References: <0a25fd03117c678f17006c5fcefaaed0@pinky>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0a25fd03117c678f17006c5fcefaaed0@pinky>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2007 at 10:46:24AM +0100, Andy Whitcroft wrote:
> 
> This version brings a host of changes to cure false positives and
> bugs detected on patches submitted to lkml and -mm.  It also brings
> a number of new tests in response to reviews, of particular note:
> 
>   - catch use of volatile

It will warn on "asm volatile (" which it shouldn't.

>   - report on architecture specific defines being used

We use architecture specific defines to distinguish between 32 bit and
64 bit code in user space visible header files, since we cannot use
CONFIG_64BIT. So this will give us false positives as well.
Maybe don't warn for header files in include/asm-* ?
