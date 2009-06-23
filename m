Return-Path: <linux-kernel-owner+w=401wt.eu-S1754330AbZFWHkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330AbZFWHkc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 03:40:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751451AbZFWHkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 03:40:24 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:64256 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbZFWHkY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 03:40:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=a2ozr8XV8WA0mHoL0xSyzepaJMBAmlNDe/CN3hT8VmitbojTI7pCvGNekUHzkZVhR2
         gu+AbVjMQ4dT8AgRQXiW+zw/9mganYMF+zxmI8UmjsuscjV/TSPNSEQzv3l5X2QQuKeO
         JJWfwgGTkHZWrMmbajTzvTPj35A/1veedBN2E=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <19008.9265.758076.907649@cargo.ozlabs.ibm.com>
References: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>
	 <20090622115239.GF24366@elte.hu>
	 <7c86c4470906220525x409bedadj29be01236e42ea1@mail.gmail.com>
	 <1245674154.19816.228.camel@twins>
	 <19008.9265.758076.907649@cargo.ozlabs.ibm.com>
Date: Tue, 23 Jun 2009 09:40:25 +0200
Message-ID: <7c86c4470906230040x83b3c11j99e7c8016ac8e843@mail.gmail.com>
Subject: Re: I.5 - Mmaped count
From: stephane eranian <eranian@googlemail.com>
To: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Andi Kleen <andi@firstfloor.org>, Maynard Johnson <mpjohn@us.ibm.com>,
       Carl Love <cel@us.ibm.com>, Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul,

On Tue, Jun 23, 2009 at 2:39 AM, Paul Mackerras<paulus@samba.org> wrote:
>
> Hmmm, when the counter is running, what you want is not so much the
> total time so far as a way to compute the total time so far from the
> current TSC/timebase value.  So we would need to export tstamp_enabled
> and tstamp_running plus a scale/offset for converting the TSC/timebase
> value to nanoseconds consistent with ctx->time.  On powerpc that's
> pretty straightforward because the timebases, but on x86 I gather the
> offset and maybe also the scale would need to be per-cpu (which is OK,
> because all the values in the mmapped page are only useful on one
> specific CPU).
>
I think you should make it such that reading via mmap and read() are
equivalent, one is just lower overhead than the other. Otherwise it would
make it more difficult for tools in case of multiplexing where you could
fallback to read() and there you would not get the same information.


> How would we compute the scale and offset on x86, given the current
> TSC value and ctx->time?
>
> Paul.
>
