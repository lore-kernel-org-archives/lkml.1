Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933611Ab0CKT2G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 14:28:06 -0500
Received: from mail-fx0-f227.google.com ([209.85.220.227]:48329 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758102Ab0CKT2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 14:28:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=uHxhgv5IvrKfuaAZr5Tu/UQ+TSDwmwLsqvjw4cK8JoCgsddsfoSNFaDvLVMT4XL0EG
         Tx525SXZImWZ137lhGNqy14s/FqyvA1k9iPe7C40DQvVXCDcO0CwBYwoDhTowWJVWp2c
         m1vJK4dT98b/XQoNf6aC0YzmRPibe95VolK2w=
Date: Thu, 11 Mar 2010 20:27:12 +0100
From: Paolo Ornati <ornati@gmail.com>
To: Anca Emanuel <anca.emanuel@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.24 Through Linux 2.6.33 Benchmarks
Message-ID: <20100311202712.58e4d444@gmail.com>
In-Reply-To: <c1fb08351003101034h17957f4ele0a6cbec085fc434@mail.gmail.com>
References: <c1fb08351003101034h17957f4ele0a6cbec085fc434@mail.gmail.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Mar 2010 20:34:12 +0200
Anca Emanuel <anca.emanuel@gmail.com> wrote:

> In fact, the Linux 2.6.30 kernel
> was 770% faster than its predecessor was and it remained that way with
> the Linux 2.6.31 kernel and then regressed only slightly with the
> Linux 2.6.32 kernel. With the new Linux 2.6.33 kernel, however, the
> PostgreSQL performance atop the EXT3 file-system has fallen off a
> cliff.

The extra performance was just a "bug":

http://www.mail-archive.com/pgsql-performance@postgresql.org/msg34841.html

"[This change] is required for safe behavior with volatile write caches
on drives. You could mount with -o nobarrier and [the performance drop]
would go away, but a sequence like write->fsync->lose power->reboot may
well find your file without the data that you synced, if the drive had
write caches enabled. If you know you have no write cache, or that it
is safely battery backed, then you can mount with -o nobarrier, and not
incur this penalty."

-- 
	Paolo Ornati
	Linux 2.6.33-00001-gbaac35c on x86_64
