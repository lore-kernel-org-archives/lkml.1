Return-Path: <linux-kernel-owner+w=401wt.eu-S1755095AbZJCXwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095AbZJCXwU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 19:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257AbZJCXwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 19:52:20 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:46658 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbZJCXwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 19:52:18 -0400
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
	<m1ske1wgdi.fsf@fess.ebiederm.org>
	<20091003140902.38628d8a@lxorguk.ukuu.org.uk>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 03 Oct 2009 16:51:32 -0700
In-Reply-To: <20091003140902.38628d8a@lxorguk.ukuu.org.uk> (Alan Cox's message of "Sat\, 3 Oct 2009 14\:09\:02 +0100")
Message-ID: <m1iqewvxx7.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Alan Cox <alan@lxorguk.ukuu.org.uk>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
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

> On Fri, 02 Oct 2009 16:00:41 -0700
> ebiederm@xmission.com (Eric W. Biederman) wrote:
>
>> 
>> 
>> I have seen a hang in:
>>   /bin/stty (changing the baud rate)
>>     set_termios
>>       tty_wait_until_sent
>>         tty_chars_in_buffer
>>           ftdi_chars_in_buffer
>> 
>> Where the driver wedged for a serial port and no progress
>> was made.
>> 
>> This happened to me several times with 2.6.31.  My initial
>> hypothesis was this was a hardware error (as it only happened
>> on single piece of hardware).  With all of the driver problems
>> I suspect it could be a driver bug.
>
> Driver bug I would think - or setup. If you've genuinely got the port
> flow controlled then a request to set the termios after the I/O will wait
> until a signal or carrier change (or indeed forever) quite correctly.

Not setup.  Neither hardware flow control or software flow control are
used on that port.

What was truly puzzling is that it was the only one out of about 50 in
essentially the same configuration where I saw the problem.

Eric

