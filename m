Return-Path: <linux-kernel-owner+w=401wt.eu-S1753520AbYFALlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbYFALlQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 07:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751425AbYFALlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 07:41:03 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:2886 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbYFALlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 07:41:01 -0400
To: j.mell@t-online.de
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com, arjan@linux.intel.com
Subject: Re: CONFIG_PREEMPT causes corruption of application's FPU stack
From: Andi Kleen <andi@firstfloor.org>
References: <200806011101.06491.j.mell@t-online.de>
Date: Sun, 01 Jun 2008 13:40:27 +0200
In-Reply-To: <200806011101.06491.j.mell@t-online.de> (j. mell's message of "Sun, 1 Jun 2008 11:01:06 +0200")
Message-ID: <87wsl9fkno.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 01 Jun 2008 11:33:21.0088 (UTC) FILETIME=[4B6F0400:01C8C3DB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

j.mell@t-online.de writes:

> or it is restored more than 
> once. Please keep in mind, that I am always running two Einstein processes 
> simultaneously on my two cores!
> I am willing to do further testing of this problem if someone can give me a 
> hint how to continue.

My bet would have been actually on aa283f49276e7d840a40fb01eee6de97eaa7e012
because it does some nasty things (enable interrupts in the middle
of __switch_to).

I looked through the old patchkit and couldn't find any specific 
PREEMPT problems. All code it changes should run with preempt_off

You could verify with sticking WARN_ON_ONCE(preemptible()) into 
all the places acc207616a91a413a50fdd8847a747c4a7324167 
changes (__unlazy_fpu, math_state_restore) and see if that triggers
anywhere.

-Andi
