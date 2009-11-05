Return-Path: <linux-kernel-owner+w=401wt.eu-S1756226AbZKENOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbZKENOv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 08:14:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756179AbZKENOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 08:14:48 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43806 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756165AbZKENOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 08:14:46 -0500
Date: Thu, 5 Nov 2009 13:15:45 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, viro@ZenIV.linux.org.uk, dhowells@redhat.com,
       hch@infradead.org, adilger@sun.com, mtk.manpages@gmail.com,
       torvalds@linux-foundation.org, drepper@gmail.com, jamie@shareable.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 resend] vfs: new O_NODE open flag
Message-ID: <20091105131545.72b4e319@lxorguk.ukuu.org.uk>
In-Reply-To: <E1N60RV-0002ed-FX@pomaz-ex.szeredi.hu>
References: <E1N60RV-0002ed-FX@pomaz-ex.szeredi.hu>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  - re-opening normally after checking file type (there's a debate
>    whether this would have security issues, but currently we do allow
>    re-opening with increased permissions thorugh /proc/*/fd)

Which has already been demonstrated to be an (unfixed) security hole.

> Filesystems which want to install special file operations for O_NODE
> opens (e.g. ioctl) may set S_OPEN_NODE flag in the inode.  This will

Wrong way around. The defailt should be that O_NODE fails for any handle
which has not specifically added support.

It'll fill itself in where it matters pretty fast that way but cases will
get reviewed which is critical.

You also need to address the open with no permissions pinning a removable
device question.

Alan
