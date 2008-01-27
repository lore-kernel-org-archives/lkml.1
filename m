Return-Path: <linux-kernel-owner+w=401wt.eu-S1755111AbYA0HSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111AbYA0HSz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 02:18:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751601AbYA0HSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 02:18:45 -0500
Received: from trider-g7.fabbione.net ([195.22.207.161]:36014 "EHLO
	trider-g7.fabbione.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbYA0HSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 02:18:44 -0500
X-Greylist: delayed 1966 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Jan 2008 02:18:44 EST
Date: Sun, 27 Jan 2008 07:45:54 +0100 (CET)
From: "Fabio M. Di Nitto" <fabbione@ubuntu.com>
X-X-Sender: fabbione@trider-g7
To: Andrew Morton <akpm@linux-foundation.org>
cc: David Teigland <teigland@redhat.com>, linux-kernel@vger.kernel.org,
       fabbione@ubuntu.com
Subject: Re: [PATCH 06/19] dlm: align midcomms message buffer
In-Reply-To: <20080126220023.4d1256b6.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0801270742180.6826@trider-g7>
References: <1201193442-8260-7-git-send-email-teigland@redhat.com>
 <20080126220023.4d1256b6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Jan 2008, Andrew Morton wrote:

>> On Thu, 24 Jan 2008 10:50:29 -0600 David Teigland <teigland@redhat.com> wrote:
>> From: Fabio M. Di Nitto <fabbione@ubuntu.com>
>>
>> gcc does not guarantee that a static buffer is 64bit aligned. This change
>> allows sparc64 to work.
>>
>
> This buffer is not static: changelog needs fixing: s/static/auto/

thanks

>
>> ---
>>  fs/dlm/midcomms.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/dlm/midcomms.c b/fs/dlm/midcomms.c
>> index f8c69dd..da653b5 100644
>> --- a/fs/dlm/midcomms.c
>> +++ b/fs/dlm/midcomms.c
>> @@ -58,7 +58,7 @@ static void copy_from_cb(void *dst, const void *base, unsigned offset,
>>  int dlm_process_incoming_buffer(int nodeid, const void *base,
>>  				unsigned offset, unsigned len, unsigned limit)
>>  {
>> -	unsigned char __tmp[DLM_INBUF_LEN];
>> +	unsigned char __tmp[DLM_INBUF_LEN] __attribute__((aligned(64)));
>>  	struct dlm_header *msg = (struct dlm_header *) __tmp;
>>  	int ret = 0;
>>  	int err = 0;
>
> Why does DLM require that this thing be 64-bit aligned?

i spotted this running on sparc64 and the kernel was both complaning about 
TSP not being aligned and the data on the other side of the wire were 
wrong.

> It all looks rather ugly.  Can't this stuff be implemeted within the C type
> system somehow?

Yes, i will rework it.

Thanks for the feedback.

Fabio

--
I'm going to make him an offer he can't refuse.
