Return-Path: <linux-kernel-owner+w=401wt.eu-S1752988AbZBDCdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988AbZBDCdQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 21:33:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752419AbZBDCc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 21:32:56 -0500
Received: from a-sasl-quonix.sasl.smtp.pobox.com ([208.72.237.25]:34791 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754828AbZBDCcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 21:32:55 -0500
Date: Tue, 3 Feb 2009 20:32:36 -0600
From: Nathan Lynch <ntl@pobox.com>
To: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       "David S. Miller" <davem@davemloft.net>,
       Maynard Johnson <mpjohn@us.ibm.com>, carll@us.ibm.com
Subject: Re: Performance counter API review was [patch] Performance Counters
 for Linux, v3
Message-ID: <20090204023236.GH6913@localdomain>
References: <20081211155230.GA4230@elte.hu>
 <87r64ag68n.fsf@basil.nowhere.org> <49875199.3010609@linux.vnet.ibm.com>
 <1233606782.10184.4.camel@laptop>
 <18824.64228.358045.890823@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18824.64228.358045.890823@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Pobox-Relay-ID: 2014A7FC-F264-11DD-8F2D-6F7C8D1D4FD0-04752483!a-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mackerras wrote:
>
> By the way, how does userspace get to know about cpus being added or
> removed?  Is there a better way than continually reading
> /sys/devices/system/cpu/online?

The kernel generates uevents for cpu online and offline operations;
you can see them with udevmonitor.  Not sure how you get those events
to an arbitrary application, though.  Alternatively you can set an
inotify watch on e.g. /sys/devices/system/cpu/cpu1/online (at least it
seems to work here).
