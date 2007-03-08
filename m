Return-Path: <linux-kernel-owner+w=401wt.eu-S1752185AbXCHBuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185AbXCHBuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 20:50:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbXCHBuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 20:50:09 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:17771 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185AbXCHBuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 20:50:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dDwd7IyDHbp0AmYqiF5F6huOCedB4xkjEeDJL7M4QxIuyUYTz3DOj+XsYjcD0q/bTA+5ADHBZuYsXwqAa+PZyTWG/oWMO+toUE1HoZhbaPeL0iWpf487Q0IjAJJCC+gEhin10ytmU9386o9WM1HY6oqeixj2y69QIuSQyFgokc8=
Message-ID: <f2b55d220703071750h1a47c432ife7f39c575a4303c@mail.gmail.com>
Date: Wed, 7 Mar 2007 17:50:05 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: f_owner.lock and file->pos updates
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070308004853.4f5a090c@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f2b55d220703071117n474f02f7rcc630f0415530aed@mail.gmail.com>
	 <20070308004853.4f5a090c@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/7/07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> The right way IMHO would be to do the work that was done for pread/pwrite
> and implement preadv/pwritev. The moment you want to do atomic things
> with the file->f_pos instead of doing it with a local passed pos value it
> gets ugly.. why do you need to do it with f_pos ?

I didn't see any clean way to intersperse overwrites and appends to a
record-structured file without using vfs_llseek, which steps on f_pos.
 Actually, we may already have a problem with append races in
sys_write/sys_writev.  If it's possible for two threads to write() to
the same file in different threads (both intending to append), they
may wind up passing the same "pos" value into vfs_write().  Or does
fget_light/fput_light do some sort of locking that I'm not seeing?

Cheers,
- Michael
