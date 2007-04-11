Return-Path: <linux-kernel-owner+w=401wt.eu-S1753634AbXDKSgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634AbXDKSgv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 14:36:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753604AbXDKSgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 14:36:51 -0400
Received: from terminus.zytor.com ([192.83.249.54]:45193 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065AbXDKSgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 14:36:50 -0400
Message-ID: <461D2AB8.5080902@zytor.com>
Date: Wed, 11 Apr 2007 11:36:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Egmont Koblinger <egmont@uhulinux.hu>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] console UTF-8 fixes
References: <20070406191245.GA11974@uhulinux.hu> <4616A2C7.3030000@zytor.com> <20070407092451.GA8779@uhulinux.hu> <Pine.LNX.4.61.0704071232560.22181@yvahk01.tjqt.qr> <20070407172603.GA25351@uhulinux.hu> <4617DBF7.5060009@zytor.com> <20070410094325.GB9143@uhulinux.hu> <461BB092.3070201@zytor.com> <20070410171924.GA18314@uhulinux.hu> <20070410183659.7341eeec@the-village.bc.nu> <20070411182801.GC26382@uhulinux.hu>
In-Reply-To: <20070411182801.GC26382@uhulinux.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Egmont Koblinger wrote:
> +static int is_zero_width(long ucs)
> +{
> +  static const struct interval zero_width[] = {
/* lots */
> +  };

I'm still unhappy about these large search tables in the kernel, not 
because they take a huge amount of space (it's not that much), but 
because they're invariably going to be stale, as they're Unicode-version 
dependent.

At least please put them in a separate .c file and include a script to 
generate them clean from UnicodeData.txt.

Besides, would it not make more sense to have a single table with the 
width information, if you insist on having one, instead of multiple ones?

	-hpa
