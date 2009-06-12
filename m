Return-Path: <linux-kernel-owner+w=401wt.eu-S934113AbZFLWFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934113AbZFLWFY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 18:05:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762780AbZFLWFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 18:05:11 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:20092 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbZFLWFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 18:05:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=RKGDPttSUBT7WIq0yZS9SlcPXcnAPeST/UkI1P5fB1BjUdQ4JA91CS8FB6sZCrRiOE
         UYDF3MGrCzv6fxLkC2ZCu00N2QUQfS1kzYCPt7rDmqw3MD881+1UiwGW6VUvZXkmPBwA
         FtGYgPSfrZsol46rUyIyMM2rGJXgM9g5KGj8w=
MIME-Version: 1.0
In-Reply-To: <20090608070503.GB11363@kernel.dk>
References: <4A0838D1.5090102@pentek.com> <20090511192253.GH4694@kernel.dk>
	 <c384c5ea0906061425x3b1ef6eer51d8a7ddeec51e47@mail.gmail.com>
	 <20090608070503.GB11363@kernel.dk>
Date: Sat, 13 Jun 2009 00:05:09 +0200
Message-ID: <c384c5ea0906121505g7ab137dp3bbc202da0d43bcd@mail.gmail.com>
Subject: Re: splice methods in character device driver
From: Leon Woestenberg <leon.woestenberg@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Steve Rottinger <steve@pentek.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jens,

On Mon, Jun 8, 2009 at 9:05 AM, Jens Axboe<jens.axboe@oracle.com> wrote:
> On Sat, Jun 06 2009, Leon Woestenberg wrote:
>> How can I pass information from the splice_read(), which spawns a hardware
>> DMA to the pages in my case, to the confirm() hook which is called at some
>> (random) time in the future?
>
> There's a ->private for each pipe_buffer, so you can pass along info on
> a per-page granularity.
>
So, this means in my driver's splice_read(), I must set
pipe->bufs[i]->private for each 0 <= i < PIPE_BUFFERS?


struct pipe_buffer {
   ...
   unsigned long private;
};
struct pipe_inode_info {
   ...
   struct pipe_buffer bufs[PIPE_BUFFERS];
};
static int splice_read(..., struct pipe_inode_info *pipe, ...)

Regards,
-- 
Leon
