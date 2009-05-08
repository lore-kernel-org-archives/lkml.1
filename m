Return-Path: <linux-kernel-owner+w=401wt.eu-S1764424AbZEHXUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764424AbZEHXUf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 19:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753118AbZEHXUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 19:20:23 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:50417 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954AbZEHXUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 19:20:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vDvezV0pUqerIUhrS+GwkipEqOYlKSF8f8yO5q008MWlLttZBNhpw4VZwG+J4MwCqs
         x5XC7JUw0CV3M6jAaBFWElvx444zKwD7E6iz7IBITm99aeUwPlVU5mvT5bzy+jXSj9FX
         o+TNkCt1fu3TU4NOOEY+mwZ+UeJmgVH/WGLzw=
MIME-Version: 1.0
In-Reply-To: <1241632963-25601-1-git-send-email-linville@tuxdriver.com>
References: <20090506064513.GA7460@kroah.com>
	 <1241632963-25601-1-git-send-email-linville@tuxdriver.com>
Date: Sat, 9 May 2009 00:20:19 +0100
Message-ID: <3ace41890905081620h10d0250eq1ede9cd73021dc5b@mail.gmail.com>
Subject: Re: [RFT] rtl8187: use DMA-aware buffers with usb_control_msg
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Greg KH <greg@kroah.com>,
       Eric Valette <eric.valette@free.fr>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 6, 2009 at 7:02 PM, John W. Linville <linville@tuxdriver.com> wrote:
> This definitely needs to fail more gracefully in the event of a
> kmalloc failure...
>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

I am  using this patch with compat-wireless with
2.6.29.2-134.fc11.x86_64 - presumably one needs to be using 2.6.30-rcX
to see any problems?

We mostly inherited that code concerned (and its style) from the vendor driver.

On Wed, May 6, 2009 at 7:45 AM, Greg KH <greg@kroah.com> wrote:

> Also it looks like rtl8225_write_8051() is incorrect.  You are passing a
> pointer to a variable that was passed as an argument.  I don't know
> where that is supposed to be on, somewhere on the stack I guess.
>
> Larry, care to fix this up?

I think John's patch resolves this issue to the extent it can -
rtl8225_write_8051() is called by rtl8225_write() which in turns gets
its input mostly in the form of magic contants (except a few
instances). So allocating a buffer and copying the magic contants in,
just before calling usb_control_msg() seems an acceptable way forward?

Hin-Tak
