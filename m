Return-Path: <linux-kernel-owner+w=401wt.eu-S1757359AbYIAJs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359AbYIAJs0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 05:48:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752762AbYIAJsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 05:48:17 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:3809 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbYIAJsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 05:48:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=gw/+yVILi9dCghuWt2ijWzKblNaTL7Fu5xJW2plF6KNbJ1a86oYhQY8VmYWLYI4pS5
         ZTVZEhVJTofLgu1CNt4POz+2wyVENhXWGKBteQ0Ev6J2zSxRae/qABWqrPdpw0IfWdTn
         h5mBtmfrQwVKu8vqqiXqHLolCXlW7BdCigI+U=
Message-ID: <386072610809010248l78e9c661i130c3fa4b84b0a3c@mail.gmail.com>
Date: Mon, 1 Sep 2008 17:48:14 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: HAVE_CLK (for <linux/clk.h> support)
Cc: "Felipe Balbi" <felipebalbi@users.sourceforge.net>,
       "Felipe Balbi" <felipe.balbi@nokia.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200805271841.16793.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200805231044.59969.david-b@pacbell.net>
	 <200805271614.55233.david-b@pacbell.net>
	 <31e679430805271701h73ee1eb2p80329900008827f8@mail.gmail.com>
	 <200805271841.16793.david-b@pacbell.net>
X-Google-Sender-Auth: 1b5e2c4834d05e30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for jumping in so later. I noticed Blackfin does not support
HAVE_CLK currently.
As the HAVE_CLK dependence is included in the kernel mainline, MUSB
parts do not show up in the Kconfig because of lacking of HAVE_CLK.

To implement clk infrastructure in Blackfin will be later than merging
MUSB Blackfin parts to upstream.

Any idea?

Thanks
-Bryan

On Wed, May 28, 2008 at 9:41 AM, David Brownell <david-b@pacbell.net> wrote:
> On Tuesday 27 May 2008, Felipe Balbi wrote:
>> >
>> > I don't know of any other drivers with this particular issue,
>> > but nonetheless ... I think the following is an appropriate
>> > resolution.
>> >
>> > Comments from anyone else?
>>
>> I actually like it. I didn't see this error cuz I was only building
>> musb for arm architecture.
>>
>> But why only davinci and omap?
>
> They're the only one affected by the musb_hdrc patch...
>
>
>> What about: mach-aaec2000, mach-at91, mach-ep93xx, mach-integrator,
>> mach-lh7a40x, mach-ns9xxx, mach-pnx4008, mach-pxa, mach-realview,
>> mach-sa1100, mach-versatile, mach-s3c24x.
>
> If this approach goes forward, I'd expect those platforms
> to "select HAVE_CLK" too.  Ditto some SH, PowerPC, etc.
>
>
>> Instead of making the driver dependant on HAVE_CLK (which would be
>> true for virtually any driver comming from linux-omap), you could make
>> clk_enable a nop in case arch doesn't HAVE_CLK. How does that sound?
>
> Best done by #ifdef HAVE_CLK in <linux/clk.h> support, and
> putting the stubs there.  However, since those platforms
> don't actually have clocks, I'd make them all report errors
> of whichever kind.
>
> That's kind of a second-order question to "should we create
> a HAVE_CLK in Kconfig".  Since Certain People have objected
> to patches touching <linux/clk.h> I avoided doing that the
> first time around ... it'd be a better solution, yes.
>
> - Dave
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
