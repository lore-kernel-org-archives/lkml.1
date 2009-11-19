Return-Path: <linux-kernel-owner+w=401wt.eu-S932223AbZKSBWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223AbZKSBWo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 20:22:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932137AbZKSBWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 20:22:44 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:56461 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932126AbZKSBWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 20:22:43 -0500
Subject: Re: [RFC PATCH 2/6] jump label v3 - x86: Introduce generic jump
 patching without stop_machine
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: paulmck@linux.vnet.ibm.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jason Baron <jbaron@redhat.com>, mingo@elte.hu, mhiramat@redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, tglx@linutronix.de,
       andi@firstfloor.org, roland@redhat.com, rth@redhat.com
In-Reply-To: <20091119005829.GF6683@linux.vnet.ibm.com>
References: <cover.1258580048.git.jbaron@redhat.com>
	 <37e397b27509c378f93b9a30f1158791d1b99be7.1258580048.git.jbaron@redhat.com>
	 <20091119002826.GB28962@Krystal> <20091119005829.GF6683@linux.vnet.ibm.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 18 Nov 2009 20:22:47 -0500
Message-Id: <1258593767.22249.486.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-18 at 16:58 -0800, Paul E. McKenney wrote:

> I do invoke smp_send_reschedule() with irqs disabled, which did arouse my
> suspicions of late.  But this seems to bypass the smp_call_function()
> code that is most definitely illegal to invoke with irqs disabled,
> so no smoking gun.  All that aside, if invoking smp_send_reschedule()
> with irqs disabled is in any way a bad idea, please let me know so I
> can rearrange the code appropriately.

I don't think you have anything to worry about here. If calling
smp_send_reschedule was bad with keeping interrupts disabled, then we
would have a lot of problems with the scheduler. That is called with the
rq lock held and with interrupts disabled.

-- Steve


