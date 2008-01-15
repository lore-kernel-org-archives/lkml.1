Return-Path: <linux-kernel-owner+w=401wt.eu-S1751105AbYAOKqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751105AbYAOKqo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 05:46:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750858AbYAOKqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 05:46:36 -0500
Received: from wa-out-1112.google.com ([209.85.146.181]:10554 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbYAOKqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 05:46:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=RNTOCylMzWW8d2ek0VZPEWBwLI7tomuOqJr54ExH9Bt87AMCVzNpw162i+OpIQSnSNr/de48NZ2VeiDWKFrrT/6e6NQUA23+VoWbKEr4XbpZA0mcv176jjYZkdqGSXQxKlLowaoG5svHyIwN7yZeuAWipGyOfXkXnWnEhi8bXG8=
Message-ID: <4df4ef0c0801150246r56675627nf669812ec9daff89@mail.gmail.com>
Date: Tue, 15 Jan 2008 13:46:34 +0300
From: "Anton Salikhmetov" <salikhmetov@gmail.com>
To: "Miklos Szeredi" <miklos@szeredi.hu>
Subject: Re: [PATCH 2/2] updating ctime and mtime at syncing
Cc: a.p.zijlstra@chello.nl, linux-mm@kvack.org, jakob@unthought.net,
       linux-kernel@vger.kernel.org, valdis.kletnieks@vt.edu, riel@redhat.com,
       ksm@42.dk, staubach@redhat.com, jesper.juhl@gmail.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       protasnb@gmail.com
In-Reply-To: <E1JEiUT-0000qO-MY@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12001991991217-git-send-email-salikhmetov@gmail.com>
	 <12001992023392-git-send-email-salikhmetov@gmail.com>
	 <E1JENAv-0007CM-T9@pomaz-ex.szeredi.hu>
	 <4df4ef0c0801140422l1980d507v1884ad8d8e8bf6d3@mail.gmail.com>
	 <E1JEP9P-0007RD-PP@pomaz-ex.szeredi.hu>
	 <1200317737.15103.8.camel@twins>
	 <4df4ef0c0801140617t6ca81e84w1cdfcce290ce68fe@mail.gmail.com>
	 <E1JEiUT-0000qO-MY@pomaz-ex.szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/1/15, Miklos Szeredi <miklos@szeredi.hu>:
> > Thanks for your review, Peter and Miklos!
> >
> > I overlooked this case when AS_MCTIME flag has been turned off and the
> > page is still dirty.
> >
> > On the other hand, the words "shall be marked for update" may be
> > considered as just setting the AS_MCTIME flag, not updating the time
> > stamps.
> >
> > What do you think about calling mapping_update_time() inside of "if
> > (MS_SYNC & flags)"? I suggest such change because the code for
> > analysis of the case you've mentioned above seems impossible to me.
>
> I think that's a good idea.  As a first iteration, just updating the
> mtime/ctime in msync(MS_SYNC) and remove_vma() (called at munmap time)
> would be a big improvement over what we currently have.
>
> I would also recommend, that you drop mapping_update_time() and the
> related functions from the patch, and just use file_update_time()
> instead.

Thank you for your recommendations. I will submit my new solution shortly.

By the way, I've already changed the unlink_file_vma() function.

>
> Miklos
>
