Return-Path: <linux-kernel-owner+w=401wt.eu-S1754677Ab0AYStr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677Ab0AYStr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 13:49:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753647Ab0AYStq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 13:49:46 -0500
Received: from outbound-mail-313.bluehost.com ([67.222.54.6]:39960 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753441Ab0AYStp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 13:49:45 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=neSUybiaRprsInJO0mnvP7jocxy1HF5BBl/jl+GC/wdUTEkFJxMco+PDVvrEt0YyOvqUYTCd8MAp8itAfPmuYnsHWFs4oGoXV9zAzkCsygD2rvOfPcx1uSMksotpmA04;
Date: Mon, 25 Jan 2010 10:49:38 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       dri-devel@lists.sourceforge.net, Eric Anholt <eric@anholt.net>,
       airlied@linux.ie
Subject: Re: [PATCH] PM / i915: Skip kernel VT switch during suspend/resume
 if KMS is used
Message-ID: <20100125104938.6b34d61c@jbarnes-piketon>
In-Reply-To: <20100125184350.0fbad233@lxorguk.ukuu.org.uk>
References: <201001240055.59479.rjw@sisk.pl>
	<20100125103525.2b766b9c@jbarnes-piketon>
	<20100125184350.0fbad233@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jan 2010 18:43:50 +0000
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > This probably belongs in the core DRM KMS code instead of the
> > driver. I can imagine that there may be some X driver code that
> > still needs to be executed on suspend/resume for some drivers, so
> > this may introduce bugs, but it's definitely the right way to go.
> 
> You can have a mix of KMS and non KMS consoles active on different
> cards. So I don't think that is the case.

I pity users with that configuration.

But in that case we should be able to disable the VT switch disable
path; we just have to check each driver as it's loaded.

-- 
Jesse Barnes, Intel Open Source Technology Center
