Return-Path: <linux-kernel-owner+w=401wt.eu-S932965AbXCUQoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932965AbXCUQoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 12:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933043AbXCUQoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 12:44:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50731 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932965AbXCUQoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 12:44:19 -0400
Date: Wed, 21 Mar 2007 12:44:04 -0400
From: Dave Jones <davej@redhat.com>
To: "Cestonaro, Thilo (external)" 
	<Thilo.Cestonaro.external@fujitsu-siemens.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: how can I touch softlockup watchdog on all cpus?
Message-ID: <20070321164404.GF13218@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Cestonaro, Thilo (external)" <Thilo.Cestonaro.external@fujitsu-siemens.com>,
	linux-kernel@vger.kernel.org
References: <F7F9B0BE3E9BD449B110D0B1CEF6CAEF04FB6F2A@ABGEX01E.abg.fsc.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F7F9B0BE3E9BD449B110D0B1CEF6CAEF04FB6F2A@ABGEX01E.abg.fsc.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2007 at 05:06:34PM +0100, Cestonaro, Thilo (external) wrote:
 > Hey,
 > 
 > my module generates this ugly softlockup dump, because all cpus are stopped longer then 10 secs.
 > What I do is:
 > [code]
 > local_irq_disable();
 > // my stuff which takes long and stopps all cpus
 > .....
 > touch_softlockup_watchdog();
 > local_irq_enable();
 > [/code]
 > 
 > this prevents a dump of my current cpu but not for all.
 > A call to smp_call_function with a function which calls touch_softlockup_watchdog in it,
 > doesn't work because smp_call_function needs to be done with irqs enabled, so the watchdog comes first :(.
 > 
 > Any hints or ideas how I can do it in a better way? Disabling softlockup watchdog is not possible for me.

You didn't explain _why_ you need to sleep for such a long time,
and as you didn't give a pointer to your code, there's not
much people can do to recommend changes other than "don't do that".

	Dave

-- 
http://www.codemonkey.org.uk
