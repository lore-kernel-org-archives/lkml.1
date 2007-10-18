Return-Path: <linux-kernel-owner+w=401wt.eu-S1765303AbXJRFLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765303AbXJRFLe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 01:11:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762287AbXJRFLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 01:11:20 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:42569 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755450AbXJRFLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 01:11:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=FLnGA84uCeEMRlnRXPeGUh+YUG1V3gEks/M++2yW1Va41OJuWvX335bu15bMi6iAl6nIBQ5nowp543yYQo1B908tFudh6G7KrbWpp5Uhgs5y68HB0RmxK2wQniIn9qU5QrrzgCEcbCVVzzBEUwXDYdd+Ioa5ao+BSwnqzDP7/8E=  ;
X-YMail-OSG: Iq6WsdcVM1lW81gTJEMG.uIiVIIeXKcEitONRnQqvkX8p1du.PPzxxqP3LOG1SIXXKL93qj2tQ--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [RFC][PATCH] block: Isolate the buffer cache in it's own mappings.
Date: Thu, 18 Oct 2007 15:10:48 +1000
User-Agent: KMail/1.9.5
Cc: Chris Mason <chris.mason@oracle.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>, stable@kernel.org
References: <200710151028.34407.borntraeger@de.ibm.com> <1192665785.15717.34.camel@think.oraclecorp.com> <m1tzopaxa1.fsf_-_@ebiederm.dsl.xmission.com>
In-Reply-To: <m1tzopaxa1.fsf_-_@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710181510.48382.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 October 2007 13:59, Eric W. Biederman wrote:
> If filesystems care at all they want absolute control over the buffer
> cache.  Controlling which buffers are dirty and when.  Because we
> keep the buffer cache in the page cache for the block device we have
> not quite been giving filesystems that control leading to really weird
> bugs.

Mmm. Like I said, when a live filesystem is mounted on a bdev,
it isn't like you want userspace to go dancing around on it without
knowing exactly what it is doing.

The kernel more or less does the right thing here with respect to
the *state* of the data[*] (that is, buffer heads and pagecache).
It's when you actually start changing the data itself around is when
you'll blow up the filesystem.

[*] The ramdisk code is simply buggy, right? (and not the buffer
    cache)

The idea of your patch in theory is OK, but Andrew raises valid
points about potential coherency problems, I think.

