Return-Path: <linux-kernel-owner+w=401wt.eu-S1764779AbYDOM5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764779AbYDOM5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 08:57:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755338AbYDOM5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 08:57:32 -0400
Received: from pat.uio.no ([129.240.10.15]:51137 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752548AbYDOM5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 08:57:31 -0400
Subject: Re: User space automounter problems after upgrade to 2.6.25-rc9
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Martin Knoblauch <spamtrap@knobisoft.de>
Cc: linux-kernel@vger.kernel.org, am-utils <am-utils@am-utils.org>
In-Reply-To: <313568.49494.qm@web32607.mail.mud.yahoo.com>
References: <313568.49494.qm@web32607.mail.mud.yahoo.com>
Content-Type: text/plain
Date: Tue, 15 Apr 2008 08:57:26 -0400
Message-Id: <1208264246.10319.4.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=5.0, autolearn=disabled, none)
X-UiO-Scanned: 5889580CBD24567799898C3BE3BE9B5F71DEA6B3
X-UiO-SR-test: 8D82CECD670C7C52F463FCBC1157CEEA0B012161
X-UiO-Ratelimit-Test: Ratelimit
X-UiO-SPAM-Test: UIO-RATELIMIT remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 1848 total 7898281 max/h 8345 blacklist 0 greylist 0 ratelimit 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-04-15 at 04:28 -0700, Martin Knoblauch wrote:
> Hi,
> 
>  after booting a newly built 2.6.25-rc9 kernel, I see the following messages and the user space automounter fails to work. Last good kernel for me is 2.6.24, as -rc9 is my first attempt at 2.6.25. Extremely sorry for being late to the game :-(
> 
> [   13.776876] Invalid hostname "pid4302@lpsdm60:/home" in NFS lock request
> [   11.996757] Invalid hostname "pid4302@lpsdm60:/home" in NFS lock request
> [   14.504927] Invalid hostname "pid4302@lpsdm60:/home" in NFS lock request
> [   13.636860] Invalid hostname "pid4302@lpsdm60:/home" in NFS lock request
> [   14.504927] Invalid hostname "pid4302@lpsdm60:/home" in NFS lock request
> [   13.636860] Invalid hostname "pid4302@lpsdm60:/home" in NFS lock request
> [   14.505079] Invalid hostname "pid4302@lpsdm60:/home" in NFS lock request
> [   11.996757] Invalid hostname "pid4302@lpsdm60:/home" in NFS lock request
> [   13.636860] Invalid hostname "pid4302@lpsdm60:/home" in NFS lock request
> [   12.688801] Invalid hostname "pid4302@lpsdm60:/soft" in NFS lock request
> 
> am-utils version is 6.1.5, config is attached

Already reported in:
   http://bugzilla.kernel.org/show_bug.cgi?id=10349
and
   https://bugzilla.am-utils.org/show_bug.cgi?id=612

The problem is due to known bugs in the am-utils mount code (no,
'pid4302@lpsdm60:/soft' is not and has never been a valid server
hostname).

The workaround should be to turn off locking by adding the 'nolock'
mount flag.

Trond

