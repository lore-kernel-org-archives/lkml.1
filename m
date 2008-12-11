Return-Path: <linux-kernel-owner+w=401wt.eu-S1758051AbYLKU2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051AbYLKU2s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 15:28:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756946AbYLKU2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 15:28:38 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56072 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756924AbYLKU2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 15:28:37 -0500
Date: Thu, 11 Dec 2008 12:27:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: jeff@garzik.org, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       jgarzik@redhat.com, a_romanescu@yahoo.co.uk, tj@kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 2/2 v2] ATA: piix, fix pointer deref on suspend
Message-Id: <20081211122712.aee1f039.akpm@linux-foundation.org>
In-Reply-To: <1228855948-22886-2-git-send-email-jirislaby@gmail.com>
References: <493E0689.6020302@garzik.org>
	<1228855948-22886-1-git-send-email-jirislaby@gmail.com>
	<1228855948-22886-2-git-send-email-jirislaby@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  9 Dec 2008 21:52:28 +0100
Jiri Slaby <jirislaby@gmail.com> wrote:

> Commit
> ata_piix: add borked Tecra M4 to broken suspend list
> introduced DMI variables checking, but they can be null, so that
> we possibly dereference null.
> 
> Check if they are null and avoid checks in that case.
> 
> Solves:
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
> IP: [<ffffffff8043da97>] piix_pci_device_suspend+0x117/0x230

This already got fixed, the nasty way.

I queued "DMI: add dmi_match".  We can later switch the piix nastyfix
over to the nicefix as a cleanup.

