Return-Path: <linux-kernel-owner+w=401wt.eu-S1752633AbZIXRdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633AbZIXRdb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 13:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752763AbZIXRd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 13:33:29 -0400
Received: from smtp111.iad.emailsrvr.com ([207.97.245.111]:43831 "EHLO
	smtp111.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726AbZIXRd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 13:33:28 -0400
Message-ID: <4ABBAD65.3080706@librato.com>
Date: Thu, 24 Sep 2009 13:33:25 -0400
From: Oren Laadan <orenl@librato.com>
Organization: Librato
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Daniel Walker <dwalker@fifo99.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-api@vger.kernel.org,
       Serge Hallyn <serue@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Pavel Emelyanov <xemul@openvz.org>, Oren Laadan <orenl@cs.columbia.edu>
Subject: Re: [PATCH v18 20/80] c/r: basic infrastructure for checkpoint/restart
References: <1253749920-18673-1-git-send-email-orenl@librato.com>	 <1253749920-18673-21-git-send-email-orenl@librato.com> <1253808221.20648.196.camel@desktop>
In-Reply-To: <1253808221.20648.196.camel@desktop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Daniel Walker wrote:
> On Wed, 2009-09-23 at 19:51 -0400, Oren Laadan wrote:
>> /
>> +static char *__ckpt_generate_fmt(struct ckpt_ctx *ctx, char *prefmt, char *fmt)
>> +{
>> +	static int warn_notask = 0;
>> +	static int warn_prefmt = 0;
> 
> Shouldn't need the initializer since it's static..
> 

Yup ...

> 
>> +/* read the checkpoint header */
>> +static int restore_read_header(struct ckpt_ctx *ctx)
>> +{
>> +	struct ckpt_hdr_header *h;
>> +	struct new_utsname *uts = NULL;
>> +	int ret;
>> +
>> +	h = ckpt_read_obj_type(ctx, sizeof(*h), CKPT_HDR_HEADER);
>> +	if (IS_ERR(h))
>> +		return PTR_ERR(h);
>> +
>> +	ret = -EINVAL;
>> +	if (h->magic != CHECKPOINT_MAGIC_HEAD ||
>> +	    h->rev != CHECKPOINT_VERSION ||
>> +	    h->major != ((LINUX_VERSION_CODE >> 16) & 0xff) ||
>> +	    h->minor != ((LINUX_VERSION_CODE >> 8) & 0xff) ||
>> +	    h->patch != ((LINUX_VERSION_CODE) & 0xff))
>> +		goto out;
> 
> Do you still need this LINUX_VERSION_CODE stuff ? I would think once
> it's in mainline you wouldn't need to track that..

In short: yes.

This is our poor-man's way to telling the kernel version on which
a given checkpoint image was generated.

The image format is a blob that may change between kernel releases.
Conversion between version formats will be done by userspace tools.
Tagging the image with the version of the kernel serves two goals:
it indicates the image version to the kernel at restart time, and
it will be used by userspace conversion tools.

How the kernel and image versions are encoded is WIP and is likely
to become more comprehensive soon.

> 
> These both got flagged by checkpatch .. Your series is marked in a
> couple other places with checkpatch errors .. If you haven't already
> reviewed those errors, it would be a good idea to review them.
> 

Sure, will re-review to remove remaining errors that sneaked in.

Thanks,

Oren.

