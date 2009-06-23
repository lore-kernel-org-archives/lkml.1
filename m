Return-Path: <linux-kernel-owner+w=401wt.eu-S1754822AbZFWIbG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbZFWIbG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 04:31:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751642AbZFWIax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 04:30:53 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:59215 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbZFWIaw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 04:30:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=q5iHE+aB7dXwn7ehIOOmkk9mJ5ThUaUS+RCncyj3C5DpuPsbCTj25FE5USGgcVmOMs
         Ert092ZrfLPt35xP5YkaABlwocIKGIRaQEmLOLN8eCHbVPhsXhHNp87TxWjTkttr5mY1
         H3e8LyXO1YvtViN+z0VRBFS9bhLrGUgx3+e8k=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <19008.37301.779108.964118@cargo.ozlabs.ibm.com>
References: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>
	 <20090622115017.GC24366@elte.hu>
	 <19008.25905.550815.222975@drongo.ozlabs.ibm.com>
	 <7c86c4470906230036o677e6c48j923a7431b9912372@mail.gmail.com>
	 <19008.37301.779108.964118@cargo.ozlabs.ibm.com>
Date: Tue, 23 Jun 2009 10:30:53 +0200
Message-ID: <7c86c4470906230130t69345d91w524d6d13216dc8db@mail.gmail.com>
Subject: Re: I.2 - Grouping
From: stephane eranian <eranian@googlemail.com>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andi Kleen <andi@firstfloor.org>, Maynard Johnson <mpjohn@us.ibm.com>,
       Carl Love <cel@us.ibm.com>, Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 10:26 AM, Paul Mackerras<paulus@samba.org> wrote:
> stephane eranian writes:
>
>> What happens if I do:
>>    fd0 = perf_counter_open(&hwc1, getpid(), -1, -1, 0);
>>    fd1 = perf_counter_open(&hwc2, getpid(), -1, fd0, 0);
>>
>> And then:
>>    fd2 = perf_counter_open(&hwc2, getpid(), -1, fd1, 0);
>
> That perf_counter_open call will fail with an EINVAL error because fd1
> is not a group leader.
>
Okay. Thanks.

But that leads me to another question related to grouping
which was hinted for by Peter's comment about IBS.

Can you have multiple sampling events in a group?
