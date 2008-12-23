Return-Path: <linux-kernel-owner+w=401wt.eu-S1755185AbYLWFiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185AbYLWFiT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 00:38:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751204AbYLWFiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 00:38:06 -0500
Received: from rn-out-0910.google.com ([64.233.170.188]:11050 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbYLWFiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 00:38:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=VK77im26hLpynEJ18U+5ax4zz8knkuq6+sywX30mmJWVEr3PYQuE9OsoKOaCtebqW6
         Hw/BacBU1eXUmU0h6tyNpGq74jZoiDm98QmY4atypT7ab+JrA7ucV+B4jLzRzcKpJmLV
         LDzSbIAPAUE0vHVEnvZvl1KjFE/XGud7qMfWU=
Message-ID: <73c1f2160812222138g3968afb5v20662338ea0cf5d5@mail.gmail.com>
Date: Tue, 23 Dec 2008 00:38:02 -0500
From: "Brian Gerst" <brgerst@gmail.com>
To: "Hiroshi Shimamoto" <h-shimamoto@ct.jp.nec.com>
Subject: Re: [RFC -tip 2/4] x86: uaccess: introduce __{get|put}_user exception handling framework
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
In-Reply-To: <495075B0.9020104@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <49507534.5080401@ct.jp.nec.com> <495075B0.9020104@ct.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23, 2008 at 12:22 AM, Hiroshi Shimamoto
<h-shimamoto@ct.jp.nec.com> wrote:
> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>
> Impact: introduce new framework
>
> Introduce exception handling framework.
> __{get|put}_user_ex_try() begins exception block and
> __{get|put}_user_ex_catch() ends block and if an exception occurred in this
> block using __{get|put}_user_ex, direct jump to __{get|put}_user_ex_catch()
> and err is set to specified value.

You shouldn't do this.  According to the gcc manual[1], "Speaking of
labels, jumps from one asm to another are not supported. The
compiler's optimizers do not know about these jumps, and therefore
they cannot take account of them when deciding how to optimize."

[1] http://gcc.gnu.org/onlinedocs/gcc-4.3.2/gcc/Extended-Asm.html
