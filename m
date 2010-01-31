Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075Ab0AaXT1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 18:19:27 -0500
Received: from mail.artecdesign.ee ([195.50.213.123]:51041 "EHLO
	postikukk.artecdesign.ee" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612Ab0AaXTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 18:19:25 -0500
X-Greylist: delayed 2657 seconds by postgrey-1.27 at vger.kernel.org; Sun, 31 Jan 2010 18:19:25 EST
Message-ID: <4B660584.7020302@artecdesign.ee>
Date: Mon, 01 Feb 2010 00:34:44 +0200
From: Anti Sullin <anti.sullin@artecdesign.ee>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Harro Haan <hrhaan@gmail.com>
CC: Ryan Mallon <ryan@bluewatersys.com>, Remy Bohmer <linux@bohmer.net>,
       Andrew Victor <avictor.za@gmail.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       H Hartley Sweeten <hartleys@visionengravers.com>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [patch v2 1/2] at91_udc.c read_fifo timing issue
References: <20100129162029.998540038@gmail.com>> <20100129162155.709756286@gmail.com>>
In-Reply-To: <20100129162155.709756286@gmail.com>>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-ADG-Spam-Score: -4.4 (----)
X-ADG-Spam-ScoreInt: -43
X-ADG-Spam-Report: Content analysis details:   (-4.4 points, 5.0 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	-1.8 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	-2.6 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
X-ADG-ExiScan-Signature: 3acc284d04fbfb526f175a047efbdae7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harro Haan wrote:
 > This solves the read_fifo timing issue for example seen with CDC 
Ethernet.
[...]

Still this bug not fixed?
I sent almost the same fix and a lot of debug info with description of 
the issue and the critical path of the timing to linux-arm-kernel on 
2009-03-25 ( 
http://lists.arm.linux.org.uk/lurker/message/20090325.150843.f515c02f.en.html 
) and we had an off-list discussion with David Brownell about another 
udc patch on 2009-06-19 that later turned out to be the same issue.

This fix has solved the problems on our devices and we've been using it 
for almost a year now.

About Harro's patch:
* why are the marker1 and marker2 comments necessary to be included?
* maybe you should just link to the mailing list and/or move the long 
comment to patch description instead adding a page-long comment to code; 
just leave a small comment to explain why the work-around is needed so 
that nobody would optimize it away?
* Is the error check and warning message necessary after we've got rid
of the problem? Won't it add problems - as I found out, the first csr
read (that comes too early) may return bogus data, you should not use 
its result at all.

-- 
Anti Sullin
Embedded Software Engineer
Artec Design LLC
Teaduspargi 6/2, 12618, Tallinn, Estonia
http://www.artecdesign.ee
