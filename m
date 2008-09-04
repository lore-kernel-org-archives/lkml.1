Return-Path: <linux-kernel-owner+w=401wt.eu-S1756047AbYIDT53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047AbYIDT53 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 15:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754123AbYIDT5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 15:57:19 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33195 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107AbYIDT5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 15:57:18 -0400
Date: Thu, 4 Sep 2008 22:00:32 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Don Zickus <dzickus@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@elte.hu>, Prarit Bhargava <prarit@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       arozansk@redhat.com, Thomas.Mingarelli@hp.com, ak@linux.intel.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH RFC] NMI Re-introduce un[set]_nmi_callback
Message-ID: <20080904200032.GM18288@one.firstfloor.org>
References: <20080904130048.31841.3329.sendpatchset@prarit.bos.redhat.com> <1220535463.8609.223.camel@twins> <48BFF0C0.7060208@redhat.com> <20080904145617.GB28095@elte.hu> <87y727vrgu.fsf@basil.nowhere.org> <20080904172052.GN3400@redhat.com> <20080904175231.GH18288@one.firstfloor.org> <20080904182637.GP3400@redhat.com> <20080904190816.GB4349@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080904190816.GB4349@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Add "kdump" to the list. It will also be broken if we decide to let one
> driver hijack the NMI handler.

kdump is a special case, similar to the NMI button panic mode. It should 
be always only active when the user configured it. When the user configured
it should be always the fallback and override any other drivers.

But watchdog is a special case. I assume the watchdog will just log
(and do the work that a SMI should be doing) but then continue 
the chain so that kdump can dump on a watchdog timeout.

-Andi
