Return-Path: <linux-kernel-owner+w=401wt.eu-S1161864AbXDYSNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161864AbXDYSNK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 14:13:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161865AbXDYSNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 14:13:09 -0400
Received: from gw.goop.org ([64.81.55.164]:58720 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161864AbXDYSNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 14:13:08 -0400
Message-ID: <462F9A4E.5050905@goop.org>
Date: Wed, 25 Apr 2007 11:13:34 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>, john stultz <johnstul@us.ibm.com>,
       Keir Fraser <Keir.Fraser@cl.cam.ac.uk>
Subject: Re: [PATCH 09/25] xen: Account for time stolen by Xen
References: <20070423215638.563901986@goop.org> <20070423215710.867690403@goop.org> <200704251115.49966.ak@suse.de>
In-Reply-To: <200704251115.49966.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> +
>> +	do {
>> +		state_time = state->state_entry_time;
>> +		barrier();
>>     
>
> Should be likely rmb

We discussed this, and decided that it wasn't necessary.  The state is
always updated by the current CPU, so if it changes under our feet it
will be because we were preempted, and so that should shoot down any
speculated reads.

    J

