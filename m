Return-Path: <linux-kernel-owner+w=401wt.eu-S1030567AbXAaTnO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030567AbXAaTnO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 14:43:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030569AbXAaTnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 14:43:14 -0500
Received: from smtp101.sbc.mail.mud.yahoo.com ([68.142.198.200]:27191 "HELO
	smtp101.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1030567AbXAaTnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 14:43:14 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=U1ddPTx4zYk8rz8IHMWlRNdnzpsejdTiptmaiy07KoFXdMwcjMR8XYOqVLIZaWMTK5IapieeMPcApe4fTSGhkbGZLwcqjuTgtLBuUeb04VOVaoBJqjrsCWjL6kXZTNH2P1sbPWCKPoIOHJ6EQlUMTvRfONI5z95OzyPZ0jD/4qc=  ;
X-YMail-OSG: JDJKDMMVM1kjH5OEMFWB.BZgkv70JEO7e6m_ZYGBXPvPpHgIPqNLCVD.aruo2zcNaiDUVM2Wqw--
Date: Wed, 31 Jan 2007 11:43:11 -0800
From: David Brownell <david-b@pacbell.net>
To: dwalker@mvista.com
Subject: Re: [PATCH 14/23] clocksource: increase initcall priority
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20070131194311.4B8381FD833@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> As a note, arm and mips both register their clocksources during
> time_init() instead of using initcalls.

That's actually platform-specific.  If there's only one possible
clocksource, that'd be the normal answer.

Otherwise, there can be multiple clocksources just like any other
architecture.  Maybe there's an always-present 32 KHz counter, and
a bank of timers that can run at higher frequences ... but those
may not be available for timekeeping on all boards, maybe because
they're used for something else (motor control, etc) or because the
system has prioritized battery life over timestamp precision.

So don't assume any platform doesn't use clocksource initcalls.

- Dave

