Return-Path: <linux-kernel-owner+w=401wt.eu-S1751568AbZGaNnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751568AbZGaNnn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 09:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751429AbZGaNnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 09:43:42 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:63686 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbZGaNnm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 09:43:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PzXYDnxjzgvXr2p/h94KzwyojXtESZHLYoTUTWYIGNrFlxMOCIZnuIxrDgHG5v8H9d
         phI8HO1YS05WnSzPfRFfpM2PTnjKtmg2Z0rXJNOeoxlMLd52uFWJAk4w0L5iZWUoZHlQ
         NTvWgJr2pJZFaXmz5gQ+tIUzJ2y0clzIE3rUg=
MIME-Version: 1.0
In-Reply-To: <20090731133437.GF17091@sirena.org.uk>
References: <1249044918-695-1-git-send-email-quadros.roger@gmail.com>
	 <20090731131005.GE17091@sirena.org.uk>
	 <74d0deb30907310625u128ea22cu6fecca53c4a23d40@mail.gmail.com>
	 <20090731133437.GF17091@sirena.org.uk>
Date: Fri, 31 Jul 2009 16:43:40 +0300
Message-ID: <b90c0690907310643n432c4504i1df5abaf8118e0b7@mail.gmail.com>
Subject: Re: [PATCH] regulator: Add GPIO enable control to fixed voltage 
	regulator driver
From: Roger Quadros <quadros.roger@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: pHilipp Zabel <philipp.zabel@gmail.com>, lrg@slimlogic.co.uk,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 31, 2009 at 4:34 PM, Mark
Brown<broonie@opensource.wolfsonmicro.com> wrote:
> On Fri, Jul 31, 2009 at 03:25:36PM +0200, pHilipp Zabel wrote:
>> On Fri, Jul 31, 2009 at 3:10 PM, Mark
>> Brown<broonie@opensource.wolfsonmicro.com> wrote:
>
>> > This isn't needed, just use an invalid GPIO value (zero or less).
>
>> Negative only, actually. Zero itself is a valid GPIO number (which is
>> a bit unfortunate because if you forget to initialize .gpio, it will
>> default to GPIO #0).
>
>> If you drop .use_gpio_control, use gpio_is_valid(data->gpio) for this check:
>
> Feh, better print a warning for GPIO 0 for at least a kernel release.
> Fortunately we've got no mainline users of fixed voltage regulators.
>

I think most architectures start their GPIO numbering from 0.
By 'a release', do you mean next Kernel release will be indexing GPIOs from 1?

>> > Same comment as above with regard to the error message. ?It would be
>> > nice to have the default state passed in as platform data if you can't
>> > read it back to help avoid bouncing supplies at startup. ?IIRC
>> > gpio_get_value() will generally take a good stab at giving the current
>> > state no matter if the GPIO is input our output but I'd need to check.
>
>> I think this is not clearly defined in the GPIO API document, so it
>> could be architecture dependent.
>
> It's not particularly; having checked gpiolib just passes this straight
> through to the underlying driver.  Since they'd have to go out of their
> way to do something unconstructive it should be safe to do the read and
> we can worry about problem cases if they crop up.
>
>> > If you mark the comments with /** they'll get picked up by kerneldoc.
>
>> Maybe following the style in Documentation/kernel-doc-nano-HOWTO.txt
>> would be worthwhile, then.
>
> Indeed.
>

Taken other suggestions for v2. Thanks Mark and Philipp.
