Return-Path: <linux-kernel-owner+w=401wt.eu-S1753107AbZDFEsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107AbZDFEsy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 00:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750895AbZDFEsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 00:48:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37040 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750854AbZDFEso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 00:48:44 -0400
Date: Sun, 5 Apr 2009 21:46:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Jeff Haran" <jharan@Brocade.COM>
Cc: <linux-kernel@vger.kernel.org>, Doug Thompson <norsk5@yahoo.com>
Subject: Re: bug in drivers/edac/edac_core.h pci_write_bits32()
Message-Id: <20090405214619.12611ef4.akpm@linux-foundation.org>
In-Reply-To: <57AC2FA1761300418C7AB8F3EA493C9702B52DC8@HQ-EXCH-5.corp.brocade.com>
References: <57AC2FA1761300418C7AB8F3EA493C9702B52DC8@HQ-EXCH-5.corp.brocade.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc maintainer)

On Thu, 26 Mar 2009 16:54:01 -0700 "Jeff Haran" <jharan@Brocade.COM> wrote:

> 2.6.29 and previous versions seem to contain this bug which I found just
> eyeballing the code:
> 
> static inline void pci_write_bits32(struct pci_dev *pdev, int offset,
>                     u32 value, u32 mask)
> {
>     if (mask != 0xffff) {
>         u32 buf;
> 
>         pci_read_config_dword(pdev, offset, &buf);
>         value &= mask;
>         buf &= ~mask;
>         value |= buf;
>     }
> 
>     pci_write_config_dword(pdev, offset, value);
> }
> 
> I'm pretty sure that "if" statement should be:
> 
> 	if (mask != 0xffffffff) {
> 
> Please copy my email address in any response as I do not subscribe.
> 
> Thanks,

