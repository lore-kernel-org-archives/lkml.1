Return-Path: <linux-kernel-owner+w=401wt.eu-S1755502AbYLEQ0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502AbYLEQ0i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 11:26:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbYLEQ0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 11:26:31 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:38627 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbYLEQ0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 11:26:30 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       James Morris <jmorris@namei.org>
References: <20081203191706.GA16433@us.ibm.com>
	<20081203191733.GA16652@us.ibm.com>
Date: Fri, 05 Dec 2008 08:24:06 -0800
In-Reply-To: <20081203191733.GA16652@us.ibm.com> (Serge E. Hallyn's message of
	"Wed, 3 Dec 2008 13:17:33 -0600")
Message-ID: <m1ej0mr3o9.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Serge E. Hallyn" <serue@us.ibm.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.2 SARE_LWSHORTT BODY: SARE_LWSHORTT
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 2/2] user namespaces: require cap_set{ug}id for CLONE_NEWUSER
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serue@us.ibm.com> writes:

> While ideally CLONE_NEWUSER will eventually require no
> privilege, the required permission checks are currently
> not there.  As a result, CLONE_NEWUSER has the same effect
> as a setuid(0)+setgroups(1,"0").  While we already require
> CAP_SYS_ADMIN, requiring CAP_SETUID and CAP_SETGID seems
> appropriate.

This looks reasonable.  For the short term we will need a greater
set of caps to be able to do all of the interesting things.

Personally the user namespace only becomes interesting when we
start to be able to move in the other direction and remove the
set of capabilities requires to create it.

Eric
