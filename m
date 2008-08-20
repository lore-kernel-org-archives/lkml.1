Return-Path: <linux-kernel-owner+w=401wt.eu-S1752544AbYHTJbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544AbYHTJbV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 05:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750834AbYHTJbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 05:31:05 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:63764 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbYHTJbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 05:31:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Wj9QVIxPHkr7wxP7D5EMWJYx34ZeZrhQKvg45qyN0Ikzp26SxW2zie0+FyJw71ubvs
         Km9ffMUZ5qxXaDIKqXt7byicev/2LyhEMFknraTQpzopddTq0c+D1klP/gLHR+gtAk28
         fiw0uD5wECvCpK1CWl3GgTccJWbYJx0/QQlCM=
Message-ID: <86802c440808200231h27ab9121ofe68c86c2a80535e@mail.gmail.com>
Date: Wed, 20 Aug 2008 02:31:03 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Vivek Goyal" <vgoyal@redhat.com>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- found another user with the same regression
Cc: "Bill Fink" <billfink@mindspring.com>,
       "David Witbrodt" <dawitbro@sbcglobal.net>, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, netdev <netdev@vger.kernel.org>
In-Reply-To: <20080820091513.GA23865@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <109483.89278.qm@web82104.mail.mud.yahoo.com>
	 <86802c440808192221s3ada5443qc3b9d8e26f252d03@mail.gmail.com>
	 <20080820035130.38426b00.billfink@mindspring.com>
	 <86802c440808200102n6487ae17ud790991b8ea30d16@mail.gmail.com>
	 <20080820091513.GA23865@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2008 at 2:15 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>> > This is true if he reverted just the 3def3d6d... commit, but if he
>> > also reverts the similar, and immediately following, 1e934dda...
>> > commit, then his 2.6.26 kernel runs fine.
>>
>> interesting,
>>
>> David, can you try only comment out
>>
>> late_initcall(lapic_insert_resource);
>
> i.e. the patch below?
>
> what's your theory, what could be the reason for David's lockups?

could be insert_resource related.
1. revert patch that change back insert_resource doesn't work
2. insert_resource for lapic address moved to late after ....

need to add debug printout for insert_resource/request_resource to
make sure thing going well

YH
