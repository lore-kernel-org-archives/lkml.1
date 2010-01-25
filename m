Return-Path: <linux-kernel-owner+w=401wt.eu-S1754587Ab0AYSfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab0AYSfj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 13:35:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754486Ab0AYSfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 13:35:38 -0500
Received: from outbound-mail-313.bluehost.com ([67.222.54.6]:50633 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752906Ab0AYSfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 13:35:38 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=nXXATeyFQuJNEyzHjnJpG66EQTuMxgn/DrkEUuAHFJ2Z+3uH54typvZqAt9vMkfpOp/NIELh2qnxuCKqLAMjoHsEUKnGajyGeK9+YuqyC15Mt6SnSFlyXRaO+KMScCKF;
Date: Mon, 25 Jan 2010 10:35:25 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       dri-devel@lists.sourceforge.net, Eric Anholt <eric@anholt.net>,
       airlied@linux.ie
Subject: Re: [PATCH] PM / i915: Skip kernel VT switch during suspend/resume
 if KMS is used
Message-ID: <20100125103525.2b766b9c@jbarnes-piketon>
In-Reply-To: <201001240055.59479.rjw@sisk.pl>
References: <201001240055.59479.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Jan 2010 00:55:59 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> If a non-KMS graphics driver is used, the kernel carries out a VT
> switch during suspend/resume to avoid possible problems with freezing
> X at a wrong time and to cause X to repaint everything after resume.
> 
> This is not necessary any more if the KMS is used, so skip the kernel
> VT switch during suspend/resume for i915 in the KMS mode.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
> 
> Hi,
> 
> I've been testing this patch for over a week and haven't seen a
> single problem related to it during this time.
> 
> Are there any objections to it?

This probably belongs in the core DRM KMS code instead of the driver.
I can imagine that there may be some X driver code that still needs to
be executed on suspend/resume for some drivers, so this may introduce
bugs, but it's definitely the right way to go.

Dave?

-- 
Jesse Barnes, Intel Open Source Technology Center
