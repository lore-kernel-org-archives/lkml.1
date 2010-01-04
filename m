Return-Path: <linux-kernel-owner+w=401wt.eu-S1754173Ab0ADXr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab0ADXr4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 18:47:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754093Ab0ADXry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 18:47:54 -0500
Received: from outbound-mail-316.bluehost.com ([67.222.54.9]:36330 "HELO
	outbound-mail-316.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754086Ab0ADXrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 18:47:53 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=fK3yTOmXcM7EtmNDhHUH3H5hznGA2BwlKoUY3ZTxMw/RJjrCJc4zeWTVbOoxfbhaRkVJdRIIJXMzQjD/X7G5uvaXgRjSPY4UPImXx4dGsiR1zIKqEsZ0HMkF3MkYTl/Q;
Date: Mon, 4 Jan 2010 15:47:48 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>
Subject: Re: [PATCH] PCI: Clean up build for CONFIG_PCI_QUIRKS unset
Message-ID: <20100104154748.2b282be6@jbarnes-piketon>
In-Reply-To: <201001022257.24701.rjw@sisk.pl>
References: <201001022257.24701.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Jan 2010 22:57:24 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Currently, drivers/pci/quirks.c is built unconditionally, but if
> CONFIG_PCI_QUIRKS is unset, the only things actually built in this
> file are definitions of global variables and empty functions (due to
> the #ifdef CONFIG_PCI_QUIRKS embracing all of the code inside the
> file).  This is not particularly nice and if someone overlooks
> the #ifdef CONFIG_PCI_QUIRKS, build errors are introduced.
> 
> To clean that up, move the definitions of the global variables in
> quirks.c that are always built to pci.c, move the definitions of
> the empty functions (compiled when CONFIG_PCI_QUIRKS is unset) to
> headers (additionally make these functions static inline) and modify
> drivers/pci/Makefile so that quirks.c is only built if
> CONFIG_PCI_QUIRKS is set.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
> 
> I thought it might be useful to do something like this.
> 
> Please let me know what you think.

Applied to my linux-next branch, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
