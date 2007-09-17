Return-Path: <linux-kernel-owner+w=401wt.eu-S1755924AbXIQSVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924AbXIQSVw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 14:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754079AbXIQSVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 14:21:45 -0400
Received: from smtp-out.google.com ([216.239.33.17]:58842 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630AbXIQSVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 14:21:45 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=JlB39703CVhYGJ4LG4ckYaIuUFk4CZArN0bu113aI4eLtTxWMnNhq2qQ3lLMBmMnv
	SiJUJ9CL9ifMBExnVsUcA==
Message-ID: <6599ad830709171121r1ded056j7dc676bb6f37e231@mail.gmail.com>
Date: Mon, 17 Sep 2007 11:21:35 -0700
From: "Paul Menage" <menage@google.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] Add a refcount check in dput()
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <20070915013913.880b4c70.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070910221319.302473D66CF@localhost>
	 <20070915013913.880b4c70.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/15/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > +     BUG_ON(!atomic_read(&dentry->d_count));
> >  repeat:
> >       if (atomic_read(&dentry->d_count) == 1)
> >               might_sleep();
>
> eek, much too aggressive.

How about the equivalent BUG_ON() in dget()? I figure that they ought
to both be of the same strictness.

Paul
