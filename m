Return-Path: <linux-kernel-owner+w=401wt.eu-S933664AbYEUJmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933664AbYEUJmu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 05:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760584AbYEUJmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 05:42:22 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:34017 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759533AbYEUJmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 05:42:20 -0400
Date: Wed, 21 May 2008 11:42:19 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Tom Spink <tspink@gmail.com>
cc: Matthew Wilcox <matthew@wil.cx>, Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH] Introduce filesystem type tracking
In-Reply-To: <7b9198260805201408q6089a600g458dcab80b87951a@mail.gmail.com>
Message-ID: <alpine.LNX.1.10.0805211140500.15136@fbirervta.pbzchgretzou.qr>
References: <1211196126-7442-1-git-send-email-tspink@gmail.com>  <7b9198260805200606u6ebc2681o8af7a8eebc1cb96@mail.gmail.com>  <20080520134306.GA28946@ZenIV.linux.org.uk>  <20080520135732.GA30349@infradead.org>  <7b9198260805200818v687fc495nb7db5ffd6c8b6ba1@mail.gmail.com>
  <20080520153456.GN2638@parisc-linux.org>  <7b9198260805200836q6b9ad5f0x3b42c8f6c933fa21@mail.gmail.com> <7b9198260805201408q6089a600g458dcab80b87951a@mail.gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday 2008-05-20 23:08, Tom Spink wrote:
>
>I *think* I may have got it right, but please, let me know what you
>think!  The only thing that I think may be wrong with this patch is
>the
>spin_lock/unlock at the end of sget, where the superblock is
>list_add_tailed into the super_blocks list.  I believe this opens the
>possibility for the same superblock being list_add_tailed twice... can
>anyone else see this code-path, and is it a problem?
>
>+	mutex_lock(&type->fs_supers_lock);
>+	if (list_empty(&type->fs_supers) && type->init) {
>+		err = type->init();
>+		if (err) {

The filesystem may want to have the superblock passed.
Well, will see once a filesystem has the need for it.

