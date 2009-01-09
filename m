Return-Path: <linux-kernel-owner+w=401wt.eu-S1756056AbZAIEpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056AbZAIEpb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 23:45:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753254AbZAIEpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 23:45:18 -0500
Received: from mga12.intel.com ([143.182.124.36]:20872 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753118AbZAIEpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 23:45:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,237,1231142400"; 
   d="scan'208";a="98076220"
Message-ID: <4966D652.4070105@linux.intel.com>
Date: Thu, 08 Jan 2009 20:45:06 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Grissiom <chaos.proton@gmail.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] async: Don't call async_synchronize_full_special()	while
 holding sb_lock
References: <a0adeea50901080007q5a3ed5c8y5a744ce37e677325@mail.gmail.com> <1231425472.21528.13.camel@norville.austin.ibm.com> <20090108072111.1ebadebd@infradead.org> <1231429591.27353.14.camel@norville.austin.ibm.com> <20090108225050.GL9448@disturbed> <49668388.708@linux.intel.com> <20090109014054.GN9448@disturbed>
In-Reply-To: <20090109014054.GN9448@disturbed>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner wrote:

> 
> So, given the potential impact of this change, what testing have
> you done in terms of:
> 
> 	- performance impact

I tested this on my machines and it gave a real performance improvement (11 to 8 seconds for a full kernel tree unlink, and cutting out
latency for normal applications)
> 	- sync() safety
that was exactly the synchronization point that's discussed here.

> 	- removing a million files and queuing all of the
> 	  deletes in the async queues....

the async code throttles at 32k outstanding.
Yes 32K is arbitrary, but if you delete  a million files fast, all but the first few thousand are
synchronous.

