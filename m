Return-Path: <linux-kernel-owner+w=401wt.eu-S1754649AbZBXHvy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbZBXHvy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 02:51:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751664AbZBXHvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 02:51:46 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:39388 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307AbZBXHvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 02:51:45 -0500
Subject: Re: Banning checkpoint (was: Re: What can OpenVZ do?)
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Nathan Lynch <nathanl@austin.ibm.com>,
       linux-api@vger.kernel.org, containers@lists.linux-foundation.org,
       mpm@selenic.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       viro@zeniv.linux.org.uk, hpa@zytor.com,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, tglx@linutronix.de, xemul@openvz.org
In-Reply-To: <20090224044752.GB3202@x200.localdomain>
References: <20090217222319.GA10546@elte.hu>
	 <1234909849.4816.9.camel@nimitz> <20090218003217.GB25856@elte.hu>
	 <1234917639.4816.12.camel@nimitz> <20090218051123.GA9367@x200.localdomain>
	 <20090218181644.GD19995@elte.hu> <1234992447.26788.12.camel@nimitz>
	 <20090218231545.GA17524@elte.hu> <20090219190637.GA4846@x200.localdomain>
	 <1235070714.26788.56.camel@nimitz> <20090224044752.GB3202@x200.localdomain>
Content-Type: text/plain
Date: Mon, 23 Feb 2009 21:11:25 -0800
Message-Id: <1235452285.26788.226.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-24 at 07:47 +0300, Alexey Dobriyan wrote:
> > I think what I posted is a decent compromise.  It gets you those
> > warnings at runtime and is a one-way trip for any given process.  But,
> > it does detect in certain cases (fork() and unshare(FILES)) when it is
> > safe to make the trip back to the "I'm checkpointable" state again.
> 
> "Checkpointable" is not even per-process property.
> 
> Imagine, set of SAs (struct xfrm_state) and SPDs (struct xfrm_policy).
> They are a) per-netns, b) persistent.
> 
> You can hook into socketcalls to mark process as uncheckpointable,
> but since SAs and SPDs are persistent, original process already exited.
> You're going to walk every process with same netns as SA adder and mark
> it as uncheckpointable. Definitely doable, but ugly, isn't it?
> 
> Same for iptable rules.
> 
> "Checkpointable" is container property, OK?

Ideally, I completely agree.

But, we don't currently have a concept of a true container in the
kernel.  Do you have any suggestions for any current objects that we
could use in its place for a while?

-- Dave

