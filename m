Return-Path: <linux-kernel-owner+w=401wt.eu-S1754323AbYANJ51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323AbYANJ51 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 04:57:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755556AbYANJ5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 04:57:17 -0500
Received: from ns.firmix.at ([62.141.48.66]:3886 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755249AbYANJ5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 04:57:14 -0500
Subject: Re: The ext3 way of journalling
From: Bernd Petrovitsch <bernd@firmix.at>
To: Tuomo Valkonen <tuomov@iki.fi>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <slrnfombug.lco.tuomov@jolt.modeemi.cs.tut.fi>
References: <18307.42821.166376.732473@stoffel.org>
	 <slrnfo7auq.6m2.tuomov@jolt.modeemi.cs.tut.fi>
	 <871w8r6ruc.fsf@barad-dur.regala.cx>
	 <slrnfo9lqk.17l.tuomov@jolt.modeemi.cs.tut.fi>
	 <20080110131659.GF10230@mit.edu>
	 <20080110134111.GA6254@jolt.modeemi.cs.tut.fi>
	 <20080112150621.GC6751@mit.edu>
	 <20080113221301.GA18341@jolt.modeemi.cs.tut.fi>
	 <20080113222310.GA20815@jolt.modeemi.cs.tut.fi>
	 <20080113231150.GB23906@mit.edu>
	 <20080114071555.GA6475@jolt.modeemi.cs.tut.fi>
	 <1200303743.24517.6.camel@tara.firmix.at>
	 <slrnfombug.lco.tuomov@jolt.modeemi.cs.tut.fi>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Mon, 14 Jan 2008 10:57:09 +0100
Message-Id: <1200304629.24517.15.camel@tara.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.334 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.334 required=5
X-Spam-Score: -2.334 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-01-14 at 09:48 +0000, Tuomo Valkonen wrote:
> On 2008-01-14, Bernd Petrovitsch <bernd@firmix.at> wrote:
> > Yes, that is a usual bug/problem in common distributions[0] as there is
> > no real guarantee that your clock is not far off.
> 
> It isn't, right after boot. But while the system is on, it sometimes
> starts advancing very fast, 15min a day or so. To my knowledge, the
> time the CMOS clock is not used then, but rather the kernel tracks the

ACK.

> time based on scheduler interrupts, with ntpd occasionally correcting.
> However, ntpd refuses to correct when the time has drifted too much, 
> causing even further drift.

That shouldn't happen.

> > That the reason to activate `ntpdate` unconditionally: It sets the
> > current time to an (somewhat) accurate value and `ntpd` handles the
> > rest.
> 
> Nope, as explained above. ntpdate at boot wouldn't help much, because
> the time is (approximately) correct after boot. It only drifts after it.

Aha. That's also strange. `ntpd` is able to (and always does AFAIK)
modify the speed of the clock (to keep it synchronized) so that the
error is usually much smaller than 1 second - also if you are behind
high-jitter links and/or an a high stratum.
That leads to the question why the clock starts to run like crazy at
some time so that `ntpd` can't cope with it.
Playing with `ntpd` parameters (e.g. increasing ) doesn't help I assume.

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


