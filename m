Return-Path: <linux-kernel-owner+w=401wt.eu-S1752434AbYF0JQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434AbYF0JQ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 05:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524AbYF0JQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 05:16:10 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40876 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755526AbYF0JPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 05:15:53 -0400
Date: Fri, 27 Jun 2008 09:58:16 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Benny Halevy <bhalevy@panasas.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Benny Halevy <bhalevy@panasas.com>
Subject: Re: [PATCH] usb: fix uninitialized variables in keyspan_pda
Message-ID: <20080627095816.4b9c8a2e@lxorguk.ukuu.org.uk>
In-Reply-To: <1214553534-9970-1-git-send-email-bhalevy@panasas.com>
References: <4864944B.5020601@panasas.com>
	<1214553534-9970-1-git-send-email-bhalevy@panasas.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jun 2008 10:58:54 +0300
Benny Halevy <bhalevy@panasas.com> wrote:

> The compiler (gcc 4.3.0) warns that status might be used uninitialized
> in keyspan_pda_tiocmget and keyspan_pda_tiocmset.
> 
> It is technically correct and therefore this patch initializes
> status to 0 in both cases.
> 
> Note that keyspan_pda_get_modem_info sets *value only when
> usb_control_msg returns rc > 0, otherwise it must
> return an error rc < 0, and it must never return rc == 0, hence
> a WARN_ON(rc == 0) was added in case usb_control_msg ever return 0.

That seems like overkill - and by forcing status to 0 you will hide
future gcc error catches. Far better to change the two callers to test
for > 0 not >= 0 surely ?

Alan
