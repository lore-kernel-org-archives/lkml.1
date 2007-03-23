Return-Path: <linux-kernel-owner+w=401wt.eu-S1422636AbXCWBQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422636AbXCWBQ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 21:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422638AbXCWBQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 21:16:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56278 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422636AbXCWBQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 21:16:25 -0400
Date: Thu, 22 Mar 2007 21:16:17 -0400
From: Dave Jones <davej@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "Cestonaro, Thilo (external)" 
	<Thilo.Cestonaro.external@fujitsu-siemens.com>,
       Lee Revell <rlrevell@joe-job.com>, linux-kernel@vger.kernel.org
Subject: Re: how can I touch softlockup watchdog on all cpus?
Message-ID: <20070323011617.GB1367@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	"Cestonaro, Thilo (external)" <Thilo.Cestonaro.external@fujitsu-siemens.com>,
	Lee Revell <rlrevell@joe-job.com>, linux-kernel@vger.kernel.org
References: <F7F9B0BE3E9BD449B110D0B1CEF6CAEF04FB6F2A@ABGEX01E.abg.fsc.net> <20070321164404.GF13218@redhat.com> <F7F9B0BE3E9BD449B110D0B1CEF6CAEF04FB710B@ABGEX01E.abg.fsc.net> <75b66ecd0703220830wdb4a612u86c80e71d4918cc4@mail.gmail.com> <F7F9B0BE3E9BD449B110D0B1CEF6CAEF04FEB060@ABGEX01E.abg.fsc.net> <75b66ecd0703220917w2fa7c6afs4817b689f8a2e98f@mail.gmail.com> <F7F9B0BE3E9BD449B110D0B1CEF6CAEF04FEB0F5@ABGEX01E.abg.fsc.net> <4603075E.4090001@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4603075E.4090001@goop.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2007 at 03:46:54PM -0700, Jeremy Fitzhardinge wrote:
 > Cestonaro, Thilo (external) wrote:
 > > It's a condition of a customer of us, so I can't change it.
 > >
 > > But it happens not often that my part is used. So I thought there is a mechanism to disable or reset the watchdog
 > > because it is a legal pause for it. And there is one "touch_softlockup_watchdog()", that does what I want,
 > > BUT just for the current cpu. And so the watchdog blats from the other cpu.
 > >   
 > 
 > on_each_cpu(touch_softlockup_watchdog, NULL, 0, 0)?

He wants to do this with interrupts off. on_each_cpu won't work in
that situation.

 > Or patch the softlockup watchdog to add a way to temporarily disable it.

Seems pretty much the only way you could make this work.

	Dave

-- 
http://www.codemonkey.org.uk
