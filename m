Return-Path: <linux-kernel-owner+w=401wt.eu-S1753117AbXGYE31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117AbXGYE31 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 00:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751034AbXGYE3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 00:29:19 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:10365 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbXGYE3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 00:29:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Qjg9tdX/mpnCd2wlnEk9zUF4tj2ETUPqreZNzR0S3ZbKmiAXg4sWg6RNCD/OGb3Iqcd10l8nlMosrzBqob/ku3kU+hhUd5fp/KncMgkW3E5OwhnlPCUDLjrRv6H2ANLm0u5FMcThzhIXDb9vqEnrn1XetGqFftv5N8JvRggvnag=
Message-ID: <91b13c310707242129u6aa09166j74ad42d31adc4ad7@mail.gmail.com>
Date: Wed, 25 Jul 2007 12:29:17 +0800
From: "rae l" <crquan@gmail.com>
To: "Al Viro" <viro@ftp.linux.org.uk>
Subject: Re: [RFC] fs/super.c: Why alloc_super use a static variable default_op?
Cc: "Alexander Viro" <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
       "Greg Kroah-Hartman" <gregkh@suse.de>
In-Reply-To: <20070725041407.GA27237@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <91b13c310707242048lb54b071u5e7fc4272b142475@mail.gmail.com>
	 <20070725041407.GA27237@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/25/07, Al Viro <viro@ftp.linux.org.uk> wrote:
> On Wed, Jul 25, 2007 at 11:48:35AM +0800, rae l wrote:
> > Why alloc_super use a static variable default_op?
> > the static struct super_operations default_op is just all zeros, and
> > just referenced as the initial value of a new allocated super_block,
> > what does it for?
>
> So that we would not have to care about ->s_op *ever* being NULL.
But is it valuable? Compared to a waste of sizeof(struct super_block)
bytes memory.

When some code want to refer fs_type->s_op, it almost always want to
refer some function pointer in s_op with fs_type->s_op->***, but all
pointers in default_op are all NULLs, what about this scenario?

and if you do grep s_op in the source code, you will found nowhere
will want to test s_op or dependent on s_op not NULL.

So my opinion is to remove default_ops, just keep new allocated s_op NULL.

>


-- 
Denis Cheng
Linux Application Developer

"One of my most productive days was throwing away 1000 lines of code."
 - Ken Thompson.
