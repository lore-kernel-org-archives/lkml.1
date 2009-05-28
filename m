Return-Path: <linux-kernel-owner+w=401wt.eu-S1763422AbZE1Ppx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763422AbZE1Ppx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 11:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757223AbZE1Ppo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 11:45:44 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:60236 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621AbZE1Ppn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 11:45:43 -0400
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Hannes Reinecke <hare@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       SCSI development list <linux-scsi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       <linux-fsdevel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
References: <Pine.LNX.4.44L0.0905281105310.3037-100000@iolanthe.rowland.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 28 May 2009 08:45:32 -0700
In-Reply-To: <Pine.LNX.4.44L0.0905281105310.3037-100000@iolanthe.rowland.org> (Alan Stern's message of "Thu\, 28 May 2009 11\:24\:05 -0400 \(EDT\)")
Message-ID: <m18wkhw7s3.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: stern@rowland.harvard.edu, ebiederm@aristanetworks.com, linux-fsdevel@vger.kernel.org, cornelia.huck@de.ibm.com, tj@kernel.org, linux-kernel@vger.kernel.org, gregkh@suse.de, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, kay.sievers@vrfy.org, hare@suse.de, James.Bottomley@HansenPartnership.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Alan Stern <stern@rowland.harvard.edu>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.1229]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH 25/20] sysfs: Only support removing emtpy sysfs  directories.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern <stern@rowland.harvard.edu> writes:

> There's another point to consider.  If you do accept my argument that 
> empty targets can be removed from visibility regardless of the host's 
> state, then this removal races with addition of a new child.  Since 
> removal involves calling device_del(), it can't be protected by the 
> host lock.  Instead we'd have to use a mutex to protect both target 
> addition and target removal.

Careful.  Holding a lock over device_del is an easy and hidden way
to trigger a rare deadlocks.

Eric
