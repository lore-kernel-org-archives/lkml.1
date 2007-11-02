Return-Path: <linux-kernel-owner+w=401wt.eu-S1754083AbXKBFbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083AbXKBFbY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 01:31:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbXKBFbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 01:31:15 -0400
Received: from ozlabs.org ([203.10.76.45]:45499 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027AbXKBFbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 01:31:14 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18218.44709.383144.771700@cargo.ozlabs.ibm.com>
Date: Fri, 2 Nov 2007 15:59:17 +1100
From: Paul Mackerras <paulus@samba.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Differences in bitops argument types
In-Reply-To: <20071101222305.GA28830@duck.suse.cz>
References: <20071101222305.GA28830@duck.suse.cz>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara writes:

>   I've just found out that operations like constant_test_bit() take pointer
> of different types on different architectures. In particular, x86_64,
> blackfin and frv take void * while i386, s390 and m68k take unsigned long
> *. Is this intended difference? Wouldn't using void * everywhere be more
> appropriate? Thanks for answer in advance.

A bitmap is defined to be an array of unsigned longs.  Using an array
of a smaller or longer type will give different results on big-endian
architectures.  Therefore using unsigned long * is better, because it
finds errors where callers are using an array of some other type.

Paul.
