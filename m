Return-Path: <linux-kernel-owner+w=401wt.eu-S1764747AbZDAQNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764747AbZDAQNX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 12:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764392AbZDAQMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 12:12:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39284 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764653AbZDAQMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 12:12:53 -0400
Message-ID: <49D3927A.2050406@zytor.com>
Date: Wed, 01 Apr 2009 09:12:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andreas Robinson <andr345@gmail.com>
CC: Alain Knaff <alain@knaff.lu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] lib: add fast lzo decompressor
References: <1238593252-3435-1-git-send-email-andr345@gmail.com> <1238593252-3435-2-git-send-email-andr345@gmail.com>
In-Reply-To: <1238593252-3435-2-git-send-email-andr345@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Robinson wrote:
> This patch adds an LZO decompressor tweaked to be faster than
> the 'safe' decompressor already in the kernel.
> 
> On x86_64, it runs in roughly 80% of the time needed by the safe
> decompressor.
> 
> This function is inherently insecure and can cause buffer overruns.
> It is only intended for decompressing implicitly trusted data, such
> as an initramfs and the kernel itself.
> 
> As such, the function is neither exported nor declared in a header.
> 

OK, I'm more than a bit nervous about that, especially since we're
trying to make the decompression functions more generic.

Furthermore, is there a specific reason you didn't implent this for the
kernel itself as well as for the initramfs?  I'd really would strongly
prefer if the two compression sets didn't diverge.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

