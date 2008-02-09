Return-Path: <linux-kernel-owner+w=401wt.eu-S1756503AbYBIQvF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503AbYBIQvF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 11:51:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754029AbYBIQuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 11:50:54 -0500
Received: from tranquility.mcc.ac.uk ([130.88.200.145]:64231 "EHLO
	tranquility.mcc.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011AbYBIQux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 11:50:53 -0500
Message-ID: <47ADD9E9.8090908@gentoo.org>
Date: Sat, 09 Feb 2008 16:50:49 +0000
From: Daniel Drake <dsd@gentoo.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071117)
MIME-Version: 1.0
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Richard Henderson <rth@twiddle.net>, tony.luck@intel.com,
       anton@samba.org, paulus@samba.org, Adrian Bunk <bunk@kernel.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, rusty@rustcorp.com.au,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] moduleparam: fix alpha, ia64 and ppc64 compile failures
References: <20080208223341.GB15333@jurassic.park.msu.ru>
In-Reply-To: <20080208223341.GB15333@jurassic.park.msu.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-UoM: Scanned by the University Mail System. See http://www.itservices.manchester.ac.uk/email/filtering/information/ for details.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ivan Kokshaysky wrote:
> On alpha, ia64 and ppc64 only relocations to local data can go into
> read-only sections. The vast majority of module parameters use the global
> generic param_set_*/param_get_* functions, so the 'const' attribute for
> struct kernel_param is not only useless, but it also causes compile
> failures due to 'section type conflict' in those rare cases where
> param_set/get are local functions.
> 
> This fixes http://bugzilla.kernel.org/show_bug.cgi?id=8964

In case you weren't aware already, people seem to think this is actually 
a GCC bug (with a patch available):

http://gcc.gnu.org/bugzilla/show_bug.cgi?id=31490

Daniel

