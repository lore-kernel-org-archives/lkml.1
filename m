Return-Path: <linux-kernel-owner+w=401wt.eu-S1754405AbZC2Vcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405AbZC2Vcd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 17:32:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751119AbZC2VcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 17:32:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56979 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbZC2VcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 17:32:14 -0400
Message-ID: <49CFE7E0.80500@zytor.com>
Date: Sun, 29 Mar 2009 14:28:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Joe Damato <ice799@gmail.com>
CC: linux-x86_64@vger.kernel.org, w@1wt.eu, mingo@elte.hu, jeremy@goop.org,
       linux-newbie@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86: Add getter/setter static inlines for x86 descriptors
References: <cover.1238361501.git.ice799@gmail.com> <76c37743d20e5737eadc747cbdddbc2beb11f074.1238361501.git.ice799@gmail.com>
In-Reply-To: <76c37743d20e5737eadc747cbdddbc2beb11f074.1238361501.git.ice799@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Damato wrote:
> Static inline getters/setters have been provided to encourage consumers not to touch the internals of 32bit x86 descriptors directly.
> 
> Signed-off-by: Joe Damato <ice799@gmail.com>

Okay, what is the motivation for this?

This is a serious question.  The x86 descriptors are so complex that
it's not clear to me that this restriction makes the code any more
clear.  Especially not with things like:

-		cpu->arch.gdt[i].b |= 0x00000100;
+		desc_set_hi(tmp,  desc_get_hi(tmp) | 0x00000100);

This isn't an improvement.  If you're doing to so something like this,
you need to actually implement the *intent* here.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

