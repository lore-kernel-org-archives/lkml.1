Return-Path: <linux-kernel-owner+w=401wt.eu-S932926AbYBON5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932926AbYBON5i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 08:57:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755886AbYBON52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 08:57:28 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:35845 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755838AbYBON51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 08:57:27 -0500
Subject: Re: [PATCH 3/4] IPMI: convert locked counters to atomics
From: Peter Zijlstra <peterz@infradead.org>
To: minyard@acm.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>,
       Konstantin Baydarov <kbaidarov@ru.mvista.com>
In-Reply-To: <20080214183051.GC20148@minyard.local>
References: <20080214183051.GC20148@minyard.local>
Content-Type: text/plain
Date: Fri, 15 Feb 2008 14:57:23 +0100
Message-Id: <1203083843.6855.44.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-14 at 12:30 -0600, Corey Minyard wrote:

> +/*
> + * Various statistics for IPMI, these index stats[] in the ipmi_smi
> + * structure.
> + */
> +/* Commands we got from the user that were invalid. */
> +#define IPMI_STAT_sent_invalid_commands			0
> +
> +/* Commands we sent to the MC. */
> +#define IPMI_STAT_sent_local_commands			1
> +
> +/* Responses from the MC that were delivered to a user. */
> +#define IPMI_STAT_handled_local_responses		2
> +
> +/* Responses from the MC that were not delivered to a user. */
> +#define IPMI_STAT_unhandled_local_responses		3
> +
> +/* Commands we sent out to the IPMB bus. */
> +#define IPMI_STAT_sent_ipmb_commands			4
> +
> +/* Commands sent on the IPMB that had errors on the SEND CMD */
> +#define IPMI_STAT_sent_ipmb_command_errs		5
> +
> +/* Each retransmit increments this count. */
> +#define IPMI_STAT_retransmitted_ipmb_commands		6
> +
> +/* When a message times out (runs out of retransmits) this is incremented. */
> +#define IPMI_STAT_timed_out_ipmb_commands		7
> +
> +/*
> + * This is like above, but for broadcasts.  Broadcasts are
> + * *not* included in the above count (they are expected to
> + * time out).
> + */
> +#define IPMI_STAT_timed_out_ipmb_broadcasts		8
> +
> +/* Responses I have sent to the IPMB bus. */
> +#define IPMI_STAT_sent_ipmb_responses			9
> +
> +/* The response was delivered to the user. */
> +#define IPMI_STAT_handled_ipmb_responses		10
> +
> +/* The response had invalid data in it. */
> +#define IPMI_STAT_invalid_ipmb_responses		11
> +
> +/* The response didn't have anyone waiting for it. */
> +#define IPMI_STAT_unhandled_ipmb_responses		12
> +
> +/* Commands we sent out to the IPMB bus. */
> +#define IPMI_STAT_sent_lan_commands			13
> +
> +/* Commands sent on the IPMB that had errors on the SEND CMD */
> +#define IPMI_STAT_sent_lan_command_errs			14
> +
> +/* Each retransmit increments this count. */
> +#define IPMI_STAT_retransmitted_lan_commands		15
> +
> +/* When a message times out (runs out of retransmits) this is incremented. */
> +#define IPMI_STAT_timed_out_lan_commands		16
> +
> +/* Responses I have sent to the IPMB bus. */
> +#define IPMI_STAT_sent_lan_responses			17
> +
> +/* The response was delivered to the user. */
> +#define IPMI_STAT_handled_lan_responses			18
> +
> +/* The response had invalid data in it. */
> +#define IPMI_STAT_invalid_lan_responses			19
> +
> +/* The response didn't have anyone waiting for it. */
> +#define IPMI_STAT_unhandled_lan_responses		20
> +
> +/* The command was delivered to the user. */
> +#define IPMI_STAT_handled_commands			21
> +
> +/* The command had invalid data in it. */
> +#define IPMI_STAT_invalid_commands			22
> +
> +/* The command didn't have anyone waiting for it. */
> +#define IPMI_STAT_unhandled_commands			23
> +
> +/* Invalid data in an event. */
> +#define IPMI_STAT_invalid_events			24
> +
> +/* Events that were received with the proper format. */
> +#define IPMI_STAT_events				25
> +
> +/* When you add a statistic, you must update this value. */
> +#define IPMI_NUM_STATS					26

This shouts enum to me..

