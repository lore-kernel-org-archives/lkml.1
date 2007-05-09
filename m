Return-Path: <linux-kernel-owner+w=401wt.eu-S1755926AbXEILhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926AbXEILhj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 07:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752338AbXEILha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 07:37:30 -0400
Received: from ozlabs.org ([203.10.76.45]:52625 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690AbXEILh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 07:37:29 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17985.45682.284634.969153@cargo.ozlabs.ibm.com>
Date: Wed, 9 May 2007 21:37:22 +1000
From: Paul Mackerras <paulus@samba.org>
To: suparna@in.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       xfs@oss.sgi.com, cmm@us.ibm.com
Subject: Re: [PATCH 1/5] fallocate() implementation in i86, x86_64 and powerpc
In-Reply-To: <20070509111011.GA21619@in.ibm.com>
References: <20070418130600.GW5967@schatzie.adilger.int>
	<20070420135146.GA21352@amitarora.in.ibm.com>
	<20070420145918.GY355@devserv.devel.redhat.com>
	<20070424121632.GA10136@amitarora.in.ibm.com>
	<20070426175056.GA25321@amitarora.in.ibm.com>
	<20070426180332.GA7209@amitarora.in.ibm.com>
	<20070503212955.b1b6443c.akpm@linux-foundation.org>
	<17978.47502.786970.196554@cargo.ozlabs.ibm.com>
	<20070509101507.GA26056@in.ibm.com>
	<17985.42884.971318.859402@cargo.ozlabs.ibm.com>
	<20070509111011.GA21619@in.ibm.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Suparna Bhattacharya writes:

> > Of course the interface used by an application program would have the
> > fd first.  Glibc can do the translation.
> 
> I think that was understood.

OK, then what does it matter what the glibc/kernel interface is, as
long as it works?

It's only a minor point; the order of arguments can vary between
architectures if necessary, but it's nicer if they don't have to.
32-bit powerpc will need to have the two int arguments adjacent in
order to avoid using more than 6 argument registers at the user/kernel
boundary, and s390 will need to avoid having a 64-bit argument last
(if I understand it correctly).

Paul.
