Return-Path: <linux-kernel-owner+w=401wt.eu-S1752927AbZIOLLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927AbZIOLLb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 07:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752849AbZIOLLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 07:11:30 -0400
Received: from mail-yw0-f147.google.com ([209.85.211.147]:50525 "EHLO
	mail-yw0-f147.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbZIOLL3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 07:11:29 -0400
MIME-Version: 1.0
Date: Tue, 15 Sep 2009 04:02:10 -0700 (PDT)
In-Reply-To: <dkAXF-4Gg-25@gated-at.bofh.it>
X-IP: 62.172.74.16
References: <dkAXF-4Gg-25@gated-at.bofh.it>
User-Agent: G2/1.0
X-HTTP-UserAgent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.2) 
	Gecko/20090803 Ubuntu/9.04 (jaunty) Shiretoko/3.5.2,gzip(gfe),gzip(gfe)
Message-ID: <2612a5ee-4141-43d2-a009-090eac352aa2@n2g2000vba.googlegroups.com>
Subject: Re: unfair io behaviour for high load interactive use still present 
	in 2.6.31
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Tobias Oetiker <tobi@oetiker.ch>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 15, 8:50 am, Tobias Oetiker <t...@oetiker.ch> wrote:
> Experts,
>
> We run several busy NFS file servers with Areca HW Raid + LVM2 + ext3
>
> We find that the read bandwidth falls dramatically as well as the
> response times going up to several seconds as soon as the system
> comes under heavy write strain.

It's worthwhile checking:
 - that the ext3 filesystem starts at a stripe-aligned offset
 - that the ext3 filesystem was created with the correct stripe-width
and stride (chunk) size
 - due to the larger amount of memory, ext4 may be a big win (due to
delayed allocate), if you'll stay with a newer kernel
 - if you have battery backup at the right levels:
  - performance may be better mounting the ext3 filesystem with
'barrier=0'
  - performance may improve mounting 'data=writeback'

Thanks,
  Daniel
--
Daniel J Blueman
