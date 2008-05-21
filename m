Return-Path: <linux-kernel-owner+w=401wt.eu-S934977AbYEUA64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934977AbYEUA64 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 20:58:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933746AbYEUA60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 20:58:26 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:49992 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765003AbYEUA6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 20:58:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=vjVZIhv5fbrUdXeEMsTw7HpHTYezqOt572gAsIznbAb3t8k9zxZRfExDdWL/SKoIWVv/GgvEeDJbZVLeuoFy2HomRbxgBTJKPlDdz5iUv0jYM+G09p8RSNEEGRuKeZ2RTjF9mT/yfZ99fdb/pJtzSo5+27vWsuXTh4DP7A9qXN0=
Subject: Re: [PATCH] misc drivers/net endianness noise
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: jgarzik@pobox.com, linux-kernel@vger.kernel.org
In-Reply-To: <20080521005502.GF28946@ZenIV.linux.org.uk>
References: <20080521003430.GB28946@ZenIV.linux.org.uk>
	 <1211330880.5915.236.camel@brick>
	 <20080521005502.GF28946@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Tue, 20 May 2008 17:58:21 -0700
Message-Id: <1211331501.5915.248.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-05-21 at 01:55 +0100, Al Viro wrote:
> On Tue, May 20, 2008 at 05:48:00PM -0700, Harvey Harrison wrote:
> > I was contemplating an api like:
> > 
> > void put_le16(u16 val, __le16 *ptr)
> > {
> > 	*ptr = cpu_to_le16(val);
> > }
> > 
> > which would allow the above to become:
> > 
> > 	if (catc->is_f5u011)
> > 		put_be16(skb->len, tx_buf);
> > 	else
> > 		put_le16(skb->len, tx_buf);
> > 
> > Thoughts?
> 
> Do not grow API too much.  Mental savings on recognizing what's done are
> offset by need to remember more helper functions...

Fair point, I was hoping to get the following family:

get_le16
put_le16

get_unaligned_le16
put_unaligned_le16

And get rid of the le16_to_cpup api.

Then the it's explicit when alignment is an issue, and the endianess is
also explicit.  That and I think it just looks nicer than the existing
*p versions.

Just a thought,

Harvey

