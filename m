Return-Path: <linux-kernel-owner+w=401wt.eu-S1756193AbZEJHsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193AbZEJHsh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 03:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbZEJHs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 03:48:29 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:37417 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbZEJHs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 03:48:28 -0400
To: Arjan van de Ven <arjan@infradead.org>
Cc: Greg KH <gregkh@suse.de>, Fabio Comolli <fabio.comolli@gmail.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <20090509143742.GA27663@kroah.com>
	<b637ec0b0905090810t188e39e3w92d9f4eff04011f1@mail.gmail.com>
	<20090509150853.GA32394@suse.de>
	<20090509082233.32cbb8e4@infradead.org> <20090509161923.GA942@suse.de>
	<20090509213404.6cd040f7@infradead.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 10 May 2009 00:48:22 -0700
In-Reply-To: <20090509213404.6cd040f7@infradead.org> (Arjan van de Ven's message of "Sat\, 9 May 2009 21\:34\:04 -0700")
Message-ID: <m1bpq1wg8p.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: arjan@infradead.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, greg@kroah.com, kay.sievers@vrfy.org, fabio.comolli@gmail.com, gregkh@suse.de
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Arjan van de Ven <arjan@infradead.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.1838]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [patch 00/13] devtmpfs patches
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven <arjan@infradead.org> writes:

> On Sat, 9 May 2009 09:19:23 -0700
> Greg KH <gregkh@suse.de> wrote:
>
>
> btw... I would be a LOT happier about the solution from a technical
> point of view if it wasn't the kernel making the device node, but the
> kernel exposing a file with a list of all devices, so that userland can
> chose to mknod or not, with which permissions if non-default and with
> non-default owners.
> So basically (and I'm making up a filename here, don't read too much
> into that)
>
> cat /proc/alldevices
>
> c   1     4         foobar
> b   8     0         sda
> c   122   12        dri/card0
>
> etc
> making the actual nodes from this in the most simple case is basically
> no time in userspace, but a slightly more advanced early userspace app
> can even do permissions for the few device nodes where it matters etc.
>
> I can imagine that being a good solution that ends up solving your
> problem, but in a way that is more consistent with what the kernel does
> right now and how we can then have userland make decisions on where to
> make the nodes, with what perms etc etc.
> In fact such a file would be a greeat help in general, and would be a
> nice generic solution.

I just did a tiny 100 line test app.

It took me all of 0.06s to mount /sys and /dev and to walk sysfs and
create all 649 of the device nodes. 

I had recently done "echo 3 > /proc/sys/vm/drop_caches" to ensure
that the test was cache cold.

Looking at Kay's test data he doesn't even try and mount root until
0.2s in.

It seems to me that 0.06s is in the noise, small enough that if even
0.06s is limiting basic optimization work is called for.

Eric
