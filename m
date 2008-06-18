Return-Path: <linux-kernel-owner+w=401wt.eu-S1755997AbYFRRSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbYFRRSa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 13:18:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbYFRRSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 13:18:22 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:47892 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752514AbYFRRSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 13:18:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Zqn1mgFxAtNqSBjfua6gy6dDK2509LQfNYBAgl7H5aQfNcEdx7RgXrKIcQ1YpE70hG2I8TX4Thu2xnoNXKv+UGcp/QiSRyYRD0Yl3RuT6s5tBXxBV9OBqit/SC6PHNzkyHx94ik0Ae7f6xR6tojWNZ3bH+dnXZXAwfjO0YrhfiQ=  ;
X-YMail-OSG: JiwovwkVM1l_bj2_8nFP5MO__w31e3MIltUoamd43fOXEA7U7B_ejWWSwdfsE6tLBg1poC5Qk8gYFo2vf97Q8EpsedA1O3emvVrJXy7mwQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH][resubmit] x86: enable preemption in delay
Date: Thu, 19 Jun 2008 03:18:07 +1000
User-Agent: KMail/1.9.5
Cc: Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi-suse@firstfloor.org>,
       Clark Williams <clark.williams@gmail.com>,
       Marin Mitov <mitov@issp.bas.bg>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>, akpm@osdl.org,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>
References: <200805252108.25011.mitov@issp.bas.bg> <200806182242.49245.nickpiggin@yahoo.com.au> <Pine.LNX.4.58.0806181215120.29622@gandalf.stny.rr.com>
In-Reply-To: <Pine.LNX.4.58.0806181215120.29622@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806190318.07684.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 June 2008 02:16, Steven Rostedt wrote:
> On Wed, 18 Jun 2008, Nick Piggin wrote:
> > There are _some_ cases where it can be used, but nobody has been
> > able to come up with compelling uses really. I don't think this
> > case is helped very much either because the logic in there using
> > preempt-disable is fine, isn't it?
> >
> > Except that it should also have a cond_resched in it. Seems like
> > an ideal place to put cond_resched because it is not a fastpath.
>
> Does it really need a cond_resched? preempt_enable when it goes to zero
> will already check to see if it should schedule.

It doesn't really need one, but of course having one would help
non preempt kernels.
