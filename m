Return-Path: <linux-kernel-owner+w=401wt.eu-S1755658AbZLWKSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658AbZLWKSx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 05:18:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754695AbZLWKSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 05:18:52 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38066 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753157AbZLWKSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 05:18:51 -0500
Date: Wed, 23 Dec 2009 02:18:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Smith, GeoffX" <geoffx.smith@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Michael Stone <michael@laptop.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] prctl: return MCE process flags through pointer
Message-Id: <20091223021807.abbd993e.akpm@linux-foundation.org>
In-Reply-To: <20091223095223.GB20539@basil.fritz.box>
References: <354B2877CF17F44BB3FA44EB4DB0E5470C91CE1829@orsmsx510.amr.corp.intel.com>
	<87hbricwz8.fsf@basil.nowhere.org>
	<20091222173424.980d5d33.akpm@linux-foundation.org>
	<20091223095223.GB20539@basil.fritz.box>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Dec 2009 10:52:23 +0100 Andi Kleen <andi@firstfloor.org> wrote:

> On Tue, Dec 22, 2009 at 05:34:24PM -0800, Andrew Morton wrote:
> > On Wed, 23 Dec 2009 02:14:51 +0100 Andi Kleen <andi@firstfloor.org> wrote:
> > 
> > > "Smith, GeoffX" <geoffx.smith@intel.com> writes:
> > > 
> > > > This patch fixes the semantics of prctl() option PR_MCE_KILL_GET 
> > > > to pass the return value through *arg2.
> > > >
> > > > With this change, the option now follows the same conventions as the
> > > > other "get" options added since 2.6.0, and also brings it into
> > > > conformance with the advice in chapter 16 of Documentation/CodingStyle.
> > > >
> > > > This prctl() option was only added within the last month, so there are
> > > > not any production applications to break.  This patch applies cleanly
> > > > to mainline and to 2.6.32.2 for backporting.
> > > 
> > > It breaks the test suite, the man pages, qemu and one slide deck at least.
> > > 
> > 
> > Should've got it right the first time.
> 
> To be honest it's not fully clear to me what is "wrong" with returning
> the return value with "return".

Just a convention thing.

> If there was a security bug or something maybe such a radical step
> as changing a published API would be justified, but for this I'm sceptical.

hm, OK, shrug.

Regarding "prctl: return timerslack through pointer": are there any
known users of PR_GET_TIMERSLACK yet?

Why are task_struct.timer_slack_ns and
task_struct.default_timer_slack_ns unsigned long, btw?  AFACIT we could
make them unsigned ints.

