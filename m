Return-Path: <linux-kernel-owner+w=401wt.eu-S1756194AbZDURXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194AbZDURXs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 13:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751941AbZDURXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 13:23:38 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:5507 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbZDURXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 13:23:38 -0400
X-IronPort-AV: E=Sophos;i="4.40,225,1238976000"; 
   d="scan'208";a="155389218"
From: Roland Dreier <rdreier@cisco.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Hitoshi Mitake <h.mitake@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: arch/x86/Kconfig selects invalid HAVE_READQ, HAVE_WRITEQ vars
References: <alpine.LFD.2.00.0904191543530.11789@localhost.localdomain>
	<adaab6c1h7c.fsf@cisco.com> <20090419214602.GA21527@elte.hu>
	<adaws9gywkd.fsf@cisco.com> <49EBCDC0.1020001@zytor.com>
	<20090420105304.GC6670@elte.hu>
	<a6b9f31a0904200747x7e28a4e3if0be4fc0d87241c9@mail.gmail.com>
	<20090420160332.GB9689@elte.hu>
	<a6b9f31a0904210133m29e68580w1fb7a8e6159b65d6@mail.gmail.com>
	<49EDE9E9.8090905@zytor.com> <adamyaavst5.fsf@cisco.com>
	<49EE0013.6010008@zytor.com>
X-Message-Flag: Warning: May contain useful information
Date: Tue, 21 Apr 2009 10:23:34 -0700
In-Reply-To: <49EE0013.6010008@zytor.com> (H. Peter Anvin's message of "Tue,
	21 Apr 2009 10:19:15 -0700")
Message-ID: <adaab69x6nd.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 21 Apr 2009 17:23:36.0431 (UTC) FILETIME=[E764DFF0:01C9C2A5]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > > However I worry that this just leaves driver authors too much rope.
 > > Choosing readq_atomic() vs. readq() is just one more thing to get wrong.

 > ... as is having each driver implementing their own substitutes.

Yes, I agree with that.  However at least status quo ante (readq/writeq
64-bit only) means that driver authors who use readq/writeq are forced
(by a compile error) to spend a little thought on what 32-bit fallback
they should use.

I guess one possibility is to make readq/writeq the atomic version, and
add readq_nonatomic()/writeq_nonatomic() for 32-bit architectures.  Then
it's much more opt-in -- but then that makes the (perhaps) more common
case look a bit uglier.

 - R.
