Return-Path: <linux-kernel-owner+w=401wt.eu-S1752208AbZH0MDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208AbZH0MDj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 08:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752061AbZH0MDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 08:03:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933AbZH0MDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 08:03:38 -0400
Date: Thu, 27 Aug 2009 15:02:06 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Paolo Bonzini <bonzini@gnu.org>
Cc: davidel@xmailserver.org, avi@redhat.com, gleb@redhat.com,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] eventfd: reorganize the code to simplify new flags
Message-ID: <20090827120206.GA21907@redhat.com>
References: <cover.1250783333.git.mst@redhat.com> <20090820155703.GB8764@redhat.com> <4A9672A5.60004@gnu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A9672A5.60004@gnu.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 27, 2009 at 01:48:53PM +0200, Paolo Bonzini wrote:
> On 08/20/2009 05:57 PM, Michael S. Tsirkin wrote:
>> +static inline int eventfd_writeable(struct eventfd_ctx *ctx, u64 n)
>> +{
>> +	return ULLONG_MAX - n>  ctx->count;
>> +}
>> +
>> +static inline void eventfd_dowrite(struct eventfd_ctx *ctx, u64 ucnt)
>> +{
>> +	if (eventfd_writeable(ctx, ucnt))
>> +		ucnt = ULLONG_MAX - ctx->count;
>> +
>> +	ctx->count += ucnt;
>
> In any case, this usage of eventfd_writeable is wrong:

Fixed, thanks!
