Return-Path: <linux-kernel-owner+w=401wt.eu-S1753194AbZHZUDH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbZHZUDH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 16:03:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753166AbZHZUDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 16:03:07 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:38158 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbZHZUDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 16:03:05 -0400
To: David Dillow <dave@thedillows.org>
Cc: Francois Romieu <romieu@fr.zoreil.com>,
       Michael Riepe <michael.riepe@googlemail.com>,
       Michael Buesch <mb@bu3sch.de>, Rui Santos <rsantos@grupopie.com>,
       Michael B??ker <m.bueker@berlin.de>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] r8169: Reduce looping in the interrupt handler.
References: <1250895567.23419.1.camel@obelisk.thedillows.org>
	<1250897657.23419.5.camel@obelisk.thedillows.org>
	<m1iqggf4rf.fsf@fess.ebiederm.org> <m18whcf3w2.fsf@fess.ebiederm.org>
	<1250973787.3582.14.camel@obelisk.thedillows.org>
	<m1r5v0ogvw.fsf@fess.ebiederm.org>
	<1251169150.4023.11.camel@obelisk.thedillows.org>
	<m1prajabk8.fsf@fess.ebiederm.org>
	<1251232848.9607.15.camel@lap75545.ornl.gov>
	<m1k50r8u4p.fsf@fess.ebiederm.org>
	<20090825221903.GA13630@electric-eye.fr.zoreil.com>
	<m1iqgbknun.fsf_-_@fess.ebiederm.org>
	<1251294974.14241.9.camel@obelisk.thedillows.org>
	<1251295175.14241.11.camel@obelisk.thedillows.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 26 Aug 2009 13:02:58 -0700
In-Reply-To: <1251295175.14241.11.camel@obelisk.thedillows.org> (David Dillow's message of "Wed\, 26 Aug 2009 09\:59\:35 -0400")
Message-ID: <m11vmy737x.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: dave@thedillows.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, m.bueker@berlin.de, rsantos@grupopie.com, mb@bu3sch.de, michael.riepe@googlemail.com, romieu@fr.zoreil.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Dillow <dave@thedillows.org> writes:

> On Wed, 2009-08-26 at 09:56 -0400, David Dillow wrote:
>> On Wed, 2009-08-26 at 00:58 -0700, Eric W. Biederman wrote:
>> > diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
>> > index 3b19e0c..2214945 100644
>> > --- a/drivers/net/r8169.c
>> > +++ b/drivers/net/r8169.c
>> 
>> > +
>> > +		/* Ignore the parts of status that reflect more than
>> > +		 * the enabled interrupts.
>> > +		 */
>> > +		smp_rmb();
>> > +		if (!(status & tp->intr_mask & tp->intr_event))
>> > +			break;
>> >  	}
>> 
>> This looks like an odd construct, since we're just about to go back the
>> while condition up top -- why not just mask it here and let the loop
>> handle it naturally?
>
> Never mind, I see what you are doing -- avoiding a false loop if we get
> status == 0xffff. I still don't like the aesthetics of it, but it makes
> sense, and I'll blame it on the card. :)
>
> I should really get some caffeine before posting...  

It is a bit weird but it also means we aren't playing silly games
with status inside the loop.  So if we go through the loop we ack
everything in status.

Eric

