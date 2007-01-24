Return-Path: <linux-kernel-owner+w=401wt.eu-S1030224AbXAXFyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030224AbXAXFyT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 00:54:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030225AbXAXFyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 00:54:19 -0500
Received: from smtp.osdl.org ([65.172.181.24]:53211 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030224AbXAXFyS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 00:54:18 -0500
Date: Tue, 23 Jan 2007 21:53:18 -0800
From: Andrew Morton <akpm@osdl.org>
To: =?ISO-8859-1?B?U+liYXN0aWVuIER1Z3Xp?= <sebastien.dugue@bull.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-aio <linux-aio@kvack.org>, Bharata B Rao <bharata@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Jean Pierre Dion <jean-pierre.dion@bull.net>,
       Badari Pulavarty <pbadari@us.ibm.com>
Subject: Re: [PATCH -mm 5/5][AIO] - Add listio syscall support
Message-Id: <20070123215318.beddfdf7.akpm@osdl.org>
In-Reply-To: <20070117105554.346324b4@frecb000686>
References: <20070117104601.36b2ab18@frecb000686>
	<20070117105554.346324b4@frecb000686>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jan 2007 10:55:54 +0100
Sébastien Dugué <sebastien.dugue@bull.net> wrote:

> +struct lio_event *lio_create(struct sigevent __user *user_event,
> +			int mode)
> +{
> +	int ret = 0;
> +	struct lio_event *lio = NULL;
> +
> +	if (unlikely((mode == LIO_NOWAIT) && !user_event))
> +		return lio;
> +
> +	lio = kzalloc(sizeof(*lio), GFP_KERNEL);
> +
> +	if (!lio)
> +		return ERR_PTR(-EAGAIN);
> +

Why EAGAIN and not ENOMEM?
