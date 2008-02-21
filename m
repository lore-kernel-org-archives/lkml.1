Return-Path: <linux-kernel-owner+w=401wt.eu-S935616AbYBUWyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935616AbYBUWyb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 17:54:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756082AbYBUWyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 17:54:00 -0500
Received: from el-out-1112.google.com ([209.85.162.181]:2466 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935477AbYBUWx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 17:53:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HZZMUJbs45Byu5rZSjx8m7//3BmmrmaYtu/55MGL51XYcj/Ldxlp7a70uNsP4bglRI6fR8G6x9N5LLHSxJTsoF4Yqqs7E0g4SCg56h7ua2a6rKU0mLgtJsyNmGs52m0Dxk8ctSKRgABsTPAHLFsI700bh94d4Da0S8th0idj6so=
Message-ID: <9810cff90802211453l3f62200ey52edfeb9d84d7@mail.gmail.com>
Date: Thu, 21 Feb 2008 14:53:56 -0800
From: "Bill Huey (hui)" <bill.huey@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH [RT] 00/14] RFC - adaptive real-time locks
Cc: "Gregory Haskins" <ghaskins@novell.com>, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, rostedt@goodmis.org, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org, kevin@hilman.org, cminyard@mvista.com,
       dsingleton@mvista.com, dwalker@mvista.com, npiggin@suse.de,
       dsaxena@plexity.net, ak@suse.de, gregkh@suse.de, sdietrich@novell.com,
       pmorreale@novell.com, mkohari@novell.com
In-Reply-To: <20080221214219.GA27209@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080221152504.4804.8724.stgit@novell1.haskins.net>
	 <20080221212420.GA20953@elte.hu>
	 <9810cff90802211333k3d19ca2exf28c18ae5a2b86a@mail.gmail.com>
	 <20080221214219.GA27209@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2008 at 1:42 PM, Ingo Molnar <mingo@elte.hu> wrote:
>  I'd not exclude them fundamentally though, it's really the numbers that
>  matter. The code is certainly simple enough (albeit the .config and
>  sysctl controls are quite ugly and unacceptable - adaptive mutexes
>  should really be ... adaptive, with no magic constants in .configs or
>  else).
>
>  But ... i'm somewhat sceptic, after having played with spin-a-bit
>  mutexes before.

Yeah, it's yet another reason to get better instrumentation in -rt for
this purpose and why it's important to only log things in the slow
path so that the front end of the rtmutex doesn't see instrumentation
artifacts in the measurement. If I get a chance tonight, I'll extend
lockdep/lockstat for this purpose if peterz doesn't beat me to it. I
won't have access to the test harness to replicate this though.

bill
