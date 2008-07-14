Return-Path: <linux-kernel-owner+w=401wt.eu-S1755655AbYGNFF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655AbYGNFF1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 01:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752039AbYGNFFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 01:05:19 -0400
Received: from smtp111.mail.mud.yahoo.com ([209.191.84.64]:35775 "HELO
	smtp111.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751692AbYGNFFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 01:05:19 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=nIQ6EFNeklnhmLbSqtGUvZW87Rfsg1J1zEtCxYmBja7vTJqup04rNzIZuaG4OAkhO9ECgnD2CG/UORn+PLW+J1GWiZEH9JlHtNZdiA4WW9guUq9PypFsNQvAzbeCcr1jC70GfkWZnMM3S4Rf766Mjg0V059tosHLUOqLmyuMKcU=  ;
X-YMail-OSG: MNO53RwVM1l5yzxsXq5U2L5CtOtlwECf.C2M5dn6VDrj9vMa__qsvBQ4VX3HT18Z0ZCXv1qU3Pgw._IOr9.Ky6tMknUFSbq1Pt1ce8Zzvok216frnopnl9khT6pdLT.kUkU-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: Performance Question: BUG_ON vs. WARN_ON_ONCE
Date: Mon, 14 Jul 2008 15:05:08 +1000
User-Agent: KMail/1.9.5
Cc: "Ryan Hope" <rmh3093@gmail.com>, LKML <linux-kernel@vger.kernel.org>
References: <48f7fe350807131657v4b95340ajfaaacbb04eefa21f@mail.gmail.com> <48f7fe350807132110k4cd90e9j6907674ea7668f5b@mail.gmail.com> <20080714073636.6c84be12@linux360.ro>
In-Reply-To: <20080714073636.6c84be12@linux360.ro>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807141505.08663.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 July 2008 14:36, Eduard - Gabriel Munteanu wrote:
> On Mon, 14 Jul 2008 00:10:50 -0400
>
> "Ryan Hope" <rmh3093@gmail.com> wrote:
> > well the bug I recieved looked like it had to do with highmem and this
> > was the only code relating to mem that got touched, as for the other
> > person, their crash was reproducible and it definitely was an oops,
> > numlock led started to blink and system was unresponsive, for both of
> > us
> > reverting this change seems fix the issue, my dmesg log is attached to
> > this message
>
> There are a few things you should take into account before anything else:
> 1. The bug does not occur there, but in other code.
> 2. The kernel is tainted.
> 3. The oopses start occuring just after you load that tainted module,
> or at least something related (that drm stuff is linked to the radeon
> module, I presume, which is proprietary AFAIK)
>
> So you should retest after eliminating all these possible noise and
> error sources. Test both if your fix (revert) is correct and if it
> crashes without your fix.
>
> My guess is that would've happened sooner or later and your fix just
> moved stuff around enough to mask it. That static int from WARN_ON_ONCE
> means another 4 or 8 bytes in the kernel image, which might set things
> off in an already unstable environment.

Yeah, it looks like most or all of the errors cascade down from
the first one where a page gets freed while it is still in use and
mapped into page tables.

I'd say it is the driver mishandling the pages perhaps in its fault
function or the returned pages from a get_user_pages.

Probably best off reporting it to the drm driver authors first.
