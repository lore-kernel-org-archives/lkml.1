Return-Path: <linux-kernel-owner+w=401wt.eu-S1758387AbZFYQnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758387AbZFYQnL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 12:43:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755010AbZFYQm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 12:42:58 -0400
Received: from mail-qy0-f193.google.com ([209.85.221.193]:59899 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbZFYQm4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 12:42:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SeipakJybo6iR6X/xxX5kqQyY61GAfgrirJJhT9+KZQB51ro7St3cIK/OTHRnxGMty
         NHti1QIl3zPd+CvzbEu1PavBJTbB048Ynix/spV9bMmDI5ncmZGeONZ986jJgv6Pu6Ek
         quEAnOT9CoKs11D5JOvz3gCJx/4zA4/PZXyac=
MIME-Version: 1.0
In-Reply-To: <20090626002345.07928230@dxy.sh.intel.com>
References: <20090608152420.0e76c302@dxy.sh.intel.com>
	 <1245936693.20530.107.camel@jani-desktop>
	 <20090625220826.1fa7413e@dxy.sh.intel.com>
	 <1245941565.20530.134.camel@jani-desktop>
	 <1245942355.20530.141.camel@jani-desktop>
	 <20090625230949.53beda65@dxy.sh.intel.com>
	 <1245944528.20530.145.camel@jani-desktop>
	 <20090625234846.1b987069@dxy.sh.intel.com>
	 <1245946154.9103.742.camel@pcarmody-desktop>
	 <20090626002345.07928230@dxy.sh.intel.com>
Date: Thu, 25 Jun 2009 09:42:42 -0700
Message-ID: <d120d5000906250942j1d25f4d6rccc12034758f8815@mail.gmail.com>
Subject: Re: [PATCH]input: Change timer function to workqueue for gpio_keys 
	driver
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Alek Du <alek.du@intel.com>
Cc: "ext-phil.2.carmody@nokia.com" <ext-phil.2.carmody@nokia.com>,
       "Nikula Jani.1 (EXT-Nixu/Helsinki)" <ext-jani.1.nikula@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Trilok Soni <soni.trilok@gmail.com>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       "ben-linux@fluff.org" <ben-linux@fluff.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 25, 2009 at 9:23 AM, Alek Du<alek.du@intel.com> wrote:
> On Fri, 26 Jun 2009 00:09:14 +0800
> Phil Carmody <ext-phil.2.carmody@nokia.com> wrote:
>
>> If you stopped calling the delay after the first transition "debouncing
>> time" and simply called it a "delay" you might more easily see that it
>> does *no* debouncing at all. Imagine putting noise on the line
>> constantly - the original code's timer would never expire. Your timer
>> will expire after a delay, and while the line is still toggling
>> frantically - you've not debounced.
>
> I don't know if it is really meaningful if you want to handle such pool signal...
> Ok, if you want to handle this ultimate case, will this patch work?
>
>        BUG_ON(irq != gpio_to_irq(button->gpio));
>
> +       cancel_delayed_work_sync(&bdata->work);

Can't do *_sync in interrupt context.

>        delay = button->debounce_interval ?
>                        msecs_to_jiffies(button->debounce_interval) : 0;
>        schedule_delayed_work(&bdata->work, delay);
>

-- 
Dmitry
