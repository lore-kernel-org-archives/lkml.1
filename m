Return-Path: <linux-kernel-owner+w=401wt.eu-S1755905AbYHMAfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905AbYHMAfg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 20:35:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753733AbYHMAf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 20:35:27 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:42118 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900AbYHMAf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 20:35:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Z2BHm0hJB9OhRcIxet8RqKAobriSipQYZYCYpfBt3mG7B1Oq6CouWXHWsIDM66bTKI
         H9YqKvLYWNgQcgOdv/9Y2vPIq5qtittZalu0IOmJqHWSG6nUANml4PXiTYhFKLI/kSda
         +VMsRuthBy1ux3zhpJtLkmSD+IHlPruf/1EsM=
Message-ID: <b3ece790808121735t21b4a629iaf6a968b30332d74@mail.gmail.com>
Date: Tue, 12 Aug 2008 17:35:24 -0700
From: "Tim Hockin" <thockin@hockin.org>
To: "Martin Schwidefsky" <schwidefsky@de.ibm.com>
Subject: Re: [patch 1/3] kmsg: Kernel message catalog macros.
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       lf_kernel_messages@lists.linux-foundation.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Michael Holzheu" <holzheu@de.ibm.com>,
       "Gerrit Huizenga" <gh@us.ibm.com>,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       "Randy Dunlap" <randy.dunlap@oracle.com>, "Jan Kara" <jack@suse.cz>,
       "Pavel Machek" <pavel@ucw.cz>, "Sam Ravnborg" <sam@ravnborg.org>,
       "Joe Perches" <joe@perches.com>,
       "=?UTF-8?Q?Jochen_Vo=C3=9F?=" <jochen.voss@googlemail.com>,
       "Kunai Takashi" <kunai@linux-foundation.jp>,
       "Tim Bird" <tim.bird@am.sony.com>
In-Reply-To: <20080730171156.824640459@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080730165656.118280544@de.ibm.com>
	 <20080730171156.824640459@de.ibm.com>
X-Google-Sender-Auth: 60b75bc54a4e7e10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2008 at 9:56 AM, Martin Schwidefsky
<schwidefsky@de.ibm.com> wrote:
> From: Michael Holzheu <holzheu@de.ibm.com>
> From: Martin Schwidefsky <schwidefsky@de.ibm.com>
>
> Introduce a new family of printk macros which prefixes each kmsg message
> with a component name and allows to tag the printk with a message id.

We've been talking about doing something like this, just this week.  AKPM
pointed me at this thread.  Good timing. :)

> +#define kmsg_dev_alert(id, dev, format, arg...) \
> +    printk(__KMSG_CHECK(ALERT, id) KMSG_COMPONENT \
> +        ": %s: " format, (dev)->bus_id , ## arg)

Rather than the gcc-specific '## arg', shouldn't we use the standard C99
form: '##__VA_ARGS__'  ?

As a format, I would argue to leave out the spaces after colons, making
the inevitable string splitting even easier.

I don't care for the magic file-global KMSG_COMPONENT.  It just feels
wrong.  In most cases, I want the prefix to be hierarchical.  For example,
rather than "tg3" I want "net.tg3" or "netdev:tg3" or something.

Further, We want to make a clearer denotation between "just another
printk()" and these things, which are really "important events".  Maybe a
global prefix that makes it easy to seperate them out?  Or a parallel
"event" interface that logs to printk() and a netlink socket?


Tim
