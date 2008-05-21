Return-Path: <linux-kernel-owner+w=401wt.eu-S933223AbYEUAzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933223AbYEUAzU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 20:55:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756699AbYEUAzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 20:55:05 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39270 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756671AbYEUAzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 20:55:04 -0400
Date: Wed, 21 May 2008 01:55:02 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: jgarzik@pobox.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] misc drivers/net endianness noise
Message-ID: <20080521005502.GF28946@ZenIV.linux.org.uk>
References: <20080521003430.GB28946@ZenIV.linux.org.uk> <1211330880.5915.236.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1211330880.5915.236.camel@brick>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 05:48:00PM -0700, Harvey Harrison wrote:
> I was contemplating an api like:
> 
> void put_le16(u16 val, __le16 *ptr)
> {
> 	*ptr = cpu_to_le16(val);
> }
> 
> which would allow the above to become:
> 
> 	if (catc->is_f5u011)
> 		put_be16(skb->len, tx_buf);
> 	else
> 		put_le16(skb->len, tx_buf);
> 
> Thoughts?

Do not grow API too much.  Mental savings on recognizing what's done are
offset by need to remember more helper functions...
