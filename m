Return-Path: <linux-kernel-owner+w=401wt.eu-S1755575AbXD0K0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbXD0K0c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 06:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755573AbXD0K0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 06:26:32 -0400
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:27778 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755570AbXD0K0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 06:26:31 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=v41NE5B+MO/PiZhAzHD2kseRqXuILrjOJMgRC8L9GRKs3h9+4wFpi/Q3GARlLIdtOBERNu/dQ2avNalAHsTAC4m2EceRiiKSOVNu+pgbS4ZGNmyDv49xTFGIOCVyj1RnPE0lSmD8qILzNJ6ujCklSHzNEVZSaFWAgS4GptnSxTk=  ;
X-YMail-OSG: pVKa9dYVM1no_zYAiuNEOFM1H5ocdZN.xK0Q1IKIYwHJwzMHgPAQmkvVCz8ZYNBdjWKyUs48mw--
Message-ID: <4631CFCD.7020207@yahoo.com.au>
Date: Fri, 27 Apr 2007 20:26:21 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Jens Axboe <jens.axboe@oracle.com>, Christoph Lameter <clameter@sgi.com>,
       Christoph Hellwig <hch@infradead.org>, David Chinner <dgc@sgi.com>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
References: <m1mz0vkoux.fsf@ebiederm.dsl.xmission.com>	<Pine.LNX.4.64.0704261059500.3263@schroedinger.engr.sgi.com>	<20070426180358.GG2017@kernel.dk>	<20070426180932.GA10642@infradead.org>	<20070426181249.GH2017@kernel.dk>	<Pine.LNX.4.64.0704261127550.3560@schroedinger.engr.sgi.com>	<20070426182945.GJ2017@kernel.dk>	<Pine.LNX.4.64.0704261134080.3656@schroedinger.engr.sgi.com>	<20070426183935.GK2017@kernel.dk>	<m1irbjj5ej.fsf@ebiederm.dsl.xmission.com>	<20070426194234.GL2017@kernel.dk> <m1ejm6jwbs.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1ejm6jwbs.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Jens Axboe <jens.axboe@oracle.com> writes:

>>Yes, that is exactly the problem. Once you have that, pktcdvd is pretty
>>much reduced to setup and init code, the actual data handling can be
>>done by sr or ide-cd directly. You could merge it into cdrom.c, it would
>>not be very different from mt-rainier handling (which basically does RMW
>>in firmware, so it works for any write, but performance is of course
>>horrible if you don't do it right).
> 
> 
> Thanks for the clarification.
> 
> So we do have a clear problem that we do not have generic support for
> large sector sizes residing in the page cache.

Well, it is a clear limitation. It hasn't mattered too much until
now, but it is one of the other issues that SGI hit (aside from
io efficiency) because they have 16K filesystems created on ia64
systems that I believe they want to access with x86-64 systems.

I'm slowly looking at patches in the background, but I'm hoping to
be able to spend a decent chunk of time working on them again soon.

It isn't trivial :)

-- 
SUSE Labs, Novell Inc.
