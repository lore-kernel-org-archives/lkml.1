Return-Path: <linux-kernel-owner+w=401wt.eu-S1752341AbYIWJQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341AbYIWJQs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 05:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750954AbYIWJQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 05:16:38 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52315 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750899AbYIWJQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 05:16:37 -0400
Date: Tue, 23 Sep 2008 10:16:13 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] ext4: Use preallocation when reading from the
 inode table
Message-ID: <20080923101613.58768083@lxorguk.ukuu.org.uk>
In-Reply-To: <E1KhvsB-0002Ik-Ex@closure.thunk.org>
References: <E1KhvsB-0002Ik-Ex@closure.thunk.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2008 20:35:23 -0400
"Theodore Ts'o" <tytso@mit.edu> wrote:

> 
> With modern hard drives, reading 64k takes roughly the same time as
> reading a 4k block.  So request adjacent inode table blocks to reduce
> the time it takes when iterating over directories (especially when doing
> this in htree sort order) in a cold cache case.  With this patch, the
> time it takes to run "git status" on a kernel tree after flushing the
> caches via "echo 3 > /proc/sys/vm/drop_caches", is reduced by 21%.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

Acked-by: Alan Cox <alan@redhat.com>

I'm actually suprised that 16 is the magic tuning number you've used and
a bigger one isn't even more of a win

Alan
