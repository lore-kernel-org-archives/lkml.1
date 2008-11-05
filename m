Return-Path: <linux-kernel-owner+w=401wt.eu-S1755430AbYKEJFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430AbYKEJFR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 04:05:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754210AbYKEJE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 04:04:56 -0500
Received: from fk-out-0910.google.com ([209.85.128.190]:51751 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124AbYKEJEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 04:04:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent:from;
        b=hffDb3xsZ5k4S9RIuV9AqLHj7SVAoZ+ZKU09Mx1LB8eUUkFvGq8xIH4J41lGiSc6G3
         REgzuxdb5ak7BIy3Q+pB3Mv20m9Z45ALTNGSyvd5GY3iB7SeO5FTkU8DaKhYook3aI5S
         iV+D3Tw1WNIVqiGqN6/oYA0OdJMV9yZ7jjYDQ=
Date: Wed, 5 Nov 2008 10:04:50 +0100
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Subject: [PATCH] block: fix __blkdev_get() for removable
	devices
Message-ID: <20081105090449.GA9269@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, Tejun Heo <tj@kernel.org>,
	axboe@kernel.dk, bzolnier@gmail.com, linux-ide@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20081029071319.GA9205@gollum.tnic> <20081101201419.GA29462@gollum.tnic> <490F1AC6.8000109@kernel.org> <9ea470500811030956k209b2f2ci10bcde1ea4ac7334@mail.gmail.com> <490FCC87.1070205@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <490FCC87.1070205@kernel.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2008 at 01:16:07PM +0900, Tejun Heo wrote:
> Commit 0762b8bde9729f10f8e6249809660ff2ec3ad735 moved disk_get_part()
> in front of recursive get on the whole disk, which caused removable
> devices to try disk_get_part() before rescanning after a new media is
> inserted, which might fail legit open attempts or give the old
> partition.
> 
> This patch fixes the problem by moving disk_get_part() after
> __blkdev_get() on the whole disk.
> 
> This problem was spotted by Borislav Petkov.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: <Borislav Petkov> petkovbb@googlemail.com
> ---
> Borislav, can you please verify this patch?  Thanks.

Yep, it works. Thanks.

Tested-by: Borislav Petkov <petkovbb@gmail.com>

-- 
Regards/Gruss,
    Boris.
