Return-Path: <linux-kernel-owner+w=401wt.eu-S1755330AbXKFOG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbXKFOG2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 09:06:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753228AbXKFOGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 09:06:20 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:14139 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898AbXKFOGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 09:06:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=B7eZPvg/JSpfLN49J9OKVj/avSTIQwFMC4CrgczGLtUWNcvMwqpusVXmq+3XaumDQNp++WtZvJx23jNpmc1V+dz+ayVJceJbuE6Se8KlW7DFDXXXgKTXoo5ewTL14NoPeAuFYGRpyoJGm2OHUfWnqnA7J26GL6IKr2CasV1mNpY=
Message-ID: <d120d5000711060606h66adacd8q4c1576f98389bf41@mail.gmail.com>
Date: Tue, 6 Nov 2007 09:06:16 -0500
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.23: no more free evdev devices - evdev leak?
Cc: "Soeren Sonnenburg" <kernel@nn7.de>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Jiri Kosina" <jikos@jikos.cz>
In-Reply-To: <20071105191341.9b9dd857.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1193848484.5070.41.camel@localhost>
	 <20071105191341.9b9dd857.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 5, 2007 10:13 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 31 Oct 2007 16:34:44 +0000 Soeren Sonnenburg <kernel@nn7.de> wrote:
>
> > Dear all,
>
> (cc's added)
>
>
> > whenever I do a suspend resume cycle the input device's numbers are
> > increased until I finally run out of evdev devices. Is this a kernel
> > problem or some userspace program (udev/...) creating new devices all
> > the time?

evdev marks the device slot as free as soon as evdev_disconnect is
called which shoudl be called from input_unregister_device().

Could you please try sticking a printk in
hidinput_disconnect(drivers/hid/hid-input.c) to verify that
input_unregister_device is in fact being called?

-- 
Dmitry
