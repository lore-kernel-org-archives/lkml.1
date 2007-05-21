Return-Path: <linux-kernel-owner+w=401wt.eu-S1759413AbXEUMun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759413AbXEUMun (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 08:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755280AbXEUMug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 08:50:36 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:54979 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755097AbXEUMuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 08:50:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=XwF/pym/8wqSaXtnIYRJdJUiD8Cny+pHmKdDDHFQqMwR+fLCPCGjHbwRvlXzpOnL3/5z1uu0Un3R6w2qN6P2rOSeP7krw2zkJFWbtOEjhfS0BflcZ0MnsApLeIsRj9InKUpu3BAZAASKoOPvC4SpN84z/bPHugl+PyayWYA9gGA=
Message-ID: <84144f020705210550v1694fe74md8e19958bf2cf891@mail.gmail.com>
Date: Mon, 21 May 2007 15:50:32 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Hennerich, Michael" <Michael.Hennerich@analog.com>
Subject: Re: [PATCH 12/32] Blackfin arch: Fix bug using usb keyboard crashes kernel
Cc: "Bryan Wu" <bryan.wu@analog.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <84144f020705210514y396f6e67r57b86362a10f44f1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <600D5CB4DFD93545BF61FF01473D11AC0B174C8F@limkexm2.ad.analog.com>
	 <84144f020705210514y396f6e67r57b86362a10f44f1@mail.gmail.com>
X-Google-Sender-Auth: ab40b62a1fae901c
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/21/07, Hennerich, Michael <Michael.Hennerich@analog.com> wrote:
> With CONFIG_VT (drivers/char/vt.c) enabled and a USB HID keyboard connected,
> we were seeing bad pointer dereferences in drivers/char/keyboard.c
>
> In function kbd_keycode vc_cons[fg_console].d was un-initialized.

On 5/21/07, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> Makes sense. Please consider adding this to the changelog. Thanks.

I am not an expert on this, but I don't see how vc_cons[fg_console].d
would be uninitialized. It is always set in
drivers/char/vt.c:con_init() and drivers/char/vt.c:vc_allocate(). The
conswitchp change affects vc->vc_sw but I don't see that being used in
drivers/char/keyboard.c:kbd_keycode() except indirectly via
set_console et al.

Perhaps I am missing something here?
