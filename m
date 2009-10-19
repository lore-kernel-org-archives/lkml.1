Return-Path: <linux-kernel-owner+w=401wt.eu-S1755550AbZJSIiE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550AbZJSIiE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 04:38:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753183AbZJSIiD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 04:38:03 -0400
Received: from mail-px0-f171.google.com ([209.85.216.171]:46138 "EHLO
	mail-px0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbZJSIiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 04:38:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=L769XuBf4yrZ0oPDoQMQNJykoBHBxNBhM87i+7FtVpkOuKtvYMLtP1zuEG73PuCh+F
         TvXu0xUAa7rj+BJfkhWXpi5d/09X0k1teqGoW8D0M6sm89y/xZO/MM/ssaF+sb2r15T4
         p/SGfvikEWUxst+8yLeAXUHQ7NSzkjFPnc93o=
MIME-Version: 1.0
In-Reply-To: <1255940788.14447.7.camel@heimdal.trondhjem.org>
References: <f2201a0b0910190116w29cd5e3w1ae2c76bd677f9ed@mail.gmail.com>
	 <1255940788.14447.7.camel@heimdal.trondhjem.org>
Date: Mon, 19 Oct 2009 16:38:06 +0800
X-Google-Sender-Auth: 2d996ea0b867d96e
Message-ID: <6149e97b0910190138k5791351dmc95d9cc636aaef2f@mail.gmail.com>
Subject: Re: Question about invalidate_inode_pages2_range()
From: Peng Tao <lkml.bergwolf@gmail.com>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 19, 2009 at 4:26 PM, Trond Myklebust
<trond.myklebust@fys.uio.no> wrote:
> On Mon, 2009-10-19 at 16:16 +0800, Peng Tao wrote:
>> Hi,
>>
>> I've a question about invalidate_inode_pages2_range().
>>
>> When does invalidate_inode_pages2_range() returns -EBUSY? It locks and
>> writes back the page. Why invalidate_complete_page2() still may fail
>> due to page dirtiness?
>
> A lot of those requirements were set by NFS, which uses
> invalidate_inode_pages2() in order to invalidate the page cache when it
> detects that a file has been changed on the server (either due to an
> O_DIRECT write, or due to another client modifying the file).
>
> In such cases, you want to try to keep the dirty data by writing it out
> instead of discarding it.
Thanks for your quick response. But I have two more questions about this.
1. invalidate_inode_pages2_range() calls wait_on_page_writeback().
Does the latter actually write out the dirty page?
2. Is there any interface in the mm subsystem forces discarding a page cache?

Cheers,
Peng Tao
