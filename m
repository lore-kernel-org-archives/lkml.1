Return-Path: <linux-kernel-owner+w=401wt.eu-S932984AbZJLRFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932984AbZJLRFc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 13:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932967AbZJLRFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 13:05:31 -0400
Received: from smtp.microsoft.com ([131.107.115.214]:34705 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932962AbZJLRFa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 13:05:30 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Greg KH <gregkh@suse.de>
CC: Hank Janssen <hjanssen@microsoft.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Tom Hanrahan <hanrahat@microsoft.com>,
       "Hashir Abdi" <habdi@microsoft.com>
Subject: RE: [patch] Staging: hv: Fix vmbus load hang caused by wrong data
 packing
Thread-Topic: [patch] Staging: hv: Fix vmbus load hang caused by wrong data
 packing
Thread-Index: AcpJ/6FE0xhfIRwfRT+rZ9QOhF0ebwBi+82AAA3jUSA=
Date: Mon, 12 Oct 2009 17:03:42 +0000
Message-ID: <1FB5E1D5CA062146B38059374562DF7212DF10DD@TK5EX14MBXC130.redmond.corp.microsoft.com>
References: <1FB5E1D5CA062146B38059374562DF7212DEE3EC@TK5EX14MBXC130.redmond.corp.microsoft.com>
 <20091012153013.GA2062@suse.de>
In-Reply-To: <20091012153013.GA2062@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  	ChannelMessageCount
> -} __attribute__((packed));

Why the change here?  Isn't this doing the same thing?

And I'm guessing that not all of these structures are needing to be
packed, right?  Are they all shared across the HV boundry?

And is this fixing the problem that Hank and users have reported with
the current code?  Does this need to get into the 2.6.32 release?


thanks,

greg k-h
================================================
Hi Greg,

Based on our testing, the #pragma pack(push,1) can pack the data correctly for the HyperV to use, but __attribute__((packed)) couldn't do this right.

These data structures are moved by someone from the original file, ChannelMessages.h, which contains structures used for messaging to host.

Yes, it's fixing the problem that Hank and users have reported with the current code. And yes, 2.6.32 needs this fix.

Thanks,

- Haiyang

