Return-Path: <linux-kernel-owner+w=401wt.eu-S1761569AbZEMWnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761569AbZEMWnq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 18:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754586AbZEMWng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 18:43:36 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:34818 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbZEMWnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 18:43:35 -0400
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, David Howells <dhowells@redhat.com>,
       "David P. Quigley" <dpquigl@tycho.nsa.gov>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Jan Blunck <jblunck@suse.de>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>,
       Christoph Hellwig <hch@infradead.org>
References: <20090509143742.GA27663@kroah.com>
	<1242074517.6624.183.camel@moss-terrapins.epoch.ncsc.mil>
	<ac3eb2510905111405y5541117euf84dd38d39012bd0@mail.gmail.com>
	<1242132344.31807.48.camel@localhost.localdomain>
	<ac3eb2510905120810n101dff08yfa945a2ab4b17168@mail.gmail.com>
	<1242142528.31807.80.camel@localhost.localdomain>
	<ac3eb2510905120854y7b44f608odf25af159fd6495c@mail.gmail.com>
	<1242168913.6711.9.camel@poy> <10761.1242220810@redhat.com>
	<ac3eb2510905130634l75ef8f78v604c53fb4bc3167f@mail.gmail.com>
	<ac3eb2510905130720x38de25adxc83b10aea0b86ce1@mail.gmail.com>
	<1242225358.9974.26.camel@localhost.localdomain>
	<1242233101.2893.7.camel@poy>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 13 May 2009 15:43:28 -0700
In-Reply-To: <1242233101.2893.7.camel@poy> (Kay Sievers's message of "Wed\, 13 May 2009 18\:45\:01 +0200")
Message-ID: <m1d4ac39pr.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: kay.sievers@vrfy.org, hch@infradead.org, eparis@parisplace.org, jmorris@namei.org, jblunck@suse.de, gregkh@suse.de, linux-kernel@vger.kernel.org, greg@kroah.com, dpquigl@tycho.nsa.gov, dhowells@redhat.com, sds@tycho.nsa.gov
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Kay Sievers <kay.sievers@vrfy.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4168]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [patch 00/13] devtmpfs patches
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers <kay.sievers@vrfy.org> writes:

> On Wed, 2009-05-13 at 10:35 -0400, Stephen Smalley wrote:
>> > Maybe we could do the same credential swap in sysfs, and get rid of:
>> > /**
>> >  * lookup_one_noperm - bad hack for sysfs
>> > 
>> > Seems a bit odd to have a vfs function for a single filesystem, called
>> > from a single location, and annotated as "do not use". Christoph added
>> > the comment a while ago, so adding him to Cc:.
>> 
>> Yes, that makes sense to me as well - we didn't have the credentials
>> infrastructure in place at the time that lookup_one_noperm was
>> introduced, but switching the credentials around a normal lookup_one_len
>> call should work now.
>
> Something like this? It seems to work fine here, but I did not test it with SELinux.

That just masks the problem not fixes it.

The problem is that sysfs attempts to keep the dcache in lock-step with
the sysfs_dentries.

The VFS model is lazy coherency and bringing things in sync on access.
This is important to avoid locking problems.

Eric
