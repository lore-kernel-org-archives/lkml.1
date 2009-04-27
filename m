Return-Path: <linux-kernel-owner+w=401wt.eu-S1759510AbZD0Slw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759510AbZD0Slw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 14:41:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759405AbZD0SlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 14:41:19 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:56460 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757859AbZD0SlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 14:41:17 -0400
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Christoph Lameter <cl@linux.com>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org
References: <20090422085828.GA16917@elte.hu>
	<alpine.DEB.1.10.0904241429450.19686@qirst.com>
	<20090424.222952.83381016.davem@davemloft.net>
	<m163gtxle9.fsf@fess.ebiederm.org>
	<alpine.DEB.1.10.0904270950580.16119@qirst.com>
	<20090427173420.GD8633@ZenIV.linux.org.uk>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 27 Apr 2009 11:41:10 -0700
In-Reply-To: <20090427173420.GD8633@ZenIV.linux.org.uk> (Al Viro's message of "Mon\, 27 Apr 2009 18\:34\:20 +0100")
Message-ID: <m13abukkhl.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org, davem@davemloft.net, cl@linux.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Al Viro <viro@ZenIV.linux.org.uk>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [rfc] built-in native compiler for Linux?
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> On Mon, Apr 27, 2009 at 09:52:46AM -0400, Christoph Lameter wrote:
>> On Sat, 25 Apr 2009, Eric W. Biederman wrote:
>> 
>> > If this was about teaching sparse to run lockdep at compile time, or
>> > generally about making the kernel compilation much faster and able to
>> > catch many more bugs there might be a point where the effort is worth
>> > the investment.
>> 
>> The preprocessor and its interaction with regular C code is quite
>> nasty. If sparse could get rid of the complexities and idiosyncrasies at
>> that level then it may be useful as a "pre" compiler.
>
> Explain, please.  BTW, at the risk of being called an elitist bastard, could
> I ask the participants of that thread to read C99 standard?  It's not hard
> to find (http://www.open-std.org/jtc1/sc22/WG14/www/docs/n1256.pdf, for one
> thing - that's C99 + errata) and at least chapter 5 and 6.10 are really
> must-read if we are talking about that stuff.
>
> In particular, C preprocessor does *NOT* work on text-to-text level and
> hasn't since way back.  It works on token stream.
>
> That's actually one of the areas where C99 is a huge improvement over
> earlier language - instead of more or less nasty kludges still trying
> to pretend that preprocessor was a filter with text output piped into
> compiler, it gives reasonably clear semantics approximating what the
> earlier variants had in common.

Well it came in C89, not C99.  Which could well be the reason the
specification is clear and reasonable.

> I'd done fairly complete rewrite of macro expansion (and a bunch of other
> places in preprocessor) in sparse, and places where it used to deviate from
> standard were by far the worst in terms of convoluted logics and corner
> cases.  Switching to what C99 asked had simplified the things a *lot*;
> it's surprisingly well thought through in that area (unlike e.g. the unholy
> mess around 'restrict' qualifier semantics).

Thank you.  I can't even imagine someone writing a C Preprocessor with
K&R semantics at this late date.

Eric
