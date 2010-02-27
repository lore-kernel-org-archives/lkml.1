Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108Ab0B0HOj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 02:14:39 -0500
Received: from smtp106.sbc.mail.gq1.yahoo.com ([67.195.14.109]:20292 "HELO
	smtp106.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753866Ab0B0HOi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 02:14:38 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=NCLqO4uDpYITZkS2un55bnuaNPRdN/MKJv6BXizcKFYIzsKOU1S6fKJE3pzx+WRptIA/pkvRCtDcni4ykV9eG96UyjDM5hEZ5I6qeBFGK5IS+ai49eo3pQv8HOh/F5IMdlmXKtRKgFpdWJh9lrjWvSXevi76Uximw+SPBzwCsa8=  ;
X-Yahoo-SMTP: 2V1ThQ.swBDh24fWwg9PZFuY7TTwFsTuVtXZ.8DKSgQ-
X-YMail-OSG: TsFsUV0VM1kWaWorBNCcc4Vg.GlkgqEOgyoENQrBca7sLE058s15_XjEBc1QeAJPC9cI4ey7Z5ZHQ2fheSLJExHQpcUxgxDAJNeh4Vom.HpWgoXyq883kBc_Xyd1crJ7n1smwBMI0PPooU4xLa1RIdWa7Qxv6IFb9.ivTBqX3skIrGUFAUBG_8vIeL7kM3.uywxqCGIMCpKDoxWtvqltpLo9xUEgKe5Tj_qOxaFq2qCvch4NDFk4naSlxlr1ESLFzfd_rnLxYsSq.34IkxA-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Ben Gardner <gardner.ben@gmail.com>
Subject: Re: [PATCH 3/3] OLPC: ALSA: fix cs5535audio's MIC GPIO to enable input
Date: Fri, 26 Feb 2010 23:14:35 -0800
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, Andres Salomon <dilinger@collabora.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jani Nikula <ext-jani.1.nikula@nokia.com>
References: <cover.1267225701.git.gardner.ben@gmail.com> <45a4e62ae577ae6cabce7e243e675b5e7d994ec2.1267225701.git.gardner.ben@gmail.com>
In-Reply-To: <45a4e62ae577ae6cabce7e243e675b5e7d994ec2.1267225701.git.gardner.ben@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201002262314.35871.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 February 2010, Ben Gardner wrote:
> We need to read back the value written to the GPIO pin to control the
> MIC input enable.

There are two potential values associated with GPIO outputs:

	- The value you wrote to it, which you should just remember.
	  This value should *NEVER* be returned through the GPIO calls.

	- The value at the pin, which will *often* be the same as
	  what you wrote to it ... except for open drain signals
	  or other "multi-drive" cases.   Or if you try to read the
	  value back before it gets latched.  (It's common to have
	  the "latch value" step be clocked by something ... and to
	  have multiple clock domains, so latching might not sync
	  up with what your CPU is doing.)

>From other patches recently landing in my mailbox, I'm thinking
that your GPIO driver isn't behaving properly ... it should return
the second value.


> Use gpio_set_direction() to set the GPIO in bidirectional mode.

NAK. THere is no such call, and should never be one.


