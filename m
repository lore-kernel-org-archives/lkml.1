Return-Path: <linux-kernel-owner+w=401wt.eu-S1753898AbZJBWaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbZJBWaK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 18:30:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753041AbZJBWaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 18:30:09 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:46896 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428AbZJBWaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 18:30:07 -0400
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Johan Hovold <jhovold@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Michael Trimarchi <trimarchi@gandalf.sssup.it>,
       Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
       Alan Cox <alan@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <20090924154023.GA27480@localhost>
	<200909242103.48562.oliver@neukum.org>
	<20090924202107.4730f2af@lxorguk.ukuu.org.uk>
	<20090924211459.GB27963@localhost> <4ABD020B.4040901@gandalf.sssup.it>
	<20090929145514.GF2152@localhost>
	<20090929235232.1ae6c63b@lxorguk.ukuu.org.uk>
	<m163ayzevu.fsf@fess.ebiederm.org> <20091002084755.GA7382@localhost>
	<20091002173308.6158d734@lxorguk.ukuu.org.uk>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 02 Oct 2009 15:29:56 -0700
In-Reply-To: <20091002173308.6158d734@lxorguk.ukuu.org.uk> (Alan Cox's message of "Fri\, 2 Oct 2009 17\:33\:08 +0100")
Message-ID: <m11vllxwd7.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Alan Cox <alan@lxorguk.ukuu.org.uk>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] USB: ftdi_sio: Remove tty->low_latency.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

>> Alan, did you have time to look at it? Are there any reasons for wanting
>> to keep low_latency in ftdi_sio when it was removed from all other
>> drivers processing in interrupt context (without doing work queue
>> re-implementations)?
>
> Yes for latency handling (two layers of work queue is bad) but its the
> right fix for stable.
>
> For upstream how does this look as a tidy up
> ftdi_sio: simplify driver
>
> From: Alan Cox <alan@linux.intel.com>
>
> This does a lot of stuff that the modern buffering logic will cover itself
> so remove the cruft.
>
> - Remove the code handling throttle half way through a packet. We have 64K
>   of slack and flow control is async anyway so stopping is the wrong thing
>   to do
> - Remove various commented out bits
> - Without the partial packet stuff we can remove the async queue stuff and
>   split it into sensible functions for URB processing and for queueing urbs
>   for receipt
> - Remove the unused rx_bytes count. We take locks for it, we jump through
>   hoops for it and we never expose it.
>
> Signed-off-by: Alan Cox <alan@linux.intel.com>

The code doesn't fall over immediately in my testing.  So at first glance
this appears to be as good as removing low_latency.

Eric

