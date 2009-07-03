Return-Path: <linux-kernel-owner+w=401wt.eu-S1753989AbZGCHIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbZGCHIU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 03:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbZGCHIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 03:08:13 -0400
Received: from smtp-out.google.com ([216.239.45.13]:39536 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428AbZGCHIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 03:08:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=CQSKAcRIsTlaCIXhegVQNP7Pv72FX7INACdZyp8JfolZHmqEaEoCWg4QPx362eum+
	3aqFBa48Jr4c2nOaA+iHg==
MIME-Version: 1.0
In-Reply-To: <20090703022553.GJ19135@count0.beaverton.ibm.com>
References: <20090702231814.3969.44308.stgit@menage.mtv.corp.google.com>
	 <20090702232620.3969.16680.stgit@menage.mtv.corp.google.com>
	 <20090702164649.303c4952.akpm@linux-foundation.org>
	 <2f86c2480907021731h13e0bb95q94f06829eded9aa6@mail.gmail.com>
	 <20090702175341.fd2e26d5.akpm@linux-foundation.org>
	 <6599ad830907021808o6f3bb51eh324e4bf13544d83e@mail.gmail.com>
	 <2f86c2480907021817o79fce75yd9785aab682f7bb4@mail.gmail.com>
	 <20090703022553.GJ19135@count0.beaverton.ibm.com>
Date: Fri, 3 Jul 2009 03:08:11 -0400
Message-ID: <2f86c2480907030008g7a892bbcy6a5a7809efc091eb@mail.gmail.com>
Subject: Re: [PATCH 1/2] Adds a read-only "procs" file similar to "tasks" that 
	shows only unique tgids
From: Benjamin Blum <bblum@google.com>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Paul Menage <menage@google.com>, Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       lizf@cn.fujitzu.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 2, 2009 at 10:25 PM, Matt Helsley<matthltc@us.ibm.com> wrote:
>> Whether or not we get rid of the old ones, it would be good to put in
>> aliases with the new style now so there's the option of removing the
>> old style ones later.
>
> What a terrible idea! If every alias has an uncertain future nobody will
> know which they should use. As a consequence 50% may use "tasks" and 50%
> may use "cgroup.tasks" and then we won't be able to remove either name!
>
> Let's stick with what we have and not add endless numbers of aliases for
> every possible naming convention.

I agree that this is a problem, but Paul has a good point about
needing to avoid possible clashes, so it seems to me that the
"cgroups." prefix is necessary in at least all new files. Painful as
it would be to make the filenames consistent and correct, I'd rather
see us try to move towards that rather than leaving the filenames
split and ugly as they currently are.

Can we solve the "why lots of aliases are bad" problem during the
transition by putting a note in the documentation and also having
printk warnings when the deprecated filename is opened?
