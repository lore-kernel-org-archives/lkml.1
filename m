Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624Ab0CJXpS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 18:45:18 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:37746 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757439Ab0CJXpQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 18:45:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=l/39ILhB5M41QoinXNDDrKZK4TDzDCeGkP7YoLGmNJ5T5EPPmpb/zlrXZIdhDJwuBD
         UklsqbV2A66EUrjrJqjnLp9QivPB3+5RThsgYXk3glRb0WaFHruZ1+xQR5E0149tXoDz
         62TE74Q47rF+quhxsaNn16OiU06SV1P22irHI=
MIME-Version: 1.0
In-Reply-To: <201003101817.42812.hpj@urpla.net>
References: <201003101817.42812.hpj@urpla.net>
From: David Rees <drees76@gmail.com>
Date: Wed, 10 Mar 2010 15:44:54 -0800
Message-ID: <72dbd3151003101544w18afc65ubbc85d5bfc435198@mail.gmail.com>
Subject: Re: howto combat highly pathologic latencies on a server?
To: Hans-Peter Jansen <hpj@urpla.net>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 10, 2010 at 9:17 AM, Hans-Peter Jansen <hpj@urpla.net> wrote:
> While this system usually operates fine, it suffers from delays, that are
> displayed in latencytop as: "Writing page to disk:     8425,5 ms":
> ftp://urpla.net/lat-8.4sec.png, but we see them also in the 1.7-4.8 sec
> range: ftp://urpla.net/lat-1.7sec.png, ftp://urpla.net/lat-2.9sec.png,
> ftp://urpla.net/lat-4.6sec.png and ftp://urpla.net/lat-4.8sec.png.
>
> From other observations, this issue "feels" like it is induced by single
> syncronisation points in the block layer, eg. if I create heavy IO load on
> one RAID array, say resizing a VMware disk image, it can take up to a
> minute to log in by ssh, although the ssh login does not touch this area at
> all (different RAID arrays). Note, that the latencytop snapshots above are
> made during normal operation, not this kind of load..
>
> Might later kernels mitigate this problem? As this is a production system,
> that is used 6.5 days a week, I cannot do dangerous experiments, also
> switching to 64 bit is a problem due to the legacy stuff described above...
> OTOH, my users suffer from this, and anything helping in this respect is
> highly appreciated.

Seems like a 2.6.32 based kernel which has per-BDI writeback and "CFQ
low latency mode" changes might help a good deal.  I know that on one
of my bigger machines (similar in specs to yours) which has a lot of
processes which do a decent amount of IO, latency and load average has
gone down after going to a 2.6.32 kernel from a 2.6.31 kernel (Fedora
11 system).

Like Chris suggested, I've also heard that using the noop IO scheduler
can work well on Areca controllers on some kernels and workloads.
It's worth a shot and you can even try changing it at run-time.

-Dave
