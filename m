Return-Path: <linux-kernel-owner+w=401wt.eu-S1753189AbZEINqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbZEINqP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 09:46:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751684AbZEINp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 09:45:57 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:64011 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbZEINp5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 09:45:57 -0400
MIME-Version: 1.0
In-Reply-To: <1241828002-12742-2-git-send-email-tj@kernel.org>
References: <1241828002-12742-1-git-send-email-tj@kernel.org> 
	<1241828002-12742-2-git-send-email-tj@kernel.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Sat, 9 May 2009 15:45:36 +0200
Message-ID: <ac3eb2510905090645u5e482ffcu4b3ddc26e81247e6@mail.gmail.com>
Subject: Re: [PATCH 1/3] block: add alt_size
To: Tejun Heo <tj@kernel.org>
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       James.Bottomley@hansenpartnership.com, Mauelshagen@redhat.com,
       dm-devel@redhat.com, dan.j.williams@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 9, 2009 at 02:13, Tejun Heo <tj@kernel.org> wrote:
> This patch adds alt_size to genhd and exports it via sysfs.  alt_size
> is always smaller than the regular size.  Being a hint, alt_size can
> also be set from userland by writing to the sysfs node mostly for
> debugging and testing.

What does "alt_" stand for? I think that should be more descriptive in
an exported interface.

And can we please keep the "size_*" in front of the name, so that they
group together?

Also, values with magic block counts, while there is no way to get the
blocksize with the same interface, are pretty weird. I think the
current "size" attribute is just a bug.
Not sure, how that should be solved, by adding a "blocksize" attribute
that is always in the same context as the current "size*" values, or
by just using bytes for new attributes here.

Almost all tools I've seen using these attributes, have hardcoded *
512 in there, which may cause trouble pretty soon. And this is mostly
a failure of the interface and not of the users, I think.

Thanks,
Kay
