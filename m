Return-Path: <linux-kernel-owner+w=401wt.eu-S1755531AbZLBTO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531AbZLBTO3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 14:14:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755494AbZLBTO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 14:14:28 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43857 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755493AbZLBTO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 14:14:27 -0500
Date: Wed, 2 Dec 2009 19:15:49 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, viro@ZenIV.linux.org.uk, dhowells@redhat.com,
       hch@infradead.org, adilger@sun.com, mtk.manpages@gmail.com,
       torvalds@linux-foundation.org, drepper@gmail.com, jamie@shareable.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] vfs: new O_NODE open flag
Message-ID: <20091202191549.1dbffa2e@lxorguk.ukuu.org.uk>
In-Reply-To: <E1NFrsv-0000mE-2L@pomaz-ex.szeredi.hu>
References: <E1NFrsv-0000mE-2L@pomaz-ex.szeredi.hu>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 1) There's a security hole with dynamicly allocated devices if
> permissions on new device are difference than on old device.
> 
> The issue is valid, but also exists if hard links are created to
> device nodes.  udev already defends against this by setting
> permissions on device to zero before unlinking it.

udev defends against it with the specific knowledge that any existing
open means the device is open and cannot be unloaded. The combination is
required (and some other happenstance properties).

For O_NODE you must implement revoke() as well and get it into tools like
udev before you are safe. I appreciate "you need revoke" is a bit like
saying "there is one small problem, you just need to reimplement a major
subsystem while you are at it", but from a security perspective I don't
see any other way to make O_NODE safe in this situation.

Alan
