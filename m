Return-Path: <linux-kernel-owner+w=401wt.eu-S1759748AbZEKWYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759748AbZEKWYB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 18:24:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758524AbZEKWXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 18:23:49 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:61675 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758099AbZEKWXr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 18:23:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Jrn3wowpwl8nuFGTt/wV9tpNOz/k/m1WkHJzS9C7+O/nlbaH8eSBvx+v/aVvPJPSOx
         K+KywEnVNCzvPLx0gGSGSOHdQcfrHtB/wyeqS+x09yrT9KsT+Nes85MpwREIsPS/CS2Y
         AlY5Q1yAy8GqrnoeXeRpsNjJRTFn6aBGMDxwA=
MIME-Version: 1.0
In-Reply-To: <20090511131822.GC2721@tuxdriver.com>
References: <20090506064513.GA7460@kroah.com>
	 <1241632963-25601-1-git-send-email-linville@tuxdriver.com>
	 <3ace41890905081620h10d0250eq1ede9cd73021dc5b@mail.gmail.com>
	 <4A054F18.7020501@free.fr> <20090509135731.GD17349@kroah.com>
	 <20090509155013.GA21763@tuxdriver.com> <4A05F485.4080303@lwfinger.net>
	 <20090511131822.GC2721@tuxdriver.com>
Date: Mon, 11 May 2009 23:23:46 +0100
Message-ID: <3ace41890905111523n7a924cd1x7cf4741e85153bdd@mail.gmail.com>
Subject: Re: [RFT] rtl8187: use DMA-aware buffers with usb_control_msg
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, Greg KH <greg@kroah.com>,
       Eric Valette <eric.valette@free.fr>, linux-wireless@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 2:20 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Sat, May 09, 2009 at 04:24:21PM -0500, Larry Finger wrote:
>> John W. Linville wrote:
>> >
>> > Yeah, I don't like the original version either.  Even if the kmalloc's
>> > aren't a big performance hit, the failure path sucks.  I've included a
>> > new version below, but unfortunately I haven't had a chance to test it.
>> > Please give it a try if you get a chance?
>>
>> This one tests just fine here running on the latest pull of wireless testing
>> (v2.6.30-rc4-22732-gd879ac6). I think there is a leak of priv->io_dmabuf when
>> the driver is unloaded, and kfree(priv->io_dmabuf) should be added to
>> rtl8187_disconnect(). Otherwise ACK.
>
> Doh!
>
> ---
>
> From dbc8e19329b52c53832cbb03eea76646e44aab07 Mon Sep 17 00:00:00 2001
> From: John W. Linville <linville@tuxdriver.com>
> Date: Wed, 6 May 2009 13:57:27 -0400
> Subject: [PATCH] rtl8187: use DMA-aware buffers with usb_control_msg
>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

This looks so much cleaner. ACK - I see you already checked this in to
wireless-testing. Tried to give it a go just now, but got bitten by
the wext key management change, I think.

Hin-Tak
