Return-Path: <linux-kernel-owner+w=401wt.eu-S1759378AbYJMLMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759378AbYJMLMK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 07:12:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756628AbYJMLL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 07:11:56 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:61816 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756396AbYJMLLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 07:11:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=UTq5WnhFcoGRFovTmFMir7OJI3sY56oELX25eTYsjM9UyJnbURPTBswj6WAAlmdJ48
         P7RCFb1fJCqQKvMVJ43oLxYWGkkpnA99S5e5N+ean1LBJq76PD9Z+aJLreW3U5Tj3IJn
         O5hHQfnfgNMkBZ6AQiFppt4hmUUSf10eT5X7w=
Message-ID: <912ec82a0810130411v3846c0efve4fe59c2b598b60a@mail.gmail.com>
Date: Mon, 13 Oct 2008 13:11:51 +0200
From: "Neshama Parhoti" <pneshama@gmail.com>
To: "Gilad Ben-Yossef" <gilad@codefidence.com>
Subject: Re: section mismatch with a platform driver
Cc: "Adrian Bunk" <bunk@kernel.org>, linux-kernel@vger.kernel.org
In-Reply-To: <48F3185F.9070700@codefidence.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <912ec82a0810130119g795c91ffr1083d7e8459a6db1@mail.gmail.com>
	 <20081013085111.GB29938@cs181140183.pp.htv.fi>
	 <912ec82a0810130228m3e9e11bcyfcabe1ab46fb0b6b@mail.gmail.com>
	 <48F3185F.9070700@codefidence.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2008 at 11:43 AM, Gilad Ben-Yossef
<gilad@codefidence.com> wrote:
> Can't be sure without seeing the whole picture, but the most probable
> solution is to drop that __init from the probe function. It's seems wrong as
> in theory the probe function can be called at any time in the life of the
> kernel, not just in this module init, even if in practice this will never
> happen, as I suspect is the case with such a platform driver.

Yes, thanks, removing that macro did make the warning go away.
That's weird because I was using other in-tree drivers as a template for this,
and they don't have this section mismatch problem...

>
> Gilad
>
>
>
> --
> Gilad Ben-Yossef Chief Coffee Drinker
>
> Codefidence Ltd.
> The code is free, your time isn't.(TM)
>
> Web:    http://codefidence.com
> Email:  gilad@codefidence.com
> Office: +972-8-9316883 ext. 201
> Fax:    +972-8-9316885
> Mobile: +972-52-8260388
>
>        The Doctor: Don't worry, Reinette, just a nightmare.        Everyone
> has nightmares. Even monsters from under the        bed have nightmares,
> don't you, monster?
>        Reinette: What do monsters have nightmares about?
>        The Doctor: Me!
>
