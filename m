Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760Ab0CEFL4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 00:11:56 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47847 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab0CEFLz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 00:11:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=KtqrHgQha5oHp7/MaQstvNMJ/jRNgVNryK9th4YXCM1zIsOCF6mhnH34+nlKQxG6z7
         LzaIjU1kyAFzVPgF5wgvZusnlwpw1GgbrhvgpwkEvGUhL+iUeC9nfrlitYDxaeSBLcKe
         xK9KuwnD2V4U8cybBv9YCxNj4ddd2l21B7O4s=
MIME-Version: 1.0
In-Reply-To: <20100305044054.GB5747@thunk.org>
References: <20100303151720.GA3191@thunk.org>
	 <20100303.072007.170106625.davem@davemloft.net>
	 <20100305044054.GB5747@thunk.org>
Date: Fri, 5 Mar 2010 15:11:53 +1000
Message-ID: <21d7e9971003042111n5b5145c5sd9b62b53522cfd86@mail.gmail.com>
Subject: Re: [REGRESSION] X doesn't work with 2.6.33 (can't find any input 
	devices)
From: Dave Airlie <airlied@gmail.com>
To: tytso@mit.edu, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 5, 2010 at 2:40 PM,  <tytso@mit.edu> wrote:
> On Wed, Mar 03, 2010 at 07:20:07AM -0800, David Miller wrote:
>> From: tytso@mit.edu
>> Date: Wed, 3 Mar 2010 10:17:20 -0500
>>
>> > It worked just *fine* using 2.6.33-rc4.  I have no xorg.conf file (X
>> > is autoconfiguring itself) and I'm using an Ubuntu 9.10 userspace.
>>
>> X uses udev events to find input devices these days, so it's probably
>> the same problem preventing your lvm devices from showing up correctly
>> from initramfs.
>
> It uses libhal, I believe to find input devices and I was finally able
> to work around the problem by configuring an manually recreated
> xorg.conf file with the magic option:
>
> Section "ServerFlags"
>        Option "AllowEmptyInput" "off"
> EndSection
>
> ... and then making sure that the kbd and mouse input drivers were
> installed.  There is definitely something wrong though if sometime
> between 2;6.33-rc4 and 2.6.33 we've made some incompatible sysfs
> change that breaks hal on Ubuntu 9.10 (which is still the latest
> Ubuntu community release), such that people can't test 2.6.33 kernels
> using it --- at least not easily.
>
> See Linus's complaints over the nouveau driver; it's the same
> principle; something is really broken.


Not really, this is just somebody doing something stupid one would hope,

does lshal on both kernels give similiar results?

Dave.
