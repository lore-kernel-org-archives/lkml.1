Return-Path: <linux-kernel-owner+w=401wt.eu-S932583AbZKDUvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932583AbZKDUvU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 15:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932366AbZKDUvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 15:51:19 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:51062 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932287AbZKDUvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 15:51:17 -0500
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
       Benjamin LaHaise <bcrl@lhnet.ca>
References: <m13a4vbz8r.fsf@fess.ebiederm.org>
	<m1hbta1onf.fsf@fess.ebiederm.org> <20091104142716.GD4355@us.ibm.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 04 Nov 2009 12:51:03 -0800
In-Reply-To: <20091104142716.GD4355@us.ibm.com> (Serge E. Hallyn's message of "Wed\, 4 Nov 2009 08\:27\:16 -0600")
Message-ID: <m13a4uypxk.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Serge E. Hallyn" <serue@us.ibm.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH 15/13] sysfs: Protect sysfs_refresh_inode with inode mutex.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serue@us.ibm.com> writes:

> Quoting Eric W. Biederman (ebiederm@xmission.com):
>> 
>> In general everything that writes to vfs inodes holds the
>> inode mutex, so hold the inode mutex over sysfs_refresh_inode.
>> The sysfs data structures don't need this but it looks like the
>> vfs might.
>> 
>> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
>
> Oh right so pls disregard my last reply to patch 9 :)

I also checked and nfs has the same basic structure and does take the
inode mutex on these paths, inside of nfs_refresh_inode which is
called from __nfs_revalidate_inode.

So it is definitely the consistent thing to do.

Eric
