Return-Path: <linux-kernel-owner+w=401wt.eu-S1755546AbZJKOLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546AbZJKOLj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 10:11:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755221AbZJKOLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 10:11:39 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:57422 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755146AbZJKOLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 10:11:38 -0400
From: Oliver Neukum <oliver@neukum.org>
To: John Kacur <jkacur@redhat.com>
Subject: Re: [PATCH] sound_core.c: Remove BKL from soundcore_open
Date: Sun, 11 Oct 2009 16:12:40 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.31-rc9-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Jonathan Corbet <corbet@lwn.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Vincent^M^J Sanders" <vince@simtec.co.uk>, Ingo Molnar <mingo@elte.hu>
References: <alpine.LFD.2.00.0910110123510.4921@localhost.localdomain> <20091011113317.GA4901@nowhere> <alpine.LFD.2.00.0910111437270.3587@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0910111437270.3587@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Message-Id: <200910111612.41717.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n9BEET16012820

Am Sonntag, 11. Oktober 2009 14:41:15 schrieb John Kacur:> @@ -576,8 +576,6 @@ static int soundcore_open(struct inode *inode, struct> file *file) struct sound_unit *s;>         const struct file_operations *new_fops = NULL;>  > -       lock_kernel ();> ->         chain=unit&0x0F;>         if(chain==4 || chain==5)        /* dsp/audio/dsp16 */>         {> @@ -631,17 +629,17 @@ static int soundcore_open(struct inode *inode, struct> file *file) file->f_op = new_fops;>                 spin_unlock(&sound_loader_lock);>                 if(file->f_op->open)> +                       lock_kernel();>                         err = file->f_op->open(inode,file);> +                       unlock_kernel();>                 if (err) {>                         fops_put(file->f_op);>                         file->f_op = fops_get(old_fops);
Is that just me, or is file->f_op unguarded in this version?
	Regards		Oliver
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
