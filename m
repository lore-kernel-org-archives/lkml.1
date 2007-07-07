Return-Path: <linux-kernel-owner+w=401wt.eu-S1755875AbXGGGrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875AbXGGGrd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 02:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbXGGGrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 02:47:24 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:40845 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404AbXGGGrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 02:47:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=JopVIlmu2/mLifDtBd3zeLimXAy+9zTlFID1HMWR/E5YGIgbU8+rFxlI+JPicKXGWj2y7gIWZTwKA5fxA0K/41/gzrwS6x1RgizjowHikJB+NkRulkEIixS+EnGSvL3gtUwbxnCjAwUNGMGNdDWk1kzTyXpiRn8egfsunU36k5w=
Message-ID: <468F36F5.4010803@gmail.com>
Date: Sat, 07 Jul 2007 15:47:17 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Miles Lane <miles.lane@gmail.com>
CC: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.22-rc6-mm1 -- BUG - EIP: [<c01a77a1>] sysfs_addrm_finish+0x1c2/0x226
 SS:ESP 0068:c5ff9db8
References: <a44ae5cd0707030932h16a90ca3j8ad65b7a3ec64b03@mail.gmail.com>	 <20070703094916.e60d4df7.akpm@linux-foundation.org>	 <468B3CFF.7020903@gmail.com>	 <a44ae5cd0707040036x74c82dcci12b0a3f83a27af56@mail.gmail.com>	 <468C9E74.4080606@gmail.com> <a44ae5cd0707060101g38147b2gb3d33d9903082113@mail.gmail.com>
In-Reply-To: <a44ae5cd0707060101g38147b2gb3d33d9903082113@mail.gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(restoring cc to lkml)

Hello, Miles.

Miles Lane wrote:
> With this patch applied, I can't boot at all.  I have attached an OOPS
> screenshot, since I don't have a serial debugging station set up.  I
> am leaving LKML out of the loop, because of the attachment.

Weird, that's unrelated path.  It seems sd->s_parent is NULL in
sysfs_link_sibling(), which doesn't make sense because it's being called
from sysfs_create_link() which makes sure parent_sd isn't NULL &&
sysfs_addrm_start() should have caused oops earlier as it deferences
parent_sd.

Can you please retry the test (test clean 2.6.22-rc6-mm1, apply patch,
rebuild and test)?

Thanks.

-- 
tejun
