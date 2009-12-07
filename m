Return-Path: <linux-kernel-owner+w=401wt.eu-S934844AbZLGMVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934844AbZLGMVx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 07:21:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934809AbZLGMVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 07:21:51 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42544 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757044AbZLGMVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 07:21:49 -0500
Date: Mon, 7 Dec 2009 12:23:46 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: miklos@szeredi.hu, luto@mit.edu, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] vfs: new O_NODE open flag
Message-ID: <20091207122346.6d18a8e1@lxorguk.ukuu.org.uk>
In-Reply-To: <E1NHWlu-00029N-1t@pomaz-ex.szeredi.hu>
References: <E1NFrsv-0000mE-2L@pomaz-ex.szeredi.hu>
	<20091202191549.1dbffa2e@lxorguk.ukuu.org.uk>
	<E1NFva6-0001AI-0J@pomaz-ex.szeredi.hu>
	<20091202204828.4fa0c108@lxorguk.ukuu.org.uk>
	<E1NG4WJ-00026r-GE@pomaz-ex.szeredi.hu>
	<4B1A7159.3070101@mit.edu>
	<E1NH0Ub-0007oy-43@pomaz-ex.szeredi.hu>
	<20091205202838.3456b6fc@lxorguk.ukuu.org.uk>
	<E1NH1MB-0007v8-Ps@pomaz-ex.szeredi.hu>
	<20091205231304.03a4af61@lxorguk.ukuu.org.uk>
	<E1NHWlu-00029N-1t@pomaz-ex.szeredi.hu>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The standard udev unload is a true open barrier so has an implicit
revoke() caused by the fact you cannot keep a handle to the filename open
during the udev sequence (or the old driver would be pinned by a refcount
and not unload).

This isn't about hard links, its about object and handle lifetimes.
Ownership is also involved in the case of things like a tty device (so if
you can fchmod down the handle you can break the security model).

It only works because you have a true revoke (by virtue of refcounting in
the kernel driver modules)

Alan
