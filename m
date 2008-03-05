Return-Path: <linux-kernel-owner+w=401wt.eu-S932447AbYCEMbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932447AbYCEMbQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 07:31:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757414AbYCEMa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 07:30:57 -0500
Received: from wf-out-1314.google.com ([209.85.200.168]:10571 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757196AbYCEMaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 07:30:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lIQfh8g5QBt5Yf6flp65wyWpm/wfGHbjE9g0y51gzUAnI2xJEZIX1h1mv4ON1VYH6ILe+NpXAfjMQscxe2BV6F4yx8+m+s2t9VCeY0hQZzDZsbwzX3BV8KheqozIP4DOwvJOFOhGuyntHUd0/y74a1Cwu3LHlOp2NsAiaVlCQ6Q=
Message-ID: <e2e108260803050430o317d3e0dyed50e86cc4569746@mail.gmail.com>
Date: Wed, 5 Mar 2008 13:30:54 +0100
From: "Bart Van Assche" <bart.vanassche@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 6/9] drivers/net/wireless/iwlwifi/iwl-4965.c: Correct use of ! and &
Cc: "Julia Lawall" <julia@diku.dk>, "Christopher Li" <sparse@chrisli.org>,
       yi.zhu@intel.com, linux-wireless@vger.kernel.org,
       ipw3945-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org,
       "Harvey Harrison" <harvey.harrison@gmail.com>,
       "Alexander Viro" <viro@ftp.linux.org.uk>, linux-sparse@vger.kernel.org,
       "Josh Triplett" <josh@freedesktop.org>
In-Reply-To: <20080305122010.GA999@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0802262143570.18200@ask.diku.dk>
	 <20080305063842.GA24495@elte.hu>
	 <70318cbf0803042249j57d7f3a3j7666961a9132b10b@mail.gmail.com>
	 <20080305070201.GA32434@elte.hu>
	 <Pine.LNX.4.64.0803050951550.28021@ask.diku.dk>
	 <20080305122010.GA999@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 5, 2008 at 1:20 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * Julia Lawall <julia@diku.dk> wrote:
>
>  > There are some legitimate uses of !x & y which are actually of the
>  > form !x & !y, where x and y are function calls.  That is a not
>  > particularly elegant way of getting both x and y to be evaluated and
>  > then combining the results using "and".  If such code is considered
>  > acceptable, then perhaps the sparse patch should be more complicated.
>
>  i tend to be of the opinion that the details in C source code should be
>  visually obvious and should be heavily simplified down from what is
>  'possible' language-wise - with most deviations and complications that
>  depart from convention considered an error. I'd consider "!fn1() &
>  !fn2()" a borderline coding style violation in any case - and it costs
>  nothing to change it to "!fn1() && !fn2()".

If someone writes (!x & !y) instead of (!x && !y) because both x and y
have to be evaluated, this means that both x and y have side effects.
Please keep in mind that the C language does not specify whether x or
y has to be evaluated first, so if x and y have to be evaluated in
that order, an expression like (!x & !y) can be the cause of very
subtle bugs. I prefer readability above brevity.

Bart Van Assche.
