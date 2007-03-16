Return-Path: <linux-kernel-owner+w=401wt.eu-S965903AbXCPUiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965903AbXCPUiA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 16:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965907AbXCPUiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 16:38:00 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:46098 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965903AbXCPUh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 16:37:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=YR6Tjsxfz/jih7zA8oHqMBZEFNnM5FY8ZFBjoU5MxfE1YrdyOyZMOsLZqmnr/kLnVl+DtKMDAfoEDcuzClQCmwfnp3eHDEmrhsz2oAM0TQYGPk20FIHqbop9UEpD8PLnZmaQf4fVn1OIsemyvOmmhC2KwC9wVs0ihtn3ws2stTI=
Message-ID: <84144f020703161337o3a6519cfn34d4b2620062264d@mail.gmail.com>
Date: Fri, 16 Mar 2007 22:37:57 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/5] revoke: core code
Cc: linux-kernel@vger.kernel.org, hch@infradead.org, alan@lxorguk.ukuu.org.uk
In-Reply-To: <20070316042600.3e1bd424.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0703111330100.765@sbz-30.cs.Helsinki.FI>
	 <20070315173438.efadd514.akpm@linux-foundation.org>
	 <84144f020703152344u588da670ge14c1ec5797c2b86@mail.gmail.com>
	 <20070316032624.c6db84fc.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0703161331580.21300@sbz-30.cs.Helsinki.FI>
	 <20070316042600.3e1bd424.akpm@linux-foundation.org>
X-Google-Sender-Auth: cc32c7edb3ff90cd
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/16/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> However, modifying i_size like this might be a problem - the inode could be
> dirty and it'll get written to disk!  Perhaps we could change i_size_read()
> to cheat and to return zero if there's a revoke in progress.

I don't think we can actually abuse i_size_read() in any sane manner
because the inode needs to be usable for anyone who just did open(2)
after revoke or whoever called frevoke(2).

What we could do is add a "I am revoked" flag to struct file which
blocks any future ->readpage, ->readpages, and ->direct_IO on the
file. Alternatively, we could change the ->f_mapping to point to an
address space that has "revoked address space" operations. Hmm.
