Return-Path: <linux-kernel-owner+w=401wt.eu-S932066AbXBMN3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066AbXBMN3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 08:29:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932069AbXBMN3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 08:29:20 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:24228 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932066AbXBMN3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 08:29:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BNQSwkH8ege3EFlWw6AuTnmN60SVr4yqf5oQtNGiGzX5BOpGWp1ua12i2h7kykZJGqUMkMhAsDSWg0DDJYdPkUcNPhROuaRsz9kLB4LOoQj4ghpCm8o7Ni0PLhFArUjo7S+jwIPy4yXnQTptz26wgOdmEU7d0xrtXuXoc+TqdG0=
Message-ID: <653402b90702130529k51b779d7w8b9a9f34a105197c@mail.gmail.com>
Date: Tue, 13 Feb 2007 14:29:17 +0100
From: "Miguel Ojeda" <maxextreme@gmail.com>
To: "Daniel Walker" <dwalker@mvista.com>
Subject: Re: [PATCH mm] cfag12864b: fix crash when built-in and no parport present
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <1171358197.32073.182.camel@imap.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070210205123.699abb9c.maxextreme@gmail.com>
	 <20070212213557.4b28e567.akpm@linux-foundation.org>
	 <1171358197.32073.182.camel@imap.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/13/07, Daniel Walker <dwalker@mvista.com> wrote:
> On Mon, 2007-02-12 at 21:35 -0800, Andrew Morton wrote:
>
> >
> > This looks hacky.
> >
>
> One other thing that could be added is a change in the initcalls .
> ks0108 should be subsys_initcall() and the LCD devices
> device_initcall(). That would make sure one runs before the other. I
>

Yes, it could be better, although it is not necessary for now (link
order is telling who should get called first).

>
> don't think that alone would fix the crash tho. I didn't suggest it
> before cause I think the order of the sources in the build system might
> do this implicitly even if both are in device_initcall ..
>

Yes, link order matters; however, the problem is related to
cfag12864b_init() being called if ks0108 failed. Indeed, if cfag12864b
is called before ks0108 is a mistake too, but it isn't happening here.

I also think the solution looks hacky (I said that I was waiting for a
better solution), and also I think it should be checked by the kernel
at boot like modprobe does; but I don't know any other solution. Any
ideas?

-- 
Miguel Ojeda
http://maxextreme.googlepages.com/index.htm
