Return-Path: <linux-kernel-owner+w=401wt.eu-S1759524AbZEMK2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759524AbZEMK2X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 06:28:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758542AbZEMK2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 06:28:14 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:1929 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbZEMK2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 06:28:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=mwW3F2wq+WxFORySl7t7QLrEbFvGX4wRIDTjNP50bPrfgEkTHDM90LSqF3gDnzIBaH
         V5F4O6JxNRFTP+QWbzjRh3zIkzl3dthZVpvBnISNt7kv99Y+Qz6K0VjPEbBn3sROFTbf
         tMpZLcVXJvTpISjjF65WConoxfhhWqTU0AEgE=
MIME-Version: 1.0
In-Reply-To: <1242155174-2513-1-git-send-email-wd@denx.de>
References: <1242155174-2513-1-git-send-email-wd@denx.de>
Date: Wed, 13 May 2009 18:28:09 +0800
X-Google-Sender-Auth: ceff1bd1a4eca50c
Message-ID: <2a27d3730905130328m27743852w2d68a62ebc32ce31@mail.gmail.com>
Subject: Re: [PATCH] [PowerPC] MPC8272ADS: fix device tree for 8 MB flash size
From: Li Yang <leoli@freescale.com>
To: Wolfgang Denk <wd@denx.de>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Scott Wood <scottwood@freescale.com>,
       Kumar Gala <galak@kernel.crashing.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 13, 2009 at 3:06 AM, Wolfgang Denk <wd@denx.de> wrote:
> The current device tree for the MPC8272ADS assumes a mapping of 32 MB
> of NOR flash at 0xFE00.0000, while there are actually only 8 MB on
> the boards, mapped at 0xFF80.0000. When booting an uImage with such a
> device tree, the kernel crashes because 0xFE00.0000 is not mapped.
>
> Also introduce aliases for serial[01] and ethernet[01].
>
> Signed-off-by: Wolfgang Denk <wd@denx.de>
> Cc: Scott Wood <scottwood@freescale.com>
> cc: Kumar Gala <galak@kernel.crashing.org>
> ---
> I am not really sure what the typical flash size on MPC8272ADS boards
> is. The board I used for testing is marked as "Prototype", so it may
> not be the release configuration. On the other hand, the manual also
> says 8 MB, Vitaly Borduk confirms 8 MB on his board, too, and Scott
> Wood eventually tested only with cuImage which fixes up the localbus
> mappings, thus eventually concealing the issue.

The latest reference board I got also has an 8MB SIMM flash module
shipped in the box.

>
> I'm posting this as reference in case the 8 MB should turn out to be
> correct. -- wd

Although 8MB seems to be the common size used.  It can be very easy
changed as a pluggable module.  It might be better to make the code
working for any reasonable flash sizes.

- Leo
