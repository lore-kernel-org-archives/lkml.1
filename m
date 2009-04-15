Return-Path: <linux-kernel-owner+w=401wt.eu-S1757798AbZDOCGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757798AbZDOCGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 22:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753648AbZDOCGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 22:06:40 -0400
Received: from ozlabs.org ([203.10.76.45]:57375 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300AbZDOCGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 22:06:40 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [patch 10/14] smp: fix cpu_possible_map initialization
Date: Wed, 15 Apr 2009 11:36:34 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       Heiko Carstens <heiko.carstens@de.ibm.com>
References: <20090414135327.576111185@de.ibm.com> <20090414135348.874771700@de.ibm.com>
In-Reply-To: <20090414135348.874771700@de.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904151136.34934.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Apr 2009 11:23:37 pm Martin Schwidefsky wrote:
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> The cpu_possible_map by default is initialized with all ones in s390.
> If the kernel paramert possible_cpus=<x> is passed the cpu_possible_map
> is supposed to have x bits set.
> However the current code just sets the x bits without clearing the NR_CPUS
> bits that were already set. So we end up with an unchanged map that has
> all bits set.
> To fix this just clear the map before setting any new bits.

You're right; I created this patch back before I did the
CONFIG_INIT_ALL_POSSIBLE patch.

It'd be nice to wean S390 off CONFIG_INIT_ALL_POSSIBLE, then there'd
only be two (parisc and m32r).  But it's a minor wart.

Thanks,
Rusty.
