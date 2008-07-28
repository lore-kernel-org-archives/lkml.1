Return-Path: <linux-kernel-owner+w=401wt.eu-S1757526AbYG1WFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526AbYG1WFr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 18:05:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751858AbYG1WFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 18:05:39 -0400
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:48790 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751375AbYG1WFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 18:05:39 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Ctf65kSCZc+GdpuddH7TTkMczSh0sidMLkXkFow17wE4P7dZsm+A0IFEwoTMT8r/dI++2TDHdbnUAaMpk4O8xGWMnrMvikdpOlZVubwWsjA9C1xCgPnOUdDPR9c9B4tVOoIGFifBJ/krL8VE7o0Ol3s3sbNxA3lm5PwF6qSepRk=  ;
X-YMail-OSG: eDJNDigVM1lFho5U1v3FR3oKOfKFx0tKROPR_3Qcs5MUbkhXR8w5HXy5jwDzhNNeDHA6dyG9ZfFaFq4Qc.5Frqnck_E60ML1Ivr4n1__Hg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: =?utf-8?q?Tom=C3=A1=C5=A1_Janou=C5=A1ek?= <tomi@nomi.cz>
Subject: Re: [PATCH] rtc-dev: stop periodic interrupts on device release
Date: Mon, 28 Jul 2008 15:05:36 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org,
       Alessandro Zummo <alessandro.zummo@towertech.it>
References: <20080726154617.GA5613@notes.lisk.in> <200807261350.55524.david-b@pacbell.net> <20080728204136.GA6683@nomi.cz>
In-Reply-To: <20080728204136.GA6683@nomi.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200807281505.37122.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 July 2008, Tomáš Janoušek wrote:
> On Sat, Jul 26, 2008 at 01:50:55PM -0700, David Brownell wrote:
> > Hmm, I'd think that something like an rtc_dev_ioctl(PIE_OFF) would be

Typo, by the way ... I meant UIE_OFF.


> > preferable here ... so that it's not just UIE_EMUL logic which turns
> > off the one-per-second update IRQs.
> 
> I think it'd be more consistent if the framework only called the rtc api
> functions.

When they exist, sure.  But they currently don't, and I see no value
in adding them just to avoid a simple rtc_dev_ioctl(UIE_OFF) call.
It'd be different if any in-kernel code used update IRQs ... NTP sync?

(Regardless, that's a separate bug and appropriate for a different patch.)


> Like: if the driver doesn't export an op for it and handles it in 
> the ioctl op, it itself should be responsible to clear the irq in its release
> op. (I know there's no op for UIE, so we'd better add it instead of calling
> ioctl in the framework's release function.)

I still think the *existence* of a release() op is a problem.  It's
requiring the drivers to maintain history they should never need.

Surely you agree that having the framework shut down only *emulated*
update IRQs, not "real" ones, is inconsistent?  And hence undesirable?

- Dave

