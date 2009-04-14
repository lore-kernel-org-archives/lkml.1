Return-Path: <linux-kernel-owner+w=401wt.eu-S1757185AbZDNQp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757185AbZDNQp7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 12:45:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756996AbZDNQpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 12:45:34 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:61717 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756933AbZDNQpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 12:45:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=ZGKhRFZpvhKtEgJVjzXofGMariItcQLhnisGC3et4HtbPx1pUZ2lcnibrKjPaQ5SvN
         ZV9gMAvSYA+xejp+lzaWTFneR/Z9lQGncnjioBQ6NATFfrNoxUByMbDlmst0Q0q23jQc
         RYdcBE5ZKYFVzowkmUYkVRKWB+XWi0kt6Im4g=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mark Lord <lkml@rtr.ca>
Subject: Re: Input driver for Twinhan USB 6253:0100 remote control
Date: Tue, 14 Apr 2009 09:45:13 -0700
User-Agent: KMail/1.11.1 (Linux/2.6.27.21-170.2.56.fc10.x86_64; KDE/4.2.1; x86_64; ; )
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org
References: <20090408072935.GA27920@dtor-d630.eng.vmware.com> <200904131931.24009.dmitry.torokhov@gmail.com> <49E4B678.9030508@rtr.ca>
In-Reply-To: <49E4B678.9030508@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904140945.14652.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 April 2009 09:14:48 Mark Lord wrote:
> Dmitry Torokhov wrote:
> > Hi Mark,
> >
> > On Wednesday 08 April 2009 10:28:09 Mark Lord wrote:
> >> Dmitry,
> >>
> >> I briefly had access to a Twinhan remote control (for Mythtv et al.)
> >> and cobbled something together quickly to make it work.
> >>
> >> But I really don't understand the new hid/input stuff,
> >> so this is undoubtedly a total abomination to your eyes. :)
> >
> > Actually HID is Juri's baby so let's see what he says ;). From my POV
> > we need to update keymap to make it emit proper codes instead of Myth
> > specific ones, but that is a lesser issue.
>
> ..
>
> That's one thing I haven't figured out:  how to make this compatible
> with the userspace intput-kbd interface for loading new key maps and stuff.
>

You will need to convert your patch into proper hid_driver and
implement drv->input_mapping() method instead of overriding emitted
events. Then, once HID core is aware about proper mapping, normal
EVIOCGKEYCODE/EVIOCSKEYCODE will work and will allow adjusting
keymap from user space.

I think if you take drivers/hid/hid-belkin.c as a template the
conversion will take you no time.

-- 
Dmitry
