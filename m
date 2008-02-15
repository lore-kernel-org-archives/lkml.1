Return-Path: <linux-kernel-owner+w=401wt.eu-S933931AbYBOOKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933931AbYBOOKk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 09:10:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757336AbYBOOKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 09:10:31 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:37998 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757094AbYBOOKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 09:10:30 -0500
Date: Fri, 15 Feb 2008 15:10:29 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Jan Kara <jack@suse.cz>
cc: Michael Tokarev <mjt@tls.msk.ru>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH] quota: Turn quotas off when remounting read-only
In-Reply-To: <20080211123927.GF9622@duck.suse.cz>
Message-ID: <Pine.LNX.4.64.0802151509010.30301@fbirervta.pbzchgretzou.qr>
References: <20080207143721.GH6140@duck.suse.cz> <20080207103655.14ce8512.akpm@linux-foundation.org>
 <47AB5B9F.8090302@msgid.tls.msk.ru> <20080211123927.GF9622@duck.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 11 2008 13:39, Jan Kara wrote:
>> 
>> But...  I'm thinking about this scenario:
>> 
>>  # mount /data
>>  # quotaon /data
>>  (some maintenance stuff to be planned)
>>  # mount -o remount,ro /data
>>  (do backup etc)
>>  # mount -r remount,rw /data
>> 
>> at this point, it's expected that quota on /data is enabled.
>> After this patch, it's not anymore...
>
>  Yes, it previously accidentally worked this way (for an year or so,
>before that we refused to remount read-only). Hmm, but maybe we could
>somehow tweak quotas to be turned on when remounting read-write again.
>We have all the information we need at the time of remounting read-only
>so we could store it and use it later when remounting read-write. I'll have
>a look into that.

Maybe it is possible to leave quota on all times, so that the
reporting quota ioctls continue to work even in ro mode?

