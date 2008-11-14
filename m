Return-Path: <linux-kernel-owner+w=401wt.eu-S1754024AbYKNNTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbYKNNTr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 08:19:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751775AbYKNNTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 08:19:39 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:63116 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670AbYKNNTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 08:19:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=t8qVHSZTb0/7PXwhAfZFAcUPxfM/8GF/uhVTX6s1fa8XNaweklWKIHFDgiKyWBwYK1
         BGgp56nNNNGtLkw/k0R051JA65TF4tP7T/1OYsiyq9zAH0b7/oUfg0fW4z3gRk6h9TYS
         3CaHscf1nYKqCawQq7dMCkJXcirI+6E0cnPIw=
Message-ID: <c62985530811140519o112bd5e2s69b682e48e50e67d@mail.gmail.com>
Date: Fri, 14 Nov 2008 14:19:37 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/3] ftrace: Add debug_dump trace to dump binary data from kernel to userspace
Cc: rostedt@goodmis.org, mingo@elte.hu, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1226659566-28168-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1226659566-28168-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1226659566-28168-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1226659566-28168-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/14 Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>:
> +static int
> +trace_seq_putmem(struct trace_seq *s, void *mem, size_t len)
> +{
> +       if (len > ((PAGE_SIZE - 1) - s->len))
> +               return 0;
> +
> +       memcpy(s->buffer + s->len, mem, len);
> +       s->len += len;
> +
> +       return len;
> +}



I forgot to say that I like the idea of this tracer. That would be
useful to dump some random datas from memory.
But I would find it much more useful if I could choose whether the
output is raw bytes or an hexadecimal drawing of the dump,
pretty much like hexdump does. That's better to know where we are in
the dump, and to have a directly human readable dump.

Currently this is not yet possible to choose whether we want a kind of
output or one other. Or perhaps by listen to the iter flags.
I will probably send a patch to make a tracer able to support custom
flags through the old-named iter_ctrl file.
