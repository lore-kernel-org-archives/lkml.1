Return-Path: <linux-kernel-owner+w=401wt.eu-S932076AbZJASpD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076AbZJASpD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 14:45:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755994AbZJASpD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 14:45:03 -0400
Received: from lo.gmane.org ([80.91.229.12]:38441 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755970AbZJASpC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 14:45:02 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Ben Pfaff <blp@cs.stanford.edu>
Subject: Re: [PATCH 10/19] workqueue: update cwq alignement and make one more flag bit available
Date: Thu, 01 Oct 2009 11:45:55 -0700
Message-ID: <87zl8bhs0s.fsf@blp.benpfaff.org>
References: <1254384558-1018-11-git-send-email-tj@kernel.org>
	<1254384558-1018-1-git-send-email-tj@kernel.org>
	<10133.1254402320@redhat.com>
Reply-To: blp@cs.stanford.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 209.172.104.10
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
Cancel-Lock: sha1:7Xo32QqRozaTj78NNpWFAI0TwKY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> writes:

> Tejun Heo <tj@kernel.org> wrote:
>
>> +enum {
>> +	WORK_STRUCT_PENDING	= 0,	/* work item is pending execution */
>> +
>> +	/*
>> +	 * Reserve 3bits off of cwq pointer.  This is enough and
>> +	 * provides acceptable alignment on both 32 and 64bit
>> +	 * machines.
>> +	 */
>> +	WORK_STRUCT_FLAG_BITS	= 3,
>> +
>> +	WORK_STRUCT_FLAG_MASK	= (1UL << WORK_STRUCT_FLAG_BITS) - 1,
>> +	WORK_STRUCT_WQ_DATA_MASK = ~WORK_STRUCT_FLAG_MASK,
>> +};
>
> There's some great enum abuse going on here:-)

The "1UL" part is a bit worrisome.  Enumeration constants always
have type "int"[*], so if code that uses WORK_STRUCT_WQ_DATA_MASK
actually depends on getting a full "long" worth of bits, it is
not going to work on 64-bit systems.

[*] See C99:

     6.4.4.3 Enumeration constants
     Syntax
1              enumeration-constant:
                      identifier
     Semantics
2    An identifier declared as an enumeration constant has type int.

-- 
Ben Pfaff 
http://benpfaff.org

