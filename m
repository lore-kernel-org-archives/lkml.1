Return-Path: <linux-kernel-owner+w=401wt.eu-S1753341Ab0ATKsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab0ATKsV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 05:48:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753270Ab0ATKsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 05:48:19 -0500
Received: from mail-iw0-f197.google.com ([209.85.223.197]:52413 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240Ab0ATKsS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 05:48:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=R17HTJUUZqnn5D/n4GdSUX5vEHw44ekqkB7rO+I9twwuNXmYuW0scKZlB2uXuHa6I4
         emrDgRF4lyx6AO+3PmvsjpT/twe0tJPUGZDCn+CGKFIx5lChGaCorxDMBSmcStGy1she
         QvcnhAnlLJPonvjDIcCvSwdFSaSSYLGBMPQWc=
MIME-Version: 1.0
In-Reply-To: <1263982111-24123-2-git-send-email-monstr@monstr.eu>
References: <1263982111-24123-1-git-send-email-monstr@monstr.eu>
	 <1263982111-24123-2-git-send-email-monstr@monstr.eu>
Date: Wed, 20 Jan 2010 12:48:17 +0200
Message-ID: <b6fcc0a1001200248x1a4b3cedoae90b4f1495d2358@mail.gmail.com>
Subject: Re: [PATCH] asm-generic: dma: Add BUG_ON for uninitialized dma_ops
From: Alexey Dobriyan <adobriyan@gmail.com>
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, michal.simek@petalogix.com, arnd@arndb.de,
       linux-arch@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       akpm@linux-foundation.org, mingo@elte.hu, joerg.roedel@amd.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 12:08 PM,  <monstr@monstr.eu> wrote:
> From: Michal Simek <monstr@monstr.eu>
>
> Check that dma_ops are initialized correctly. Without this
> checking you get kernel fault and you don't know where the problem is.

Oh, yes you do. PC will be of some small value.

> +       BUG_ON(!ops);
>        BUG_ON(!valid_dma_direction(dir));
>        addr = ops->map_page(dev, virt_to_page(ptr),
