Return-Path: <linux-kernel-owner+w=401wt.eu-S1756592AbYHHA13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592AbYHHA13 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 20:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753838AbYHHA1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 20:27:21 -0400
Received: from outbound-mail-156.bluehost.com ([67.222.39.36]:53558 "HELO
	outbound-mail-156.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753481AbYHHA1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 20:27:20 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=uIOF9x0T8sb4popzF6wH7TysGpEmwnLJy+QnnLetrkNlb9HRd+h2TRSzTKqg3Fcz0NxBpGlLkwN5sZE8QU7oC69NvJtTPsEcxPnQ3CgU1ufbup1MZMgL9hpCFGDC0D2A;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
Subject: Re: T60p not coming out of suspend to RAM since 2.6.27-rc1
Date: Thu, 7 Aug 2008 17:27:12 -0700
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, matthew@wil.cx
References: <20080807232819.GA7984@google.com>
In-Reply-To: <20080807232819.GA7984@google.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808071727.13317.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 7, 2008 4:28 pm Michael S. Tsirkin wrote:
> In both 2.6.27-rc1 and 2.6.27-rc2, my laptop won't come out of
> suspend to ram: it blinks the crescent one or twice,
> and hangs. It does resume fine under 2.6.26.
>
> I bisected the problem and got the following commit:
>
> commit ce6fce4295ba727b36fdc73040e444bd1aae64cd
> Author: Matthew Wilcox <matthew@wil.cx>
> Date:   Fri Jul 25 15:42:58 2008 -0600
>
>     PCI MSI: Don't disable MSIs if the mask bit isn't supported
>
>     David Vrabel has a device which generates an interrupt storm on the
> INTx pin if we disable MSI interrupts altogether.  Masking interrupts is
> only a performance optimisation, so we can ignore the request to mask the
> interrupt.
>
>     Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
>     Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
>
> Reverting ce6fce4295ba727b36fdc73040e444bd1aae64cd
> fixes resume from suspend to RAM for me.
>
> Steps to reproduce:
>
> Press Fn-F4 to suspend, press Fn to resume.
> This works on 2.6.26, hangs on vanilla 2.6.27-rc1
> and 2.6.27-rc2, works on 2.6.27-rc2 with reverted ce6fce..
>
> Bug added to bugzilla: http://bugzilla.kernel.org/show_bug.cgi?id=11283

I noted in the bug that I think this is a duplicate.  Can you try pulling my
for-linus branch into your tree to see if it fixes things for you?

git pull git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6.git for-linus

from inside your kernel tree should do it.

Thanks,
Jesse
