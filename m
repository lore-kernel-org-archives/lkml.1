Return-Path: <linux-kernel-owner+w=401wt.eu-S1753352AbYKYTI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbYKYTI4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 14:08:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752516AbYKYTIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 14:08:48 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:52373 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751793AbYKYTIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 14:08:47 -0500
Subject: Re: [Patch 0/3] OProfile SPU event profiling support for IBM Cell
	processor
From: Carl Love <cel@us.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       oprofile-list@lists.sourceforge.net, cel <cel@linux.vnet.ibm.com>,
       cbe-oss-dev <cbe-oss-dev@ozlabs.org>
In-Reply-To: <200811251700.30926.arnd@arndb.de>
References: <1227568781.6509.198.camel@carll-linux-desktop>
	 <200811251700.30926.arnd@arndb.de>
Content-Type: text/plain
Date: Tue, 25 Nov 2008 11:07:51 -0800
Message-Id: <1227640071.6509.248.camel@carll-linux-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-11-25 at 17:00 +0100, Arnd Bergmann wrote:
> On Tuesday 25 November 2008, Carl Love wrote:
> > This patch set consists of two kernel patches and one user level patch
> > to add SPU event based profiling support to OProfile for the IBM Cell
> > processor.  The first patch in the series is the user level patch that
> > adds the needed events and event checking to the user tool.  The second
> > patch is the first of two kernel patches.  It makes some structural
> > changes to the kernel code to make it easier to add the specific
> > functions for doing SPU event profiling.  The first kernel patch does
> > not make any functional changes.  The third patch in the series is the
> > second kernel patch where the actual SPU event profiling code support is
> > added to the kernel.
> 
> Thanks for your submission!
> 
> I can't comment on the oprofile user code, but I have some comments
> on the implementation in the third patch.
> 
> Are the patches interdependent, or will old versions of the oprofile
> tool work with new kernels and vice versa?
> 
> 	Arnd <><

There are two cases:1) new kernel code and old user tool. This works
fine, user is not able to do SPU events as the user code doesn't support
them.  Case 2) old kernel code and new user tool.  I realized that I
hadn't tested this case.  So, I just did.  What happens is the event
counters get setup for the SPU event but the kernel code treats it as if
it is a PPU event.  OProfile runs, you get a report for the PPU
processors listing the SPU event as the PPU event used.  Unfortunately,
the report is all garbage and not obvious to the naive user that it is
garbage.  Looks like we will need to put a check into the user code to
make sure it does not try to do SPU event profiling if the kernel
doesn't support it.  Argh!

              Carl Love
                                            

