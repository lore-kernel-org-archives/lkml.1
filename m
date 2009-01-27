Return-Path: <linux-kernel-owner+w=401wt.eu-S1756366AbZA0SSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366AbZA0SSX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 13:18:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753291AbZA0SSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 13:18:15 -0500
Received: from wf-out-1314.google.com ([209.85.200.171]:15973 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133AbZA0SSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 13:18:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PO306L4Llx+NF5Pv4wlvwJw5eRrVtefWd3dN8gtWZhQbHld063oEeUE+rzxGIvTgmL
         AYeNIjWP4vMDnfJbAYjguznb1Ud8fl65/xaGSQzFoqv9bqp2NjfeLF6EHAuUv/Pd6k8e
         gR2uTtHCCLivBOZlpzQRED6N/Fo/7oLBSIGUs=
MIME-Version: 1.0
In-Reply-To: <497E968F.3020708@nerdgrounds.com>
References: <497E4531.20800@nerdgrounds.com>
	 <5bdc1c8b0901261859g58a413e1x52208a6f2c1f9ccd@mail.gmail.com>
	 <497E968F.3020708@nerdgrounds.com>
Date: Tue, 27 Jan 2009 10:18:12 -0800
Message-ID: <5bdc1c8b0901271018k7603e413o92de334e8d28d1d7@mail.gmail.com>
Subject: Re: Vramfs: filesystem driver to utilize extra RAM on VGA devices
From: Mark Knecht <markknecht@gmail.com>
To: Jonathan Campbell <jon@nerdgrounds.com>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2009 at 9:07 PM, Jonathan Campbell <jon@nerdgrounds.com> wrote:
>
>> Can the GPU use the data placed in your file system?
>
> Assuming the GPU can access any part of VRAM, yes. Files created in vramfs
> will always have content that exists somewhere in video ram. A file you
> create never moves, and is always contiguous in memory. All your program
> needs to direct the GPU to it is the block offset from the start of VRAM,
> which can be obtained by an ioctl() or bmap().
>
> I thought the best possible design would be for any process to create a file
> in vramfs, and then direct the attention of whoever's managing the GPU to
> that file (perhaps a user-space daemon), who could open the file and use
> bmap or an ioctl to locate it and direct the GPU to operate on it.
>

Yep, as I said in the response to Eric a number of us had talked in
the past about using the GPU for some audio operations that are just
too CPU intensive - reverb, multi-band compressors, etc. See Jamin as
an example of a great app that brings most DAW type boxes to their
knees.

http://jamin.sourceforge.net/en/about.html

> I'd also like to point out the filesystem structures themselves are never
> placed in VRAM on purpose. I'd hate for files to suddenly disappear from the
> filesystem because of an errant GPU bug or pixel shader gone amok; the worst
> that can happen by doing it that way is that a bunch of files go blank or
> get filled with garbage and no harm done.
>>
>> Do you have strong control as to exactly how the data is mapped into VRAM?
>
> Not exactly. When you create a file you get whatever free space is
> available. However, vramfs does guarantee that your file is never
> fragmented, never sparse, and will always exist for the life of the file
> from it's offset in video ram to the offset plus the file size. I believe
> I've written the code to be flexible enough however to allow stronger
> control if needed.

So what happens to the file system if the user changes screen
resolution, color depth, etc.? There must be features to manage stuff
like that?

- Mark
