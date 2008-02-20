Return-Path: <linux-kernel-owner+w=401wt.eu-S1752658AbYBTLYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbYBTLYa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 06:24:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751119AbYBTLYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 06:24:20 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36720 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089AbYBTLYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 06:24:19 -0500
Message-ID: <47BC0DA9.1030607@redhat.com>
Date: Wed, 20 Feb 2008 12:23:21 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>,
       Alasdair G Kergon <agk@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       dm-crypt@saout.de
Subject: Re: 2.6.25-rc[1,2]: failed to setup dm-crypt key mapping
References: <8f53421d0802192343v2267cb66ub579d4503e3b7eb1@mail.gmail.com>
In-Reply-To: <8f53421d0802192343v2267cb66ub579d4503e3b7eb1@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael S. Tsirkin wrote:
> I am booting a thinkpad T60p off of an encrypted disk (with crypto
> modules in initramfs).
> This works fine in 2.6.24, but in both 2.6.25-rc1 and 2.6.25-rc2
> won't boot with the following messages on the console
> (copied by hand, sorry about typos):
>         device-mapper: table: 254:0:crypt
>         Error allocating crypto tfm
>         Failed to setup dm_crypt key mapping.
>         check kernel for support for the aes-cbc-essiv:sha256
>         cipher spec and verify that /dev/sda6 contains at least 133 sectors.
>         Failed to read from storage.
> 
> git bisec points to the following commit:
> 
>         commit 3a7f6c990ad04e6f576a159876c602d14d6f7fef
>         dm crypt: use async crypto
> 
> Reverting commit 3a7f6c990ad04e6f576a159876c602d14d6f7fef
> on top of 2.6.25-rc2 results in a bootable configuration for me.
> 
> .config attached.

It seems that some module dependency was lost, 
dm-crypt with async crypto depends now on crypto_blkcipher module
for this configuration.

Herbert, any following change required for dm-crypt or it is only
crypto subsystem issue?
(With old kernel/dm-crypt it loads "blkcipher" not "crypto_blkcipher",
maybe some initramdisk change required too...)

Milan
--
mbroz@redhat.com

