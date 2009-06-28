Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645AbZF1BoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbZF1BoT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 21:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751983AbZF1BoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 21:44:10 -0400
Received: from mail-yx0-f188.google.com ([209.85.210.188]:62026 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbZF1BoJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 21:44:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CZi1d96DycwxPfWNMGv8g+f8TCTCwx7Jv6dYOVpj7SYRM4aLB44BDHWuco40cwNXfi
         x/1o5yZXhHdoOkntHHbF2LiugzCZY/hkCaJoitDPtgqKuHO0tX6ld9hN45EJ6XIUuxAq
         4S2qDXDSFIUjiz+KL5GKj951Icjt3LLzWs2jo=
MIME-Version: 1.0
In-Reply-To: <200906271852.57388.elendil@planet.nl>
References: <200906271852.57388.elendil@planet.nl>
Date: Sun, 28 Jun 2009 11:44:11 +1000
Message-ID: <21d7e9970906271844t15540ef8x57df641e87ab71fc@mail.gmail.com>
Subject: Re: [regression] drm: display arifacts when X.Org is stopped
From: Dave Airlie <airlied@gmail.com>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
       dri-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 28, 2009 at 2:52 AM, Frans Pop<elendil@planet.nl> wrote:
> With 2.6.31-rc1 I'm getting fairly serious display artifacts when X.Org
> is stopped and the display switches modes. This happens when I reboot the
> system (on the switch back to VT1), but also when I just restart the X
> server from the kdm splash screen.
>
> My text consoles use the VESA framebuffer (vga=791).
> I'm not using GEM.
>

you can't not use GEM, you can not use kernel modesetting which is
what I assume you are saying.

I'll try and reproduce this if I can, it seems quite strange. have you
> 4GB RAM btw?

Dave.

> I've bisected this to commit: 07613ba2f464f59949266f4337b75b91eb610795
>    agp: switch AGP to use page array instead of unsigned long array
>
>    This switches AGP to use an array of pages for tracking the
>    pages allocated to the GART. This should enable GEM on PAE to work
>    a lot better as we can pass highmem pages to the PAT code and it will
>    do the right thing with them.
>
>    Signed-off-by: Dave Airlie <airlied@redhat.com>
>
