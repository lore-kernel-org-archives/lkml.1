Return-Path: <linux-kernel-owner+w=401wt.eu-S1763497AbZAHWwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763497AbZAHWwc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 17:52:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760950AbZAHWwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 17:52:09 -0500
Received: from mga06.intel.com ([134.134.136.21]:54195 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758802AbZAHWwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 17:52:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,235,1231142400"; 
   d="scan'208";a="376876577"
Message-ID: <49668388.708@linux.intel.com>
Date: Thu, 08 Jan 2009 14:51:52 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Grissiom <chaos.proton@gmail.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH] async: Don't call async_synchronize_full_special()	while
 holding sb_lock
References: <a0adeea50901080007q5a3ed5c8y5a744ce37e677325@mail.gmail.com> <1231425472.21528.13.camel@norville.austin.ibm.com> <20090108072111.1ebadebd@infradead.org> <1231429591.27353.14.camel@norville.austin.ibm.com> <20090108225050.GL9448@disturbed>
In-Reply-To: <20090108225050.GL9448@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner wrote:
> On Thu, Jan 08, 2009 at 09:46:31AM -0600, Dave Kleikamp wrote:
>> sync_filesystems() shouldn't be calling async_synchronize_full_special
>> while holding a spinlock.  The second while loop in that function is the
>> right place for this anyway.
> 
> Out of curiousity, what on earth does
> async_synchronize_full_special() do and why does it need to be in
> sync_filesystems()?
> 
now that we have asynchronous operations, this function makes sure that all the functions
that we started async before this point complete, so that what when you sync, you sync all in progress work.
