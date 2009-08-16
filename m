Return-Path: <linux-kernel-owner+w=401wt.eu-S1754662AbZHPJd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662AbZHPJd7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 05:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754569AbZHPJd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 05:33:57 -0400
Received: from mba.ocn.ne.jp ([122.28.14.163]:54917 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754094AbZHPJdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 05:33:55 -0400
Date: Sun, 16 Aug 2009 18:33:55 +0900 (JST)
Message-Id: <20090816.183355.89035427.anemo@mba.ocn.ne.jp>
To: htejun@gmail.com
Cc: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: ata_tf_read_block() question
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <4A876BC3.3020407@gmail.com>
References: <20090815.224843.240484147.anemo@mba.ocn.ne.jp>
	<4A876BC3.3020407@gmail.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Aug 2009 11:15:31 +0900, Tejun Heo <htejun@gmail.com> wrote:
> > It seems inconsistent.  The correct calculation is:
> > 	block = (cyl * dev->heads + head) * dev->sectors + sect - 1;
> > isn't it?
> 
> Yes, indeed.
> 
> > I don't have any real problem.  Just noticed by code reading.
> 
> ata_tf_read_block() currently is used only when reporting failed block
> address to upper layer so off-by-one bug there wouldn't be too
> visible, especially for the venerable CHS addressing.

Thank you for checking.

> Care to submit a patch w/ warning message and capping for sect == 0
> case?

Well, I expect fix by you (or other libata hackers) since I think you
can write better warning message and changelog than me ;)

---
Atsushi Nemoto
