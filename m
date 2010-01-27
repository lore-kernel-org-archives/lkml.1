Return-Path: <linux-kernel-owner+w=401wt.eu-S1756524Ab0A0XHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524Ab0A0XHt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 18:07:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756517Ab0A0XHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 18:07:46 -0500
Received: from mail.crca.org.au ([67.207.131.56]:40179 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756514Ab0A0XHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 18:07:44 -0500
X-Greylist: delayed 378 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Jan 2010 18:07:44 EST
X-Bogosity: Ham, spamicity=0.000003
Message-ID: <4B60C632.5050500@tuxonice.net>
Date: Thu, 28 Jan 2010 10:03:14 +1100
From: Nigel Cunningham <nigel@tuxonice.net>
Reply-To: nigel@tuxonice.net
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Pedro Ribeiro <pedrib@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: WARN_ON at line 380 in kernel/smp.c under 2.6.32.2 + TuxOnIce
 + KDB
References: <74fd948d0912220851v354b1704xa55fc3c88e1c300c@mail.gmail.com>	 <1261502431.4937.38.camel@laptop>	 <74fd948d0912221116l477a8a71w1feadc1341fc6e21@mail.gmail.com> <1261510020.4937.73.camel@laptop>
In-Reply-To: <1261510020.4937.73.camel@laptop>
X-Enigmail-Version: 0.95.7
OpenPGP: id=8B613241
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter et al.

Peter Zijlstra wrote:
> On Tue, 2009-12-22 at 19:16 +0000, Pedro Ribeiro wrote:
>> On Tue, Dec 22, 2009 at 5:20 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> 
>>> If you'd enable frame pointers the strack traces would be clearer, but
>>> it looks like a bug in tux on ice, doing kmap_high() with IRQs disabled
>>> or something like that.
> 
>> I enabled frame pointers, is this more useful?
>> http://img684.imageshack.us/img684/5118/dsc01206m.jpg
>> http://img96.imageshack.us/img96/5493/dsc01207k.jpg
>> http://img33.imageshack.us/img33/7470/dsc01208lp.jpg
> 
> Those read more clearly indeed, thanks!
> 
> It really looks like what I said above, in that tux on ice is calling
> kmap() from an inappropriate context.

I've finally gotten around to looking at this problem properly, and Pete
is exactly right. I'll send a test fix to Pedro separately.

Regards,

Nigel
