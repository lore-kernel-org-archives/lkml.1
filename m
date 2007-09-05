Return-Path: <linux-kernel-owner+w=401wt.eu-S1756080AbXIEEu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080AbXIEEu2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 00:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbXIEEuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 00:50:19 -0400
Received: from mxsf06.insightbb.com ([74.128.0.76]:65206 "EHLO
	mxsf06.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbXIEEuR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 00:50:17 -0400
X-IronPort-AV: E=Sophos;i="4.20,209,1186372800"; 
   d="scan'208";a="42288859"
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAN/R3UZKhRO4/2dsb2JhbACBWQ
X-IronPort-AV: E=Sophos;i="4.20,209,1186372800"; 
   d="scan'208";a="113360184"
From: Dmitry Torokhov <dtor@insightbb.com>
To: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] Add support for keyboard on SEGA Dreamcast
Date: Wed, 5 Sep 2007 00:50:13 -0400
User-Agent: KMail/1.9.3
Cc: linuxsh-dev@lists.sourceforge.net, Adrian McMenamin <lkmladrian@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org
References: <8b67d60709041634l198d29f0ja049989acdb30b67@mail.gmail.com> <200709050034.57010.vapier@gentoo.org>
In-Reply-To: <200709050034.57010.vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200709050050.14259.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Wednesday 05 September 2007 00:34, Mike Frysinger wrote:
> > +     kbd->dev = input_allocate_device();
> > ...
> > +     retval = input_register_device(kbd->dev);
> > +     if (unlikely(retval))
> > +             goto cleanup;
> > ...
> > +      cleanup:
> > +     kfree(kbd);
> > +     return -EINVAL;
> 
> i'm not familiar with the input layer, but do you need to deallocate that 
> input device if the register fails ?  if so, i guess dc_kbd_disconnect() 
> would need tweaking too ...

No, dc_kbd_disconnect() is fine - the structure is refcounted and so
input core will free it when the last reference drops. But you are
right, input_free_device() is still needed in error path.

-- 
Dmitry
