Return-Path: <linux-kernel-owner+w=401wt.eu-S932753AbXCUQQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932753AbXCUQQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 12:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932840AbXCUQQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 12:16:19 -0400
Received: from dgate2.fujitsu-siemens.com ([217.115.66.36]:23976 "EHLO
	dgate2.fujitsu-siemens.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932753AbXCUQQR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 12:16:17 -0400
DomainKey-Signature: s=s768; d=fujitsu-siemens.com; c=nofws; q=dns; b=1kQpycrqnvxy+lvd+1IJOb+lqUPuBr6+SKPYpm5Uok/5V0ZaHjPRJpSNsZNtxqsRlw7EYi8om+cEhd8thtDmQSzK9OcR2kRYqszH8n1R7NyvosfD9WnGb2KHL++cpiXH;
X-SBRSScore: None
X-IronPort-AV: i="4.14,309,1170630000"; 
   d="scan'208"; a="62672883:sNHT23427036"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: how can I touch softlockup watchdog on all cpus?
Date: Wed, 21 Mar 2007 17:06:34 +0100
Message-ID: <F7F9B0BE3E9BD449B110D0B1CEF6CAEF04FB6F2A@ABGEX01E.abg.fsc.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: how can I touch softlockup watchdog on all cpus?
Thread-Index: Acdr0uXUzQRkiPRBS2WyCNlFmDOOkw==
From: "Cestonaro, Thilo \(external\)" 
	<Thilo.Cestonaro.external@fujitsu-siemens.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 21 Mar 2007 16:06:30.0764 (UTC) FILETIME=[E3829AC0:01C76BD2]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

my module generates this ugly softlockup dump, because all cpus are stopped longer then 10 secs.
What I do is:
[code]
local_irq_disable();
// my stuff which takes long and stopps all cpus
.....
touch_softlockup_watchdog();
local_irq_enable();
[/code]

this prevents a dump of my current cpu but not for all.
A call to smp_call_function with a function which calls touch_softlockup_watchdog in it,
doesn't work because smp_call_function needs to be done with irqs enabled, so the watchdog comes first :(.

Any hints or ideas how I can do it in a better way? Disabling softlockup watchdog is not possible for me.

Ciao Thilo
