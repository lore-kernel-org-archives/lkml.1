Return-Path: <linux-kernel-owner+w=401wt.eu-S1754956AbYAQQd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956AbYAQQd0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 11:33:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbYAQQdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 11:33:18 -0500
Received: from ro-out-1112.google.com ([72.14.202.177]:36941 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbYAQQdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 11:33:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SfYm3w6EaIYxaAS5pWFZSxM9jrZNWQtFH6Lhr1I+glE9wN04HCL2EX1m7+M6k4MBpNyzteZlkkGyphtwoI5UD/M9QeljsXjlddFMT/+9lLTd4iJWA+y22sidCYM681PLuyn0wGaE1U/GE9HSVwIj0FEp/+9dlmCJ5obPlj7rwL8=
Message-ID: <4df4ef0c0801170833p4b416b50h495c2b34a17ef77f@mail.gmail.com>
Date: Thu, 17 Jan 2008 19:33:15 +0300
From: "Anton Salikhmetov" <salikhmetov@gmail.com>
To: "Miklos Szeredi" <miklos@szeredi.hu>
Subject: Re: [PATCH -v5 2/2] Updating ctime and mtime at syncing
Cc: linux-mm@kvack.org, jakob@unthought.net, linux-kernel@vger.kernel.org,
       valdis.kletnieks@vt.edu, riel@redhat.com, ksm@42.dk,
       staubach@redhat.com, jesper.juhl@gmail.com,
       torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
       akpm@linux-foundation.org, protasnb@gmail.com, r.e.wolff@bitwizard.nl,
       hidave.darkstar@gmail.com, hch@infradead.org
In-Reply-To: <E1JFXZd-0006pP-Sn@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12005314662518-git-send-email-salikhmetov@gmail.com>
	 <E1JFSgG-0006G1-6V@pomaz-ex.szeredi.hu>
	 <4df4ef0c0801170416s5581ae28h90d91578baa77738@mail.gmail.com>
	 <E1JFU7r-0006PK-So@pomaz-ex.szeredi.hu>
	 <4df4ef0c0801170516k3f82dc69ieee836b5633378a@mail.gmail.com>
	 <E1JFUrm-0006XG-SB@pomaz-ex.szeredi.hu>
	 <4df4ef0c0801170540p36d3c566w973251527fc3bca1@mail.gmail.com>
	 <E1JFWvy-0006kJ-I2@pomaz-ex.szeredi.hu>
	 <4df4ef0c0801170820i6af58e8u15e3c3b8e944c0c6@mail.gmail.com>
	 <E1JFXZd-0006pP-Sn@pomaz-ex.szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/1/17, Miklos Szeredi <miklos@szeredi.hu>:
> > The do_wp_page() function is called in mm/memory.c after locking PTE.
> > And the file_update_time() routine calls the filesystem operation that can
> > sleep. It's not accepted, I guess.
>
> do_wp_page() is called with the pte lock but drops it, so that's fine.

OK, I agree.

I'll take into account your suggestion to move updating time stamps from
the __set_page_dirty() and __set_page_dirty_nobuffers() routines to
do_wp_page(). Thank you!

>
> Miklos
>
