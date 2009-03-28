Return-Path: <linux-kernel-owner+w=401wt.eu-S1762159AbZC1AZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762159AbZC1AZ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 20:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754967AbZC1AZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 20:25:14 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:2969 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289AbZC1AZN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 20:25:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cjv74/hQh1saun3D44oe7NO7SzlVzG2kGLJAJ/Wcb8GCDBnnq5QE1iAVCKDmOVcRjj
         YNbQ2Kq4YWfbx4jTlDh3yfQJlxiQqQOAJAoZ8ZxOhmXLudwKhPvh+ssjAE+yCHypZ6P4
         o7i3Zj9pZLLR3pyexMAwtI3PklC78oikoDHHM=
MIME-Version: 1.0
In-Reply-To: <49CD6BCC.6080602@garzik.org>
References: <1238185471-31152-1-git-send-email-tytso@mit.edu> 
	<1238187031.27455.212.camel@think.oraclecorp.com> <1238187818.27455.217.camel@think.oraclecorp.com> 
	<20090327213052.GC5176@mit.edu> <20090327215454.GH31071@duck.suse.cz> 
	<20090327230902.GG5176@mit.edu> <49CD6BCC.6080602@garzik.org>
Date: Fri, 27 Mar 2009 17:24:54 -0700
Message-ID: <72dbd3150903271724n5e7900a5j2486707565cd9d74@mail.gmail.com>
Subject: Re: [PATCH 0/3] Ext3 latency improvement patches
From: David Rees <drees76@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
       Chris Mason <chris.mason@oracle.com>, Ric Wheeler <rwheeler@redhat.com>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       Ext4 Developers List <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 27, 2009 at 5:14 PM, Jeff Garzik <jeff@garzik.org> wrote:
> Theodore Tso wrote:
>> OTOH, the really big databases will tend to use direct I/O, so they
>> won't be dirtying the page cache anyway.  So maybe it's not worth the
>
> Not necessarily...  From what I understand, a lot of the individual
> low-level components in cloud storage, such as GoogleFS's chunk server[1] do
> not bypass the page cache, even though they do care about the details of
> data caching and data consistency.

PostgreSQL does not use direct I/O, either (except for the
write-ahead-logs which are written sequentially and only get read
during database recovery).  I'm sure that most of MySQL's database
engines, also don't.

-Dave
