Return-Path: <linux-kernel-owner+w=401wt.eu-S1757930AbYEXFmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757930AbYEXFmx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 01:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752785AbYEXFmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 01:42:44 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:54139 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752521AbYEXFmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 01:42:43 -0400
Date: Sat, 24 May 2008 07:43:02 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Steve French <smfrench@gmail.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: kernel coding style for if ... else which cross #ifdef
Message-ID: <20080524054301.GA3773@uranus.ravnborg.org>
References: <524f69650805231211r315be4e4u5890aa0f914bcb4f@mail.gmail.com> <48374D3F.1080502@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48374D3F.1080502@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> *However*, the best would really be if we changed Kconfig to emit 
> configuration constants what were 0/1 instead of undefined/defined. 
> That way we could do:
> 
> 	if (CONFIG_SOMETHING && foo) {
> 		/* ... something ... */
> 	} else if ((mode & S_IWUGO) == 0) {
> 		/* ... */

We could do that - but then it would need another
name not to clash with all the places where we rely
on CONFIG_FOO='n' => CONFIG_FOO is not defined.

We could teach kconfig to emit something like:
#define KFOO 0   (for the 'n' value)
And 1 or 2 for the y and m values.

	Sam
