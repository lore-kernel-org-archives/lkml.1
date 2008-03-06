Return-Path: <linux-kernel-owner+w=401wt.eu-S1762171AbYCFVib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762171AbYCFVib (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 16:38:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756665AbYCFViF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 16:38:05 -0500
Received: from mx10.go2.pl ([193.17.41.74]:58024 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S935886AbYCFViC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 16:38:02 -0500
X-Greylist: delayed 19399 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Mar 2008 16:38:02 EST
Message-ID: <47D06433.1010502@o2.pl>
Date: Thu, 06 Mar 2008 22:37:55 +0100
From: Artur Skawina <art_k@o2.pl>
User-Agent: Thunderbird 2.0.0.13pre (X11/20080229)
MIME-Version: 1.0
To: gcc@gcc.gnu.org, linux-kernel@vger.kernel.org
Subject: Re: RELEASE BLOCKER: Linux doesn't follow x86/x86-64 ABI wrt direction
     flag
References: <578FCA7D-D7A6-44F6-9310-4A97C13CDCBE@apple.com> <47CF44E7.3020106@zytor.com> <20080306135139.GA5236@dspnet.fr.eu.org> <47CFF9A3.30309@gnu.org> <20080306141221.GC5236@dspnet.fr.eu.org> <20080306175841.GI17267@synopsys.com> <20080306181029.GA42904@dspnet.fr.eu.org> <47D03440.6090503@gnu.org> <20080306183146.GL27983@randombit.net> <47D0495F.2090109@gnu.org> <20080306201633.GM27983@randombit.net>
In-Reply-To: <20080306201633.GM27983@randombit.net>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jack Lloyd wrote:
> But still: so the threat here is of a malicious process with the
> ability to send arbitrary signals to any process using CAP_KILL (since
> in any other case when a process can send a signal, it can do much
> more damage in other ways), which could leverage that into
> (potentially) uid==0 using misexecuted code in a signal handler.
> 
> As a correctness issue, obviously this should be fixed/patched around,
> if feasible. But as a security flaw? I'm not seeing much that is
> compelling.
> 
>> 2) sometimes setuid programs send signals (e.g. SIGHUP or SIGUSR1)
> 
> I don't understand how this is a problem - unless these setuid
> programs, while not malicious, can be tricked into signalling a
> process they did not intend to. (In which case they already have a
> major bug, df bit being cleared or not).

think apps keeping crypto keys etc in ram and wiping them from signal
handlers. eg gnupg does this; fortunately it seems to have moved from
memset() to a open coded solution, so probably isn't affected. OTOH
it wouldn't surprise me these days if the compiler would emit string
ops even w/o an explicit mem* call.
Copying a private memory region to some public buffer could also lead
to interesting results... 
IOW being able to avoid a memset (or copying the wrong data) certainly
could have security consequences.

artur
