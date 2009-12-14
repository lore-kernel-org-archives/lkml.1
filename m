Return-Path: <linux-kernel-owner+w=401wt.eu-S1752708AbZLNXd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708AbZLNXd1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 18:33:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbZLNXd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 18:33:26 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:58306 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbZLNXdZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 18:33:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=v7+Xqm+C8fWtFM5znCgnHxif95e3tk8eatozeW0KogDxn53QqW2nxwnprgZ6jP9Vlc
         XngTRh0MM32Sc3vwO+zvQK1giJnd6kEaJyBMtuF40k7T9f9z8Rug/E4Q1eCFDXSzW53K
         fs4l/qnRfB+hZ8wluwU5DF4omSC8yms0NAufU=
MIME-Version: 1.0
In-Reply-To: <20091210135801.6325.15166.stgit@warthog.procyon.org.uk>
References: <20091210135755.6325.78149.stgit@warthog.procyon.org.uk> 
	<20091210135801.6325.15166.stgit@warthog.procyon.org.uk>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 14 Dec 2009 18:33:04 -0500
Message-ID: <8bd0f97a0912141533wc59a685r77078d60fec77f9b@mail.gmail.com>
Subject: Re: [PATCH 2/7] NOMMU: Provide per-task stack usage through /proc for 
	NOMMU
To: David Howells <dhowells@redhat.com>
Cc: lethal@linux-sh.org, jie.zhang@analog.com, stefani@seibold.net,
       gerg@snapgear.com, uclinux-dev@uclinux.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10, 2009 at 08:58, David Howells wrote:
> Make it possible to get the per-task stack usage through /proc on a NOMMU
> system.  The MMU-mode routine can't be used because walk_page_range() doesn't
> work on NOMMU.
>
> It can be tested to show the stack usages of non-kernel-thread processes:
>
>        # grep "Stack usage:" /proc/*/status | grep -v "0 kB"
>        /proc/1/status:Stack usage:     2 kB
>        /proc/57/status:Stack usage:    3 kB
>        /proc/58/status:Stack usage:    1 kB
>        /proc/59/status:Stack usage:    3 kB
>        /proc/60/status:Stack usage:    5 kB
>        /proc/self/status:Stack usage:  1 kB
>
> I've only tested it with ELF-FDPIC, though it should work with FLAT too.

both seem to work for me.  a simple FLAT shows 1kB while one with a
2kB buffer shows 3kB.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
-mike
