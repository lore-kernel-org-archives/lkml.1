Return-Path: <linux-kernel-owner+w=401wt.eu-S1423223AbXBHLdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423223AbXBHLdY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 06:33:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423229AbXBHLdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 06:33:24 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:10516 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423223AbXBHLdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 06:33:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pY/cQA5RUXrnkLYZHuTTIIKjWLMpOzBnZwcN1nJ9hDfofZB+jM1gHX0UKMxZ2n/0Ro4PEOCIK7YpbVHynOBvHSQJLVMQ/65J3KzdVfy8x5r3WcrYRZLZ6zRcVXIqccH1FUmODUENjWiSRlDq2YXtHL1ORujE18tXqvtvYlSn5yM=
Message-ID: <b6fcc0a0702080333q12bd7493y227ef92e5273a664@mail.gmail.com>
Date: Thu, 8 Feb 2007 14:33:22 +0300
From: "Alexey Dobriyan" <adobriyan@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [patch] export ufs_fs.h to userspace
Cc: "Mike Frysinger" <vapier@gentoo.org>, dushistov@mail.ru,
       linux-kernel@vger.kernel.org, sparc@gentoo.org
In-Reply-To: <1170930819.8675.36.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200702080246.16996.vapier@gentoo.org>
	 <1170930819.8675.36.camel@laptopd505.fenrus.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/8/07, Arjan van de Ven <arjan@infradead.org> wrote:
> On Thu, 2007-02-08 at 02:46 -0500, Mike Frysinger wrote:
> > was ufs_fs.h purposefully not exported to userspace or did it just slip
> > through the cracks ?  assuming the latter scenario, the attached patch
> > touches up the relationship between ufs_fs.h and its sub headers (like
> > ufs_fs_sb.h) so that we can export it ... the silo bootloader takes
> advantage
> > of this header for example
>
>
> are you sure it actually uses anything from this header, and not just
> assumes the magic number to be there??
> (also.. I kind of would think it reasonable for things with their own
> UFS fs reader to have their own header)

ufs_fs.h certainly has things which certain types of userspace
programs could use:
on-disk layouts of UFS(2) inodes, cylinder groups, ... So it should be exported.

However, NAK patch in this form until all kernel internal things would
dissapear from
exported header: struct ufs_buffer_head, ufs_sb_private_info. Probably something
else, I haven't looked closely.
