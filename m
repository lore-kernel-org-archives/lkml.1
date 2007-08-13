Return-Path: <linux-kernel-owner+w=401wt.eu-S1759535AbXHME2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759535AbXHME2H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 00:28:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbXHME14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 00:27:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46374 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbXHME1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 00:27:55 -0400
Message-ID: <46BFDDBB.2020104@zytor.com>
Date: Sun, 12 Aug 2007 21:27:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: rae l <crquan@gmail.com>
CC: Steven Whitehouse <swhiteho@redhat.com>, cluster-devel@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gfs2: better code for translating characters
References: <11869741183677-git-send-email-crquan@gmail.com> <91b13c310708122008w27b86359n5b135df3e229e616@mail.gmail.com>
In-Reply-To: <91b13c310708122008w27b86359n5b135df3e229e616@mail.gmail.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

rae l wrote:
> On 8/13/07, Denis Cheng <crquan@gmail.com> wrote:
>> the original code could work, but I think this code could work better.
>>
>> Signed-off-by: Denis Cheng <crquan@gmail.com>
>> ---
>>  fs/gfs2/ops_fstype.c |    3 ++-
>>  1 files changed, 2 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
>> index cf5aa50..b9a7759 100644
>> --- a/fs/gfs2/ops_fstype.c
>> +++ b/fs/gfs2/ops_fstype.c
>> @@ -145,7 +145,8 @@ static int init_names(struct gfs2_sbd *sdp, int silent)
>>         snprintf(sdp->sd_proto_name, GFS2_FSNAME_LEN, "%s", proto);
>>         snprintf(sdp->sd_table_name, GFS2_FSNAME_LEN, "%s", table);
>>
>> -       while ((table = strchr(sdp->sd_table_name, '/')))
>> +       table = sdp->sd_table_name;
>> +       while ((table = strchr(table, '/')))
>>                 *table = '_';
> Sorry, I don't know what the while loop really means, what's the
> common case that slash character exists? if the '/' appears multiple,
> the latter code would be better; however, if slash appears rarely, the
> original would still be better.
> 

Only if the compiler is stupid.

	-hpa
