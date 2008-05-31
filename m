Return-Path: <linux-kernel-owner+w=401wt.eu-S1755001AbYEaCBV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001AbYEaCBV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 22:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750914AbYEaCBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 22:01:04 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:49052 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbYEaCBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 22:01:01 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: akpm@linuxfoundation.org, Chris Wright <chrisw@sous-sol.org>,
       stephen.hemminger@vyatta.com, adobriyan@gmail.com, morgan@kernel.org,
       xemul@openvz.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <200805292349.m4TNneua029348@imap1.linux-foundation.org>
	<20080530161857.25e3fbc5@extreme>
Date: Fri, 30 May 2008 18:59:26 -0700
In-Reply-To: <20080530161857.25e3fbc5@extreme> (Stephen Hemminger's message of
	"Fri, 30 May 2008 16:18:57 -0700")
Message-ID: <m1wslbcjy9.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Stephen Hemminger <shemminger@vyatta.com>
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0395]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] sysctl: allow override of /proc/sys/net with CAP_NET_ADMIN
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger <shemminger@vyatta.com> writes:

> Extend the permission check for networking sysctl's to allow
> modification when current process has CAP_NET_ADMIN capability and
> is not root. This version uses the until now unused permissions hook
> to override the mode value for /proc/sys/net if accessed by a user
> with capabilities.

Looks reasonable but a little incomplete.

Could you modify register_net_sysctl_table to set this attribute?
Or alternatively all of the tables registered with register_net_sysctl.

Otherwise I this will not affect all of the sysctls under
/proc/sys/net.  Which appears to be your intent.

> Found while working with Quagga. It is impossible to turn forwarding
> on/off through the command interface because Quagga uses secure coding
> practice of dropping privledges during initialization and only raising
> via capabilities when necessary. Since the dameon has reset real/effective
> uid after initialization, all attempts to access /proc/sys/net variables
> will fail. 

Eric
