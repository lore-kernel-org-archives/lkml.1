Return-Path: <linux-kernel-owner+w=401wt.eu-S1757567AbZCDUBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567AbZCDUBp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 15:01:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756057AbZCDUBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 15:01:36 -0500
Received: from a-sasl-fastnet.sasl.smtp.pobox.com ([207.106.133.19]:56538 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756261AbZCDUBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 15:01:36 -0500
Date: Wed, 4 Mar 2009 14:01:29 -0600
From: Nathan Lynch <ntl@pobox.com>
To: Dan Smith <danms@us.ibm.com>
Cc: containers@lists.osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] c/r: Add CR_COPY() macro (v3)
Message-ID: <20090304140129.35e1ad97@thinkcentre.lan>
In-Reply-To: <1236095764-19325-3-git-send-email-danms@us.ibm.com>
References: <1236095764-19325-1-git-send-email-danms@us.ibm.com>
 <1236095764-19325-3-git-send-email-danms@us.ibm.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Pobox-Relay-ID: 429E266E-08F7-11DE-A638-CFA5EBB1AA3C-04752483!a-sasl-fastnet.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan.

Dan Smith <danms@us.ibm.com> wrote:
> +#define CR_CPT 1
> +#define CR_RST 2
> +
> +#define CR_COPY(op, a, b)				        \
> +	do {							\
> +		if (op == CR_CPT)				\
> +			a = b;					\
> +		else						\
> +			b = a;					\
> +	} while (0);

Drop the semicolon ^


> +
> +#define CR_COPY_ARRAY(op, a, b, count)				\
> +	do {							\
> +		BUILD_BUG_ON(sizeof(*a) != sizeof(*b));		\
> +		if (op == CR_CPT)				\
> +			memcpy(a, b, count * sizeof(*a));	\
> +		else						\
> +			memcpy(b, a, count * sizeof(*a));	\
> +	} while (0);
> +

You might want to employ __must_be_array() or similar to catch misuse.

Misuse might also be prevented by providing some documentation :)
