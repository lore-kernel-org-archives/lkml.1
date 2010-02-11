Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882Ab0BKBtM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 20:49:12 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:25786 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754865Ab0BKBtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 20:49:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type;
        b=OyWg28eqxxyl8qEIZc2fo4XmH2HPKpaADxA2CyTa15WL30htFByxDts3iy7QLJd2nM
         B5HZ4Ffd2yT0DDX5SwXXgoJYJphpygpukVjF+DYXM0YJgVQRyEcGJcNJAC3o42txC9r/
         fxTVcjjI4aiNwYS+4ZPxyWXJRliRsdQQ1AUi8=
MIME-Version: 1.0
In-Reply-To: <dfb03c971002101202i37f4a243jc6bfb44bc853cb5d@mail.gmail.com>
References: <dfb03c971002101202i37f4a243jc6bfb44bc853cb5d@mail.gmail.com>
From: Alexander Lam <lambchop468@gmail.com>
Date: Wed, 10 Feb 2010 20:48:49 -0500
Message-ID: <dfb03c971002101748i39d7de0bw83634c40f058de0f@mail.gmail.com>
Subject: Re: mtrr cleanup not doing anything on 2.6.33-rc7
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 10, 2010 at 3:02 PM, Alexander Lam <lambchop468@gmail.com> wrote:
>
> My kernel config has the following:
> CONFIG_MTRR=y
> CONFIG_MTRR_SANITIZER=y
> CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
> CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
>
> With previous kernels, dmesg would show that the sanitizer was indeed
> cleaning up the mtrrs [1]
>
> but now, with 2.6.33-rc7 there is no indication that this is occuring,

For those who run across this later,

Found out that commit 508d85c2c6bc8cba53d2a54d9a306ad64a0a80bf,
   x86: When cleaning MTRRs, do not fold WP into UC

causes mtrr cleanup not to run on my machine.

Probably not worth fixing because the i915 error message is harmless.
