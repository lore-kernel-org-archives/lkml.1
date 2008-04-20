Return-Path: <linux-kernel-owner+w=401wt.eu-S1754586AbYDTINw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586AbYDTINw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 04:13:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbYDTINd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 04:13:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55681 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751852AbYDTINa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 04:13:30 -0400
Date: Sun, 20 Apr 2008 10:13:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       Tomas Winkler <tomas.winkler@intel.com>
Cc: linux-kernel@vger.kernel.org, kaber@trash.net,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
       Mohamed Abbas <mabbas@linux.intel.com>, Ian Schram <ischram@telenet.be>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ivo van Doorn <ivdoorn@gmail.com>
Subject: [build bug] drivers/built-in.o: In function `rt2x00leds_resume': :
	undefined reference to `led_classdev_resume'
Message-ID: <20080420081302.GA11954@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> a third -git build failure triggered in last night's x86.git 
> build/boot testing:

and after i restarted last night's QA run, within a few iterations a 
fourth build failure popped up:

  drivers/built-in.o: In function `rt2x00leds_resume':
  : undefined reference to `led_classdev_resume'
  drivers/built-in.o: In function `rt2x00leds_resume':
  : undefined reference to `led_classdev_resume'
  [...]

config:

  http://redhat.com/~mingo/misc/config-Sun_Apr_20_09_43_01_CEST_2008.bad

suspected commit is: a2e1d52a32 "rt2x00: Remove MAC80211_LEDS 
dependency".

so far the -git track record: 4 networking build failures 1 SCSI build 
failure. (and i'm not picking these bugs nor am i trying to pick any 
fight here - randconfig does)

... and i think a little bit of grumpiness might be in order now: none 
of these commits were announced on lkml, so i have to hijack this thread 
again. As exciting as reporting bugs might seem from the outside, i'm 
supposed to find x86 and scheduler bugs, not networking bugs. Really, 
your practice of removing networking commits and pull requests from lkml 
does not result in a stellar quality track record.

	Ingo
