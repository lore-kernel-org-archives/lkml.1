Return-Path: <linux-kernel-owner+w=401wt.eu-S1755575AbZF1NOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbZF1NOK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 09:14:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbZF1NOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 09:14:00 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:32883 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbZF1NN7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 09:13:59 -0400
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@mail.by>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
References: <20090626143652.GB6281@localdomain.by>
	<20090626144949.GA24173@suse.de>
	<20090626232339.GD3858@localdomain.by>
	<m18wjeqven.fsf@fess.ebiederm.org>
	<20090627093932.GB3342@localdomain.by>
	<1246147018.24693.97.camel@yio.site>
	<m17hyw1s0h.fsf@fess.ebiederm.org>
	<ac3eb2510906280602j1812d7e7qce874d2e9775e29e@mail.gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 28 Jun 2009 06:13:56 -0700
In-Reply-To: <ac3eb2510906280602j1812d7e7qce874d2e9775e29e@mail.gmail.com> (Kay Sievers's message of "Sun\, 28 Jun 2009 15\:02\:46 +0200")
Message-ID: <m1tz20zejv.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: kay.sievers@vrfy.org, linux-kernel@vger.kernel.org, gregkh@suse.de, sergey.senozhatsky@mail.by
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Kay Sievers <kay.sievers@vrfy.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] kobject_set_name_vargs memory leak
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers <kay.sievers@vrfy.org> writes:

> On Sun, Jun 28, 2009 at 14:07, Eric W. Biederman<ebiederm@xmission.com> wrote:
>
>> But setting a kobject's name several times in a row is a bug.  You
>> need to call kobject_rename if you are going to change the name.
>
> Sure, we can define in that way.
>
>> So how about we fix the driver core not to do that.  Stop treating fmt
>> as a flag, and make it clear kobject_add should not be passed a name.
>
> Sounds fine to me. You did not try to compile your patch, right? :)

Only the lib/kobject bits...

> block/blk-sysfs.c: In function ‘blk_register_queue’:
> block/blk-sysfs.c:436: error: implicit declaration of function ‘kobj_set_name’
>
> drivers/base/driver.c: In function ‘driver_add_kobj’:
> drivers/base/driver.c:149: error: too many arguments to function ‘kobject_add’

Ugh I totally missed that one.

> Documentation/kobject.txt would also need an update then.

As for the rules it already seems correct.
But getting the prototype and mentioning kobject_set_name wouldn't
hurt.

Eric
