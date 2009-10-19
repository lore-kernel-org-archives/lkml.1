Return-Path: <linux-kernel-owner+w=401wt.eu-S1757733AbZJSVYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757733AbZJSVYj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 17:24:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757645AbZJSVYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 17:24:38 -0400
Received: from smtprelay04.ispgateway.de ([80.67.18.16]:39578 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757641AbZJSVYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 17:24:38 -0400
References: <20091019102116.222ff9c3.peter@piie.net> <20091019091617.GA13277@rhlx01.hs-esslingen.de>
Message-ID: <cone.1255987487.209127.3188.1000@deskpiie>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Andreas Mohr <andi@lisas.de>
Cc: Borislav Petkov <petkovbb@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [Patch] acerhdf: Return temperature in milidegree
Date: Mon, 19 Oct 2009 23:24:47 +0200
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: 404094
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andreas,

thank you very much for your brainstorming.

Andreas Mohr writes:

> Hi,
> 
> On Mon, Oct 19, 2009 at 10:21:16AM +0200, Peter Feuerer wrote:
>> 
>> Hi Boris,
>> 
>> what do you think about this patch?
> 
> Personally I'm hurting a bit due to the open-coded "* 1000" transition
> in all places.
> 
> I'd add a helper macro
> #define TEMP_DEGREE_TO_SYS(x) ((x) * 1000)
> and use that in all places where it matters.
> 
> Advantage:
> - either no mistyping (10000 instead of 1000) _or_ bug occurring in _all_
>   places where this macro is used
> - easily grepped-for
> - easily changed once the system granularity gets updated

I agree with you in these points, but I have also some disadvantages to discuss:

Disadvantages:
 - Thinking about the implemenation such a macro would require, users may 
   get confused. They would still set the fanon / fanoff trip points in 
   degree, but when they read documentation or the current temperature, 
   millidegree is used.  
 - I think "TEMP_DEGREE_TO_SYS(59)" in code is not 
   as good readable as "59000"

what about writing something like "59 * 1000" insead of "59000"?

Or something like that:

#define FACTOR_MILLIDEGREE 1000
59 * FACTOR_MILLIDEGREE 

this solution has all your listed advantages and eliminates the 
disadvantages I see in the "TEMP_DEGREE_TO_SYS" solution.

--peter
