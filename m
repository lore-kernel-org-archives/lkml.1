Return-Path: <linux-kernel-owner+w=401wt.eu-S932308AbZKSBjJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308AbZKSBjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 20:39:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932279AbZKSBjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 20:39:08 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:57124 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932193AbZKSBjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 20:39:07 -0500
Date: Wed, 18 Nov 2009 17:39:11 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jason Baron <jbaron@redhat.com>, mingo@elte.hu, mhiramat@redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, tglx@linutronix.de,
       andi@firstfloor.org, roland@redhat.com, rth@redhat.com
Subject: Re: [RFC PATCH 2/6] jump label v3 - x86: Introduce generic jump
	patching without stop_machine
Message-ID: <20091119013911.GG6683@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <cover.1258580048.git.jbaron@redhat.com> <37e397b27509c378f93b9a30f1158791d1b99be7.1258580048.git.jbaron@redhat.com> <20091119002826.GB28962@Krystal> <20091119005829.GF6683@linux.vnet.ibm.com> <1258593767.22249.486.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258593767.22249.486.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 08:22:47PM -0500, Steven Rostedt wrote:
> On Wed, 2009-11-18 at 16:58 -0800, Paul E. McKenney wrote:
> 
> > I do invoke smp_send_reschedule() with irqs disabled, which did arouse my
> > suspicions of late.  But this seems to bypass the smp_call_function()
> > code that is most definitely illegal to invoke with irqs disabled,
> > so no smoking gun.  All that aside, if invoking smp_send_reschedule()
> > with irqs disabled is in any way a bad idea, please let me know so I
> > can rearrange the code appropriately.
> 
> I don't think you have anything to worry about here. If calling
> smp_send_reschedule was bad with keeping interrupts disabled, then we
> would have a lot of problems with the scheduler. That is called with the
> rq lock held and with interrupts disabled.

Whew!!!  ;-)

							Thanx, Paul
