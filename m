Return-Path: <linux-kernel-owner+w=401wt.eu-S1754561AbZERNRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561AbZERNRX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 09:17:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752548AbZERNRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 09:17:10 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:39695 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbZERNRJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 09:17:09 -0400
Message-Id: <4A117BF10200007800001565@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Mon, 18 May 2009 14:17:05 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "the arch/x86 maintainers" <x86@kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Xen-devel" <xen-devel@lists.xensource.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [Xen-devel] Re: [GIT PULL] xen /proc/mtrr implementation
References: <1242170864-13560-1-git-send-email-jeremy@goop.org>
 <20090513133021.GA7277@elte.hu> <4A0ADBA2.2020300@goop.org>
 <20090515182757.GA19256@elte.hu> <4A0DCC11.10307@goop.org>
 <m1my9ex818.fsf@fess.ebiederm.org> <4A0DFF78.6000501@goop.org>
 <20090515202250.0f1218ef@jbarnes-g45> <m1iqk1k708.fsf@fess.ebiederm.org>
 <4A10EAC4.9070701@goop.org> <20090518085902.GE10687@elte.hu>
In-Reply-To: <20090518085902.GE10687@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Ingo Molnar <mingo@elte.hu> 18.05.09 10:59 >>>
>Here Xen invades an already fragile piece of upstream code 
>(/proc/mtrr) that is obsolete and on the way out. If you want a 
>solution you should add PAT support to Xen and you should use recent 

As Jeremy pointed out a number of times, Xen *does* have PAT support,
perhaps (that's my personal opinion) even superior to the Linux one, as
it doesn't redefine the 486-inherited caching mode attributes but rather
uses the full 3 bits that the hardware provides (and, as an
acknowledgement to the various hardware bugs, makes sure not to use
any large page mappings when using non-WB mappings).

>upstream kernels. Or you should emulate /proc/mtrr in _Xen the 
>hypervisor_, if you really care that much - without increasing the 
>amount of crap in Linux.

As Jeremy also pointed out previously, emulating the MTRRs in the
hypervisor is very undesirable (and technically at least very close to
impossible), as we're talking about the *real* MTTRs that need managing
here (whereas dealing with virtualized MTRRs in a fully virtualized guest
is a completely different - and very reasonable - thing).

I can only support Jeremy in asking that you please reconsider your NAK.

Jan

