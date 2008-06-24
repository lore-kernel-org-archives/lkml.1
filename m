Return-Path: <linux-kernel-owner+w=401wt.eu-S1755650AbYFXJ1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650AbYFXJ1o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 05:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750887AbYFXJ1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 05:27:35 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:36101 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbYFXJ1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 05:27:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=vf3GFy871QAyLGwaOlXrN66efRk6oOMXV9IwWC0LbjYmQdbfKMktFIEHgxy0T5lR+5
         Kq/cbKnFWX0WafyQdkwWGVZWnAnq+xL3VR5w9z6hZ9a7ORSp6eCNHWQY2mQxPIElYQNB
         yKxWQynPeE7Tkca2/vuQwUxlrR/ENNFKOgDfQ=
Message-ID: <e2e108260806240227s659fb238t3a105f095773095a@mail.gmail.com>
Date: Tue, 24 Jun 2008 11:27:33 +0200
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Subject: Re: nanosleep() uses CLOCK_MONOTONIC, should be CLOCK_REALTIME?
Cc: "Roman Zippel" <zippel@linux-m68k.org>,
       "Michael Kerrisk" <mtk.manpages@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "john stultz" <johnstul@us.ibm.com>, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <cfd18e0f0806240127y105d759aye6b60715e74b823@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <485E00CD.9060503@gmail.com>
	 <e2e108260806230134g48f5ac63mb93256e08c57b4f7@mail.gmail.com>
	 <cfd18e0f0806230248g3a2ab795s63de2b96538ebdd0@mail.gmail.com>
	 <Pine.LNX.4.64.0806231438130.6791@localhost.localdomain>
	 <cfd18e0f0806232239w78546747p8fb899f614c89496@mail.gmail.com>
	 <e2e108260806240101u30f85da8w7404e52f189f8d9@mail.gmail.com>
	 <cfd18e0f0806240127y105d759aye6b60715e74b823@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> nor by adjtimex() (this last one is used by ntpd).
>
> That surprised me a little.  So gradual adjustments to the time made
> by adjtime() / adjtimex() really don't affect nanosleep()?

Does the adjtime() system call still exist ? I could not find any
information about this system call in the 2.6.25 kernel source code.

Frequency adjustments made via the adjtimex() system call do affect
nanosleep() of course (via timex::freq and/or timex::tick). Stepwise
time adjustments, whether gradual or not, should not affect
nanosleep().

Bart.
