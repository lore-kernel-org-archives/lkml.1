Return-Path: <linux-kernel-owner+w=401wt.eu-S1757956AbXIMO1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956AbXIMO1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 10:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751600AbXIMO1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 10:27:08 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:5058 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbXIMO1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 10:27:07 -0400
In-Reply-To: <adaps0nmbfa.fsf@cisco.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Christoph Raisch <raisch@de.ibm.com>, "OF-EWG" <ewg@lists.openfabrics.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Hoang-Nam Nguyen <hnguyen@de.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>,
       Roland Dreier <rolandd@cisco.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
MIME-Version: 1.0
Subject: Re: [PATCH] IB/ehca: Make sure user pages are from hugetlb before using MR
 large pages
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
From: Joachim Fenkes <FENKES@de.ibm.com>
Message-ID: <OF2FF112E2.22D1AA53-ONC1257355.00360D85-C1257355.004F61C6@de.ibm.com>
Date: Thu, 13 Sep 2007 16:27:03 +0200
X-MIMETrack: Serialize by Router on D12ML064/12/M/IBM(Release 7.0.2HF71 | November 3, 2006) at
 13/09/2007 16:27:04,
	Serialize complete at 13/09/2007 16:27:04
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier <rdreier@cisco.com> wrote on 13.09.2007 06:33:45:

>  > -#define HCA_CAP_MR_PGSIZE_4K  1
>  > -#define HCA_CAP_MR_PGSIZE_64K 2
>  > -#define HCA_CAP_MR_PGSIZE_1M  4
>  > -#define HCA_CAP_MR_PGSIZE_16M 8
>  > +#define HCA_CAP_MR_PGSIZE_4K  0x80000000
>  > +#define HCA_CAP_MR_PGSIZE_64K 0x40000000
>  > +#define HCA_CAP_MR_PGSIZE_1M  0x20000000
>  > +#define HCA_CAP_MR_PGSIZE_16M 0x10000000
> 
> Not sure I understand what this has to do with things... is this an
> unrelated fix?

Kinda. I can put it into its own patch if you want.
 
> I would suggest extending ib_umem_get() to check the vmas and adding a
> member to struct ib_umem to say whether the memory is entirely covered
> by hugetlb pages or not.

I like that approach - one patch coming right up! =)
 
>  > +      default: /* out of mem */
>  > +         ib_mr = ERR_PTR(-ENOMEM);
>  > +         goto reg_user_mr_exit1;
> 
> It seems like it would be better to just assume the memory is not from
> a hugetlb is ehca_is_mem_hugetlb() fails its memory allocation and
> fall back to the PAGE_SIZE case rather than failing entirely.

If ehca_is_mem_hugetlb() runs out of memory, ehca_reg_mr() is rather 
unlikely to get the memory, but it's worth a try, I'll give you that. I'll 
make the umem patch work that way.

Joachim
