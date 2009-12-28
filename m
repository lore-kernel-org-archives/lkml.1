Return-Path: <linux-kernel-owner+w=401wt.eu-S1751323AbZL1ArH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751323AbZL1ArH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 19:47:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751103AbZL1ArG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 19:47:06 -0500
Received: from smtp-out.google.com ([216.239.44.51]:52893 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbZL1ArE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 19:47:04 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=YLffjf8gy/HnLfuHGu+ySB6qeCRSNv/qiGZf9dRE1tS2NHwBMZcloV9twUP0ME0X5
	4C7ERFzbp4Pb+8RJnsmDA==
MIME-Version: 1.0
In-Reply-To: <20091227211322.GB29174@elf.ucw.cz>
References: <a55d774e0912051638u7858878cg7cf62905c3c005c1@mail.gmail.com>
	 <1260627482.20913.7.camel@desktop>
	 <d6200be20912121434x1a247837w75c518ba20fe684f@mail.gmail.com>
	 <20091213212504.GD5114@elf.ucw.cz>
	 <d6200be20912142234ia050c67p34fd2672e7248170@mail.gmail.com>
	 <20091227093537.GD11737@elf.ucw.cz>
	 <20091227201514.GA29174@elf.ucw.cz>
	 <a55d774e0912271220p1d102b1dr398e0524c9386702@mail.gmail.com>
	 <20091227203704.GK11737@elf.ucw.cz>
	 <20091227211322.GB29174@elf.ucw.cz>
Date: Sun, 27 Dec 2009 16:46:58 -0800
Message-ID: <a55d774e0912271646m1b82687cy427083e64e91e323@mail.gmail.com>
Subject: Re: tree with htc dream support
From: Brian Swetland <swetland@google.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Arve Hj?nnev?g" <arve@android.com>,
       Daniel Walker <dwalker@codeaurora.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Iliyan Malchev <malchev@google.com>, linux-kernel@codeaurora.org,
       Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 27, 2009 at 1:13 PM, Pavel Machek <pavel@ucw.cz> wrote:
>
> Switch smd code to the version in staging. Something to apply to
> dream/ tree I'd say... and yes, it still works.

Hi Pavel,

I think we might want to consider leaving at least the core smd code
under mach-msm.

To start with it's specific to the 7k/8k platform, not dream (though
that may just be a quirk of how things are named in staging).  Also
the lowest layers (proc_comm and smsm_state stuff) are required for
clock control and basic power management to work -- they're kinda
joined at the hip with the platform.  It seems weird to me to have the
necessary bits to implement clock/power/pm outside of the mach/arch
space.

The higher level stuff (qmi, rpcrouter, smdtty, etc) could easily live
elsewhere (though I'm not sure where the best space in the drivers
hierarchy for them would be).

Brian
