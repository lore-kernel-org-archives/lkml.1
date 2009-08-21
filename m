Return-Path: <linux-kernel-owner+w=401wt.eu-S1753739AbZHUDiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739AbZHUDiQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 23:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752804AbZHUDiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 23:38:15 -0400
Received: from smtp103.prem.mail.sp1.yahoo.com ([98.136.44.58]:46522 "HELO
	smtp103.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752282AbZHUDiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 23:38:14 -0400
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: TRSs1ngVM1lqpOnO9XqrUFBuZUjQOqZktL0oOc6LhL5rI3ZnasFDjJfz1ZDop_3C6xPRaUkMt_jd17ucD1rhSKwpCcrifWsMEzuMw7_3A3aNPgiJA6oD00.wgVVJezN2MR.AWXfXQzoeekIFaqDjmL6agVq9_bRAWQQXcH6ikN9W0TWmzt3zc1Iairw5G0hBc63UzV68qMErAU_MGrVHAaYtwoqzMXTaAA--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4A8E169E.70009@schaufler-ca.com>
Date: Thu, 20 Aug 2009 20:38:06 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: "David P. Quigley" <dpquigl@tycho.nsa.gov>
CC: jmorris@namei.org, sds@tycho.nsa.gov, gregkh@suse.de,
       ebiederm@xmission.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov,
       Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] Security/sysfs: Enable security xattrs to be set on sysfs
 files, directories, and symlinks.
References: <1247665721-2619-1-git-send-email-dpquigl@tycho.nsa.gov> <1250774285.2542.72.camel@moss-terrapins.epoch.ncsc.mil>
In-Reply-To: <1250774285.2542.72.camel@moss-terrapins.epoch.ncsc.mil>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David P. Quigley wrote:
> Since Casey has withdrawn his NAK for the patch I guess the only other
> concern was about the generality of the solution from Eric. Did Steve's
> response adequately address this or are there any other questions that
> people need answered before Greg can take the patch.
>   

Well, I've withdrawn the NAK, but I would still like to see:

Use the xattr, not a secid. Really. An LSM that has multiple attributes
is going to get bitten by that one. Also, any LSM that does neither
networking nor audit has no need for secids, so I would be happier if
the use of secids didn't expand into the file system space. Plus,
if it is going to be rare for an xattr to be set in sysfs (Stephen's
claim, which is consistent with my experience) saving a real xattr
should be no big deal.

Replace the security_xattr_to_secid hook in any case. All this is doing
is exposing what should be a strictly LSM internal function. You can
do it with a combination of existing hooks, if you have the time to code
up the error conditions.

You can ignore these objections if you feel you must. I'll still buy
a round in Portland.


