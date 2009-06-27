Return-Path: <linux-kernel-owner+w=401wt.eu-S1758197AbZF0CKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758197AbZF0CKX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 22:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755598AbZF0CKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 22:10:12 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:41624 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456AbZF0CKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 22:10:10 -0400
To: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
Cc: Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org
References: <20090626143652.GB6281@localdomain.by>
	<20090626144949.GA24173@suse.de>
	<20090626232339.GD3858@localdomain.by>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 26 Jun 2009 19:10:08 -0700
In-Reply-To: <20090626232339.GD3858@localdomain.by> (Sergey Senozhatsky's message of "Sat\, 27 Jun 2009 02\:23\:39 +0300")
Message-ID: <m18wjeqven.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: sergey.senozhatsky@mail.by, linux-kernel@vger.kernel.org, kay.sievers@vrfy.org, gregkh@suse.de
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Sergey Senozhatsky <sergey.senozhatsky@mail.by>
X-Spam-Relay-Country: 
X-Spam-Report: *  7.0 XM_URI_RBL URI's domain appears in surbl.xmission.com
	*      [URIs: lkml.org]
	* -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] kobject_set_name_vargs memory leak
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergey Senozhatsky <sergey.senozhatsky@mail.by> writes:

> On (06/26/09 07:49), Greg KH wrote:
>> We've been through this before (search lkml archives).  If kvasprintf
>> fails, then we don't want to free old_name, as the caller might want to
>> do something with it.
>> 
>> Or something along those lines, I can't remember the exact reasoning
>> this early in the morning.
>> 
>> Kay, do you remember?
>>
> I found.
> http://lkml.org/lkml/2009/5/11/11
>
>>kobject with name set before should not come into this function,
>>kobject_rename should be used instead.
>
> It's just would be safer to kfree or restore I guess.

Yes.  There does seem to be a good point in there that the code should be:
BUG_ON(kobj->name);

And otherwise simply not handle old_name at all.

Eric
