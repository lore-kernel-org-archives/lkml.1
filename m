Return-Path: <linux-kernel-owner+w=401wt.eu-S1758973AbYCNTyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758973AbYCNTyA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 15:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757869AbYCNTxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 15:53:37 -0400
Received: from homer.mvista.com ([63.81.120.158]:38287 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1758576AbYCNTxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 15:53:36 -0400
Subject: Re: [PATCH v1] change likeliness accounting
From: Daniel Walker <dwalker@mvista.com>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: lkml <linux-kernel@vger.kernel.org>, Hua Zhong <hzhong@gmail.com>,
       akpm@linux-foundation.org
In-Reply-To: <47D9B35C.9@tiscali.nl>
References: <47D9B35C.9@tiscali.nl>
Content-Type: text/plain
Date: Fri, 14 Mar 2008 12:53:31 -0700
Message-Id: <1205524411.10894.108.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-03-14 at 00:06 +0100, Roel Kluin wrote:

> -	seq_printf(out, "|%9u|%9u\t%s()@:%s@%d\n", true, false,
> -			entry->func, entry->file, entry->line);
> +	sprint_symbol(function, entry->caller);
> +	seq_printf(out, "|%9u|%9u\t%s()@:%u\n", pos, neg, function,
> +					entry->label >> LP_LINE_SHIFT);

Looks like we're missing a "|" after the second %9u above .. You could
add that as long as your modifying this area.. Also your tabbing is a
little too heavy ..

I wonder if you think the change to saving the caller EIP is better than
saving the file name? The size saving in the likeliness struct is nice,
but since this is for debugging is not at all required ..

Overall it looks like a nice update/cleanup ..

(CC'd Andrew and Hua..)

Daniel

