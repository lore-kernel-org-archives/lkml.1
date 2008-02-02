Return-Path: <linux-kernel-owner+w=401wt.eu-S1765530AbYBBAkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765530AbYBBAkd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 19:40:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762486AbYBBAkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 19:40:13 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:31870 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759055AbYBBAkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 19:40:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=LHc8OenHyiwlL4F5e3aC8/UDakdagZ6+13KZtCk43i4XJ4RgIjzLUZukHihopD7l/dfufYjSmreENGjxTQ33bI4sRrlgKtuCCg1EbFShfbRQ0Otmmh5j570Kd3ZGjHuLROgm8CwwOXUAu+xVi0JbZWRl4Na3yDMz+5Qg184ryBQ=
Subject: Re: [PATCH] x86: sparse errors from string_32.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <47A35FBB.5030003@zytor.com>
References: <1201846516.23523.87.camel@brick>
	 <20080201105624.GD27178@elte.hu>  <47A35FBB.5030003@zytor.com>
Content-Type: text/plain
Date: Fri, 01 Feb 2008 16:40:15 -0800
Message-Id: <1201912815.23523.129.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-02-01 at 10:06 -0800, H. Peter Anvin wrote:
> Ingo Molnar wrote:
> > * Harvey Harrison <harvey.harrison@gmail.com> wrote:
> > 
> >>  		case 1:
> >> -			*(unsigned char *)s = pattern;
> >> +			*(unsigned char *)s = pattern & 0xff;
> > 
> > i've applied your fix - but wouldnt it be cleaner to just cast the 
> > pattern variable to unsigned char instead?
> > 
> 
> Even better, since we're talking about fixed bytes, I suggest writing it as:
> 
> 	*(u8 *)s = (u8)pattern;
> 
> Much more compact and the intent is a little bit more obvious.
> 

While I agree that is cleaner, that will still produce sparse warnings
about a cast truncating bits from a constant value.  I think that
explicit & is necessary (unless the cure is worse than the disease).

Harvey

