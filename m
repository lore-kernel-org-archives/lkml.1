Return-Path: <linux-kernel-owner+w=401wt.eu-S1752706AbZHSRre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706AbZHSRre (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 13:47:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752288AbZHSRre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 13:47:34 -0400
Received: from smtp102.prem.mail.sp1.yahoo.com ([98.136.44.57]:21821 "HELO
	smtp102.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752130AbZHSRrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 13:47:33 -0400
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: ZRgzZfsVM1lfj6mQIRXlaccJiuBp5eMQ86uaq9CBHNjQj7_GDNj_iNoBLFPn0zM33S1Z3doEaVOvlc9TsQmWeyLu6Egm4JqY_qcr5qUT4t3etJoxzpq2EYxy32XJ_3tI2vg6Qoltucq2Vje7Dh7Pa0fPYfP4Q7PIn2P5VRirgps1m1_6czeqgO2wbaT1CjJy_zX9msnkdIzHTL8qvWNzz08l6gN1SqcKDoREiDluZN30Qq4zUxmp8Tt9_z0EX3YG_GfTqw--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4A8C3AB2.6080503@schaufler-ca.com>
Date: Wed, 19 Aug 2009 10:47:30 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Stephen Smalley <sds@tycho.nsa.gov>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       "David P. Quigley" <dpquigl@tycho.nsa.gov>, jmorris@namei.org,
       gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, SE Linux <selinux@tycho.nsa.gov>,
       Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] Security/sysfs: v2 - Enable security xattrs to be set
 on sysfs files, directories, and symlinks.
References: <1247665721-2619-1-git-send-email-dpquigl@tycho.nsa.gov>	 <4A84EF1D.8060408@schaufler-ca.com> <m1my62xde6.fsf@fess.ebiederm.org>	 <4A861291.1030404@schaufler-ca.com> <m1tz09j00q.fsf@fess.ebiederm.org>	 <4A864008.50907@schaufler-ca.com> <m1my61sjie.fsf@fess.ebiederm.org>	 <4A8A2616.8020809@schaufler-ca.com>	 <1250597660.3629.204.camel@moss-pluto.epoch.ncsc.mil>	 <4A8AB6B0.8010800@schaufler-ca.com>	 <1250605386.3629.236.camel@moss-pluto.epoch.ncsc.mil>	 <4A8B81A0.6070206@schaufler-ca.com> <1250683089.3629.268.camel@moss-pluto.epoch.ncsc.mil>
In-Reply-To: <1250683089.3629.268.camel@moss-pluto.epoch.ncsc.mil>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Smalley wrote:
> ...
>> So how often is the SELinux label going to get explicitly set in /sys ?
>> I'm grappling with the value of going hog-wild in optimizing this. If
>> it is something that's quite rare I can see the concern with expanding
>> the d_entry. If it is common, the storage associated with storing the
>> xattr could be an issue. If it is uncommon but not rare there's another
>> story again.
>>
>> I'm looking at addressing the issues. Thank you.
>>     
>
> I'd expect most sysfs nodes to be left in the default label, although we
> don't really know as this would be the first time that people have the
> option of finer-grained control to sysfs.

This would be consistent with the Unix MLS experience. Most system
files, including things like sysfs, either stick with their original
labels. On the occasion where they get changed the reason is both
important and focused. I had an update almost ready, but I need some
changes to accommodate the assumption that setting an attribute
is rare.

