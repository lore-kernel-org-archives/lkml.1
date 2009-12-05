Return-Path: <linux-kernel-owner+w=401wt.eu-S932714AbZLEACo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932714AbZLEACo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 19:02:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932612AbZLEACn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 19:02:43 -0500
Received: from outbound-mail-138.bluehost.com ([67.222.39.28]:48338 "HELO
	outbound-mail-138.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932654AbZLEACj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 19:02:39 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Yzb9+u8Y6XVcWRJ/0JHXeJhL8ebm38NmdhoptR2YKoTzHJp0VNuRfY/xgcEn41FH1xFvGUOZCHOJ13MLDy/ajx4YeZTznAUMjNJ/T6hvK8hJp0hMNjmFsg+KUNSjz5Qd;
Date: Fri, 4 Dec 2009 16:01:58 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alex Williamson <alex.williamson@hp.com>
Cc: yinghai@kernel.org, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, alex.williamson@hp.com
Subject: Re: [PATCH v2] PCI: Always set prefetchable base/limit upper32
 registers
Message-ID: <20091204160158.1b591cb1@jbarnes-piketon>
In-Reply-To: <20091130214954.10845.23072.stgit@debian.lart>
References: <20091130214954.10845.23072.stgit@debian.lart>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Nov 2009 14:51:44 -0700
Alex Williamson <alex.williamson@hp.com> wrote:

> Prior to 1f82de10 we always initialized the upper 32bits of the
> prefetchable memory window, regardless of the address range used.
> Now we only touch it for a >32bit address, which means the upper32
> registers remain whatever the BIOS initialized them too.
> 
> It's valid for the BIOS to set the upper32 base/limit to
> 0xffffffff/0x00000000, which makes us program prefetchable ranges
> like 0xffffffffabc00000 - 0x00000000abc00000
> 
> Revert the chunk of 1f82de10 that made this conditional so we always
> write the upper32 registers and remove now unused pref_mem64 variable.
> 
> Signed-off-by: Alex Williamson <alex.williamson@hp.com>
> ---
> 

Applied this one, though it looks like your diff had some context that
wasn't in my tree.  Please double check that I fixed it up correctly.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
