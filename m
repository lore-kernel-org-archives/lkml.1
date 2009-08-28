Return-Path: <linux-kernel-owner+w=401wt.eu-S1751237AbZH1B3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751237AbZH1B3m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 21:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751085AbZH1B3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 21:29:40 -0400
Received: from smtp.knology.net ([24.214.63.101]:34824 "EHLO smtp.knology.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838AbZH1B3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 21:29:40 -0400
Subject: Re: [PATCH] r8169: Reduce looping in the interrupt handler.
From: David Dillow <dave@thedillows.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Francois Romieu <romieu@fr.zoreil.com>,
       Michael Riepe <michael.riepe@googlemail.com>,
       Michael Buesch <mb@bu3sch.de>, Rui Santos <rsantos@grupopie.com>,
       Michael B??ker <m.bueker@berlin.de>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
In-Reply-To: <m1d46gka9e.fsf@fess.ebiederm.org>
References: <m1k50r8u4p.fsf@fess.ebiederm.org>
	 <20090825221903.GA13630@electric-eye.fr.zoreil.com>
	 <m1iqgbknun.fsf_-_@fess.ebiederm.org>
	 <1251294974.14241.9.camel@obelisk.thedillows.org>
	 <1251295175.14241.11.camel@obelisk.thedillows.org>
	 <m11vmy737x.fsf@fess.ebiederm.org>
	 <20090826213024.GA20428@electric-eye.fr.zoreil.com>
	 <m1hbvu45jq.fsf@fess.ebiederm.org>
	 <20090827052423.GA1709@electric-eye.fr.zoreil.com>
	 <m1ocq1ke9u.fsf@fess.ebiederm.org>
	 <20090827232024.GA30119@electric-eye.fr.zoreil.com>
	 <m1d46gka9e.fsf@fess.ebiederm.org>
Content-Type: text/plain
Date: Thu, 27 Aug 2009 21:29:38 -0400
Message-Id: <1251422978.21865.2.camel@obelisk.thedillows.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-27 at 18:17 -0700, Eric W. Biederman wrote:
> Francois Romieu <romieu@fr.zoreil.com> writes:
> 
> > Eric W. Biederman <ebiederm@xmission.com> :
> > [...]
> >> Sounds good.
> >
> > Gah, I was not able to test it with a decent packet load. Patch below against
> > the current tree:
> 
> This kills the loop which was my concern.
> 
> I will double check it works on my configuration.
> Then we have the question of does it work for those folks who have cards
> where the msi appeared to get lost.
> 
> David any chance you can test this patch?

It'll be this weekend, but I can see cases where it can lock my chip up
-- they should be rare, but then I thought your case would be extremely
rare...

I think we'll need to go to a full separation between MSI and
level-triggered interrupt handlers, or at the very least mask everything
and handle it all in NAPI. That seems more viable now that I know
Francois is not terribly worried about diverging from the vendor driver
there.

