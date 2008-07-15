Return-Path: <linux-kernel-owner+w=401wt.eu-S1761357AbYGOVBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761357AbYGOVBx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 17:01:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754306AbYGOVBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 17:01:45 -0400
Received: from rn-out-0910.google.com ([64.233.170.185]:59226 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbYGOVBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 17:01:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=cugYgZovv+7hTpq++ghVpk1cu2TzgSgAu0HsT7M2bySDhSqaLBXIBA4HXuChMSJuga
         l5qtaFzilKM0tNx8GgZkEt8isAVk3N/tZ6YVpRn5Pg6Jd+slMepvrN2zwC3NDU4h27cd
         Ytleo5QuJhtBaYoT8iHovKD/BNxQaJ4GWS7Vo=
Message-ID: <84144f020807151401s2e37b892q2df007c9e1e3464a@mail.gmail.com>
Date: Wed, 16 Jul 2008 00:01:42 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [git pull] RCU updates for v2.6.27
Cc: "Andrew Morton" <akpm@linux-foundation.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, paulmck@us.ibm.com,
       a.p.zijlstra@chello.nl, "Vegard Nossum" <vegard.nossum@gmail.com>
In-Reply-To: <alpine.LFD.1.10.0807151319360.2867@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080714152045.GA29159@elte.hu>
	 <alpine.LFD.1.10.0807151037060.3017@woody.linux-foundation.org>
	 <20080715131515.ebdc53d8.akpm@linux-foundation.org>
	 <alpine.LFD.1.10.0807151319360.2867@woody.linux-foundation.org>
X-Google-Sender-Auth: faa8b5b0670ab25e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Tue, 15 Jul 2008 10:38:27 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:
>>> Hmm. I really wanted to wait with kmemcheck, which is huge and I'm not
>>> entirely convinced yet.

On Tue, 15 Jul 2008, Andrew Morton wrote:
>> Any particular concerns?

On Tue, Jul 15, 2008 at 11:29 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> It's big, complex and looks fragile. And it reports lots of false
> positives, with big warnings to people to generally not use or make
> reports about itit unless they are already experts. So it looks like
> something pretty specific.
>
> I also want to feel like it actually has been helpful.

Besides catching reads to uninitialized memory, kmemcheck detects
use-after-free now and can be extended to catch red-zone overwrites
*as they happen* which will make debugging kernel memory corruptions
much easier for everybody.

There are now three commits in your tree that fix a real bug reported
by kmemcheck: 8410565f540db87ca938f56f92780d251e4f157d ("ACPICA: Fix
for access to deleted object <regression>"),
adeed48090fc370afa0db8d007748ee72a40b578 ("rc80211_pid: Fix fast_start
parameter handling"), and 62f75532b583c03840f31e40386ce2df73be9ca0
("slub: Initialize per-cpu stats").

So I think it has been helpful and that the infrastructure it adds is
valuable for future debugging aids.

                        Pekka
