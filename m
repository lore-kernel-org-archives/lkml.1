Return-Path: <linux-kernel-owner+w=401wt.eu-S1754451AbYLCVU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451AbYLCVU4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 16:20:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752119AbYLCVUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 16:20:46 -0500
Received: from mga12.intel.com ([143.182.124.36]:23449 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751646AbYLCVUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 16:20:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,710,1220252400"; 
   d="scan'208";a="86138932"
Message-ID: <4936F83E.7090506@linux.intel.com>
Date: Wed, 03 Dec 2008 22:21:02 +0100
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Jonathan Corbet <corbet@lwn.net>, Al Viro <viro@zeniv.linux.org.uk>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: BUG? "Call fasync() functions without the BKL" is racy
References: <20081128192508.GA21369@redhat.com> <4933CBB0.2060003@linux.intel.com> <20081201191555.GA21385@redhat.com> <20081201123405.51d20d84@bike.lwn.net> <20081202122939.GA3619@redhat.com> <493562B5.5020600@linux.intel.com> <20081203190648.GA23893@redhat.com>
In-Reply-To: <20081203190648.GA23893@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> I wonder if we need FASYNC at all. This could be gotten implicitely by
>> looking at the fasync_list
> 
> Only if socket.

But the helpers used by the character drivers add it too I think.

> Serioulsy, I think the best (partial, yes) fix for now is to restore
> lock_kernel() in setfl() and change ioctl_fioxxx() accordingly.
> At least this protect us from tty too.

For 2.6.28 I agree.

> Not that I think this is very good idea though ;)

The lock bit sounds reasonable.

-Andi


