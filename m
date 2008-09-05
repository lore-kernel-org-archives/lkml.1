Return-Path: <linux-kernel-owner+w=401wt.eu-S1754350AbYIEOSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350AbYIEOSk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 10:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753244AbYIEOSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 10:18:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:11759 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752909AbYIEOSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 10:18:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,320,1217833200"; 
   d="scan'208";a="436076589"
Message-ID: <48C13FB7.80105@linux.intel.com>
Date: Fri, 05 Sep 2008 16:18:31 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <andi@firstfloor.org>, Vivek Goyal <vgoyal@redhat.com>,
       Don Zickus <dzickus@redhat.com>, Prarit Bhargava <prarit@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       arozansk@redhat.com, Thomas.Mingarelli@hp.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH RFC] NMI Re-introduce un[set]_nmi_callback
References: <20080904130048.31841.3329.sendpatchset@prarit.bos.redhat.com> <1220535463.8609.223.camel@twins> <48BFF0C0.7060208@redhat.com> <20080904145617.GB28095@elte.hu> <87y727vrgu.fsf@basil.nowhere.org> <20080904172052.GN3400@redhat.com> <20080904175231.GH18288@one.firstfloor.org> <20080904182637.GP3400@redhat.com> <20080904190816.GB4349@redhat.com> <20080904200032.GM18288@one.firstfloor.org> <20080905093303.GA28887@elte.hu>
In-Reply-To: <20080905093303.GA28887@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
>>> Add "kdump" to the list. It will also be broken if we decide to let 
>>> one driver hijack the NMI handler.
>> kdump is a special case, similar to the NMI button panic mode. It 
>> should be always only active when the user configured it. When the 
>> user configured it should be always the fallback and override any 
>> other drivers.
> 
> if by 'any other drivers' you mean all other notifiers then that's wrong 
> - kdump must still come after many other NMI sources.

Your ordering makes sense. Someone just has to go through all
the users and fix them up I guess and also document it properly.

One thing to consider though: if there are more and more NMI drivers
it would make sense to have a new notifier chain just for this
(and also finally convert oprofile to use it too).

The problem with adding more and more into the die chain is that
die is executed on every exception, including quite performance
critical ones like page fault or int 3 (performance critical for
dprobes)

-Andi

