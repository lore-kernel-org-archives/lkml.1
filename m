Return-Path: <linux-kernel-owner+w=401wt.eu-S1752751AbZAFNbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751AbZAFNbR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 08:31:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751831AbZAFNbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 08:31:03 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:50712 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbZAFNbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 08:31:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=oEcLI3njbBdKpHVXZ0V/ycEMBcfnezcQ/5KRkCUbdHUcT3SH2FP/0KYJTl6pini+32
         q8/lI1O+Tkm4Qd2CCU4BkcJ1Gzew46fbxZtHhdu7TEvc/peWqd5Jcj/HyS/w8Xym3Eb1
         7VPhcHPcBdlm8H3TjmbIHY+OXG4PP++j42hs4=
Message-ID: <84144f020901060530w2b7fef67j8f1f2242860df3bd@mail.gmail.com>
Date: Tue, 6 Jan 2009 15:30:59 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Ryusuke Konishi" <konishi.ryusuke@lab.ntt.co.jp>
Subject: Re: 2.6.29 -mm merge plans
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <c4a7c9420901050140u23697729pc55966110d68452b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090105004300.19ed52d1.akpm@linux-foundation.org>
	 <c4a7c9420901050140u23697729pc55966110d68452b@mail.gmail.com>
X-Google-Sender-Auth: e6082b8c507dd4f1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ryusuke,

[snip nilfs patches]

On Mon, Jan 5, 2009 at 11:40 AM, Ryusuke Konishi
<konishi.ryusuke@lab.ntt.co.jp> wrote:
>>  Dunno.   Has this been reviewed enough?
>>
>
> I'm now working to follow some comments from Chris, and
> I think nilfs should be reviewed more widely.
>
> I'll aim for the next merge window or so.

It would be nice if BUG(), BUG_ON(), and panic() calls would be
converted to proper error handling using WARN_ON() calls. The BUG()
call in nilfs_cpfile_delete_checkpoints(), for example, looks to be
triggerable from user-space via the ioctl() system call (albeit I
didn't look too closely). Furthermore, the BUG() calls in error paths
of fs/nilfs2/ioctl.c look really fishy.

On a related note, there are quite a few new ioctls there. Are they
described somewhere? Also, can they be converted to use
->unlocked_ioctl? It's bit sad that we're adding new users of BKL in
shiny new code.

                           Pekka
