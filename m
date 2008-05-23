Return-Path: <linux-kernel-owner+w=401wt.eu-S1760229AbYEWXNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760229AbYEWXNg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 19:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753846AbYEWXN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 19:13:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56015 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbYEWXN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 19:13:27 -0400
Message-ID: <48374D3F.1080502@zytor.com>
Date: Fri, 23 May 2008 16:03:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Steve French <smfrench@gmail.com>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: kernel coding style for if ... else which cross #ifdef
References: <524f69650805231211r315be4e4u5890aa0f914bcb4f@mail.gmail.com>
In-Reply-To: <524f69650805231211r315be4e4u5890aa0f914bcb4f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steve French wrote:
> A question splitting "else" and "if" on distinct lines vs. using an
> extra line and extra #else came up as I was reviewing a proposed cifs
> patch.   Which is the preferred style?
> 
> #ifdef CONFIG_SOMETHING
>    if (foo)
>       something ...
>    else
> #endif
>    if ((mode & S_IWUGO) == 0)
> 
> or alternatively
> 
> #ifdef CONFIG_SOMETHING
>    if (foo)
>       something ...
>    else if ((mode & S_IWUGO) == 0)
> #else
>    if ((mode & S_IWUGO) == 0)
> #endif
> 

The former.  Why?  Because the latter case has unbalanced indentation: 
to an editor, and to the human eye, it looks like the if in the #else 
clause is a child to the "else if".

*However*, the best would really be if we changed Kconfig to emit 
configuration constants what were 0/1 instead of undefined/defined. 
That way we could do:

	if (CONFIG_SOMETHING && foo) {
		/* ... something ... */
	} else if ((mode & S_IWUGO) == 0) {
		/* ... */

... in many cases.

	-hpa
