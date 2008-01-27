Return-Path: <linux-kernel-owner+w=401wt.eu-S1756203AbYA0Tz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203AbYA0Tz1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 14:55:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752006AbYA0TzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 14:55:17 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:18828 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbYA0TzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 14:55:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=iPewJeQssZBnVtna9R+yH7h88ZCazgza3dEasYo5IXG70Js95lGQJhserVFmsmzcVX9foUn0uozrQWMCzzD9rqnoNecAErIPccKd8PjHx9ysx0FBbSVHcZMBsfSP1AcQiK6RreojC1GYUVt6MIunJnfNL+6J0i70TbHXovkCTwo=
Message-ID: <76366b180801271155y36feaf51g3a22cd34b9a6c4a0@mail.gmail.com>
Date: Sun, 27 Jan 2008 14:55:14 -0500
From: "Andrew Paprocki" <andrew@ishiboo.com>
To: "Jordan Crouse" <jordan.crouse@amd.com>
Subject: Re: lxfb is not changing modes, no errors/information printing out
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080127192807.GF8635@cosmic.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <76366b180801271045u7342540p58f5970a49c097be@mail.gmail.com>
	 <20080127192807.GF8635@cosmic.amd.com>
X-Google-Sender-Auth: f8a584c8b61eea4d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 27, 2008 2:28 PM, Jordan Crouse <jordan.crouse@amd.com> wrote:
> On 27/01/08 13:45 -0500, Andrew Paprocki wrote:
> > Using 2.6.24, I can't get my Geode LX (LX800 CPU) to boot in anything
> > other than the default 80x25 console even though lxfb appears to be
> > loading normally. This device doesn't work with the VESA fb either
> > when I request "vga=0x31a". All the other boards I have display a
> > 1280x1024 console on my monitor. Are my kernel parameters wrong in
> > some way? I tried "video=lxfb:<mode>" with and without "vga=0x31a".
> > The driver is compiled into the kernel -- I am not using modules.
>
> Can you change the mode after you have booted with 'fbset'?

Two answers to this I just found out..

This is a system I installed BusyBox 1.8.0 on, and running 'fbset
1280x1024-75' does nothing. I copied over the real fbset binary from
my Debian install and when I ran it the same way, it worked perfectly.
So, yes, it appears that it is possible to change it after the fact,
but for some reason BusyBox can't do it. The only problem then appears
to be setting the fb mode from the boot line.

BusyBox 1.8.0 binary:

# fbset 1280x1024-75

mode "1280x1024-75"
        # D: 134.880 MHz, H: 79.905 kHz, V: 74.958 Hz
        geometry 1280 1024 1280 3264 8
        timings 7414 232 64 38 1 112 3
        accel true
        rgba 8/0,8/0,8/0,0/0
endmode
(nothing happens)

Debian binary:

# /tmp/fbset -v 1280x1024-60
Linux Frame Buffer Device Configuration Version 2.1 (23/06/1999)
(C) Copyright 1995-1999 by Geert Uytterhoeven

Opening frame buffer device `/dev/fb0'
Reading mode database from file `/etc/fb.modes'
Using video mode `1280x1024-60'
Setting video mode to `/dev/fb0'
(works)

Thanks,
-Andrew
