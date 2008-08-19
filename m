Return-Path: <linux-kernel-owner+w=401wt.eu-S1753179AbYHSDIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbYHSDIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 23:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbYHSDIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 23:08:00 -0400
Received: from ozlabs.org ([203.10.76.45]:43681 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072AbYHSDIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 23:08:00 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Anthony Liguori <aliguori@us.ibm.com>
Subject: Re: [PATCH] virtio_balloon: fix towards_target when deflating balloon
Date: Tue, 19 Aug 2008 11:22:54 +1000
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>,
       virtualization@lists.linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>
References: <1219097731-1224-1-git-send-email-aliguori@us.ibm.com>
In-Reply-To: <1219097731-1224-1-git-send-email-aliguori@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808191122.54845.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 August 2008 08:15:31 Anthony Liguori wrote:
> -	return v - vb->num_pages;
> +	if (v < vb->num_pages)
> +		return -(s64)(vb->num_pages - v);
> +	else
> +		return v - vb->num_pages;

With all due respect, WTF?

Did you mean:

	return (s64)v - vb->num_pages;

I'm really amazed this bug got this far though...
Rusty.
