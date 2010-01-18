Return-Path: <linux-kernel-owner+w=401wt.eu-S1753951Ab0ARLEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab0ARLEO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 06:04:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751620Ab0ARLEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 06:04:14 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:35832 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469Ab0ARLEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 06:04:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=i0nHQy7F8Y/MZ+5KmL0xycMiShk5009Z2TijwfOAoQHBHd4QMSDC/mzJRmRj5bHpRt
         b4XQhMn55kbJ3I4bHupp8vDk/ekyKPLkpDPMwv05ydLtqcbVkCvOIzt8xxX8+9QBdqKT
         SdazB2Xl9TYEIO2Il+gZKq/rXdlF6h0tu7Ef4=
Date: Mon, 18 Jan 2010 12:04:07 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Joshua Pincus <joshua.pincus@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       peterz@infradead.org, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: HW breakpoints perf_events request
Message-ID: <20100118110406.GC5256@nowhere>
References: <bc915a051001131745m6fb70dcbx29b9d35f6fd7106c@mail.gmail.com> <87ljg1fn3u.fsf@basil.nowhere.org> <bc915a051001131821x6cdd3470lf72e8c02a897ea3@mail.gmail.com> <20100114092350.GF12241@basil.fritz.box> <bc915a051001141003s766689beue73800a1308d957e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bc915a051001141003s766689beue73800a1308d957e@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 14, 2010 at 10:03:27AM -0800, Joshua Pincus wrote:
> Hi,
> 
> On Thu, Jan 14, 2010 at 1:23 AM, Andi Kleen <andi@firstfloor.org> wrote:
> >> We would like to avoid using ptrace at all costs.
> >> It requires us to have a parent thread running
> >> which monitors all the others.  It's not clear that
> >> the wait() call by the parent doesn't mask a barrage
> >> of signals from various threads and the performance
> >
> > mask? It'll report them. You expect to have so
> > many signals that this would be a problem?
> 
> Yes.  We expect to see a zillion of them.


I don't quite understand what signals are masked here,
actually I'm not sure what is the true problem with ptrace.
Is it because a breakpoint in a thread is going to stop
all thread in the process until the parent handles the
signal?

Anyway, although I first suggested extending perf, with
more thoughts I now agree that perf should keep doing what
it does currently (profiling) and not trying to become an
messy mix of a profiler, debugger, etc...
This is not its role.

But it can certainly be used by a debugging facility.

What about extending ptrace to support a new type of
breakpoint debugging interface?

