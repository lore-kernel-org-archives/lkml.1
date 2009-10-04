Return-Path: <linux-kernel-owner+w=401wt.eu-S1754896AbZJDXkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896AbZJDXkO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 19:40:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753767AbZJDXkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 19:40:13 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:45862 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636AbZJDXkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 19:40:11 -0400
To: Johan Hovold <jhovold@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg Kroah-Hartman <gregkh@suse.de>,
       Michael Trimarchi <trimarchi@gandalf.sssup.it>,
       Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <4ABD020B.4040901@gandalf.sssup.it>
	<20090929145514.GF2152@localhost>
	<20090929235232.1ae6c63b@lxorguk.ukuu.org.uk>
	<m163ayzevu.fsf@fess.ebiederm.org> <20091002084755.GA7382@localhost>
	<20091002173308.6158d734@lxorguk.ukuu.org.uk>
	<20091003114229.GB605@localhost>
	<20091003141807.1dc27e4e@lxorguk.ukuu.org.uk>
	<20091003140522.GA8725@localhost>
	<20091003173324.315855ac@lxorguk.ukuu.org.uk>
	<20091004194822.GD24079@localhost>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 04 Oct 2009 16:39:22 -0700
In-Reply-To: <20091004194822.GD24079@localhost> (Johan Hovold's message of "Sun\, 4 Oct 2009 21\:48\:22 +0200")
Message-ID: <m1d452wwyd.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Johan Hovold <jhovold@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] USB: ftdi_sio: Remove tty->low_latency.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johan Hovold <jhovold@gmail.com> writes:

>> > > > +	 * The per character mucking around with sysrq path it too slow, so
>> > > > +	 * shortcircuit it in the 99.9999999% of cases where the USB serial is
>> > > > +	 * not a console anyway.
>> > > > +	 */
>> > > > +	ch = packet + 2;
>> > > > +	len -= 2;
>> > > > +	if (!port->console || !port->sysrq)
>> > > 
>> > > You need && flag == TTY_NORMAL ?
>> > 
>> > You tell me. :-) Are we interested in them unless port->console is set?
>> 
>> Yes - we don;t care about the sysrq but we care about error characters
>> being reported ot the line discipline properly.
>
> Wasn't thinking.. Here's an update which always passes error characters.
> It also uses ASYNCB_INITIALIZED (instead of ASYNCB_CLOSING) in unthrottle.

To test this what should I be applying this on top of?
There have been a lot of patches flying around.


Eric
