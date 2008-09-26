Return-Path: <linux-kernel-owner+w=401wt.eu-S1753487AbYIZQFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbYIZQFV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 12:05:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752733AbYIZQFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 12:05:04 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:63852 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730AbYIZQFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 12:05:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=cxYUf8CrXLM2mhqTvs5Xa3DId5ayzuAKxWPvvsbgyxqHrm/SyvKpGwuJZtPym0Vr5j
         JI+28llC0traLmVq8vjAG516d+7dJq72Q6ePIECxasDsMkHpLmOmmDpPEq3g5hKLtqmM
         Kj64mSH7DnNP4GpwxNWzOoPVa2zVmtB62cgVM=
Message-ID: <7fcc02550809260905oa17880fi80c94eaacb33dba3@mail.gmail.com>
Date: Fri, 26 Sep 2008 11:05:00 -0500
From: Tammy <tammy000@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH git latest] drivers/scsi: fixing wrong comment before new_buffer_tape()
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20080926111300.1dd34009@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080925174948.GA14180@carmen.cs.uiuc.edu>
	 <20080926111300.1dd34009@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Removing the wrong comment.
>> The lock is needed before calling new_tape_buffer(), at least in some cases.
>> So the comment above new_tape_buffer() is inconsistent with the code and
>> may mislead developers.
>>
>> I simply removed the wrong comment, as I am not sure if the lock is required
>> in all situations. If so, we should add "Caller must hold os_scsi_tapes_lock".
>>
>> Signed-off-by: Lin Tan <tammy000@gmail.com>
>
> Looks true to me for the current versions of the code. In fact it is only
> ever called from the initialisation function that I can see so chunks of
> the code could simply go away as well as bits of the comment. Ditto the
> one in drivers/scsi/st.c
>
> Acked-by: Alan Cox <alan@redhat.com>
>

I am sorry I didn't quite understand. You mean it is true that caller
must hold os_scsi_tapes_lock?

new_tape_buffer in drivers/scsi/st.c is called without the lock, but
the new_tape_buffer in drivers/scsi/osst.c
is called with the lock. Both comments says no lock is needed. Should
the two new_tap_buffer functions have similar usage?

BTW, I am on the mailing list now, so I no longer need to be
personally CC-ed. Thanks.

Lin
