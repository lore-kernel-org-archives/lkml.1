Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab0CCNpj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 08:45:39 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:50520 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177Ab0CCNph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 08:45:37 -0500
Date: Wed, 3 Mar 2010 13:45:33 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Joey Lee <jlee@novell.com>
Cc: mzxreary@0pointer.de, gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 58/62] msi-laptop: Support some MSI 3G netbook that is
	need load SCM
Message-ID: <20100303134533.GA28349@srcf.ucam.org>
References: <4B8E85AC020000230001413A@novprvlin0050.provo.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B8E85AC020000230001413A@novprvlin0050.provo.novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 02, 2010 at 09:52:12PM -0700, Joey Lee wrote:

> I developed this driver on 2.6.31 kernel, and I found this key code is
> in 2.6.33 kernel and later.
> There have one and only one scancode to control 3 devices when end user
> press fn+f11 key on MSI N034.
> Currently, we setup this mapping in HAL key and mapping it to KEY_WLAN.

Ah! The key comes through the keyboard controller? In that case, yeah, 
just map it to KEY_RFKILL in hal isntead of KEY_WLAN. Everything should 
work fine then. If rfkill-input is configured, it'll kill all the 
radios. If userland claims it instead, it can cycle through with 
whatever policy is desired.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
