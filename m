Return-Path: <linux-kernel-owner+w=401wt.eu-S1754411Ab0ALRmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411Ab0ALRmL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 12:42:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753834Ab0ALRmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 12:42:09 -0500
Received: from mail-qy0-f194.google.com ([209.85.221.194]:49289 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786Ab0ALRmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 12:42:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=hwJvzXENqayykJgjS/7mRs7LFjCnDFVHHB43OPvLtF2bqSZCN8HMekh+xLnEPjbLnj
         /h83vwne6/yiVuA+WH2LSBaCucBLfj0P5HuTD8LHGN72m1V74r2dR04BDZFbgCOxfndo
         HmZfKD8p0cpZ0LSMQ3jgrpbAnq9lE48bx4E2I=
Message-ID: <4B4CB46C.8020502@gmail.com>
Date: Tue, 12 Jan 2010 12:42:04 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Michael Chan <mchan@broadcom.com>
Subject: Re: [PATCH 1/2] net: tcp_header_len_th and tcp_option_len_th
References: <4B44FE3C.6060809@gmail.com> <4B450065.4010108@gmail.com> <4B4C519E.2090207@gmail.com>
In-Reply-To: <4B4C519E.2090207@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> Its better to inline your patches so that we can comment them, without copy/paste
> 
> When I hit 'reply to', my mailer only quoted the ChangeLog, not the patch.
> 
Seeing that we're both using Mozilla, how to you do it?

It took me many attempts to get this to work with Thunderbird on the Mac.


> Anyway ..
> 
> +/* Length of standard options only.  This could be negative. */
> +static inline int tcp_option_len_th(const struct tcphdr *th)
> +{
> +	return (int)(th->doff * 4) - sizeof(*th);
> +}
> 
> 
> The (int) cast is not necessary, since the function returns a signed int
> 
> ->
> 	return th->doff * 4 - sizeof(*th);
> 
Then GCC must be smarter than it was in the past, as doff is an __u16
bit slice -- once upon a time, a cast was required before subtraction.
One of the dis/advantages of C programming for 30+ years is that my
fingers remember some fairly old practices....

(But this still works properly!)

