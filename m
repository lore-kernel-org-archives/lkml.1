Return-Path: <linux-kernel-owner+w=401wt.eu-S1753151AbZK3TWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151AbZK3TWA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 14:22:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752866AbZK3TWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 14:22:00 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:34836 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbZK3TV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 14:21:58 -0500
To: Pavel Machek <pavel@ucw.cz>
Cc: Miklos Szeredi <miklos@szeredi.hu>, jlayton@redhat.com,
       jamie@shareable.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk
References: <20091123173616.75c3f600@tlielax.poochiereds.net>
	<20091123224948.GB5598@shareable.org>
	<20091123181545.05ad004d@tlielax.poochiereds.net>
	<m1ljhwbyr3.fsf@fess.ebiederm.org>
	<20091123193426.55f1530a@tlielax.poochiereds.net>
	<20091124012027.GA14645@shareable.org>
	<20091124062621.744beddb@tlielax.poochiereds.net>
	<E1NCtxF-0000rn-1z@pomaz-ex.szeredi.hu> <20091124120906.GA1700@ucw.cz>
	<E1NCuz4-00010e-Ch@pomaz-ex.szeredi.hu>
	<20091130122851.GF13328@elf.ucw.cz>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 30 Nov 2009 11:21:52 -0800
In-Reply-To: <20091130122851.GF13328@elf.ucw.cz> (Pavel Machek's message of "Mon\, 30 Nov 2009 13\:28\:51 +0100")
Message-ID: <m1638r6cof.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Pavel Machek <pavel@ucw.cz>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH 0/3] vfs: plug some holes involving LAST_BIND symlinks and file bind mounts (try #5)
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@ucw.cz> writes:

> On Tue 2009-11-24 13:59:06, Miklos Szeredi wrote:
>> On Tue, 24 Nov 2009, Pavel Machek wrote:
>> > I believe that current semantics is ugly enough that 'documenting' it
>> > is not enough... and people want to port from other systems, too, not
>> > expecting nasty surprises like this...
>> 
>> This hasn't been a problem for the last 12 years, and still we don't
>> see script kiddies exploiting this hole and sysadmins hurrying to
>> secure their system, even though it has been public for quite a while.
>> 
>> Why?
>
> Because condition when it hits are quite unusual?

So unusual perhaps that this is not a problem?

>> The reason might be, that there *is no* violation of security.
>
> Well, security people disagree with you.

Other security people disagree with you.

>> See this: the surprise isn't that an inode can be reached from
>> multiple paths, that has been possible with hard links for as long as
>> unix lived.  The suprise is that the inode can be reached through
>> proc.  So this "hole" that has been opened about 12 years ago in linux
>> is quite well known.  Only this particular aspect of it isn't well
>> known, but that doesn't mean it's not right, does it?
>
> It does. Bypassing checks on read-only file descriptors is design
> misfeature, and users are clearly unaware. (See bugtraq). Being "old"
> does not mean it is right.

Being "old" does mean that changing it is a regression if any valid
application depends on this feature.

Eric
