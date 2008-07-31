Return-Path: <linux-kernel-owner+w=401wt.eu-S1758078AbYGaVgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078AbYGaVgc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 17:36:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754376AbYGaVgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 17:36:24 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:65382 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238AbYGaVgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 17:36:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=LESwd0A4rTkjW60Wc7QpcwEZTeGC8uuRL4a31cMTNfDzKcRRbbp0MrekMePglU+Jvv
         beRZXynR033OvAHYpKewXoGEKSg5FN2yI7bSdLUnzIFSHMxsy4gVQ70/wHpwpx0D1gTO
         TZpBVSAUJglapxjdxanl6sYk2D/iN0wgH+jmU=
Message-ID: <2c0942db0807311436p6c61d2f0o9bfe67ffeaaf0e91@mail.gmail.com>
Date: Thu, 31 Jul 2008 14:36:21 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Willy Tarreau" <w@1wt.eu>
Subject: Re: iptables, NAT, DNS & Dan Kaminsky
Cc: "Richard Hartmann" <richih.mailinglist@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080731211406.GA19104@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2d460de70807300753w33c43340xaa52c54add501306@mail.gmail.com>
	 <20080730195548.GA615@1wt.eu>
	 <2d460de70807310759s2a7d6c4k5ba7e0e6a5bd9cf6@mail.gmail.com>
	 <20080731211406.GA19104@1wt.eu>
X-Google-Sender-Auth: 69cbde2038ac8c8c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2008 at 2:14 PM, Willy Tarreau <w@1wt.eu> wrote:
>> > And BTW I don't think that many of the people
>> > reading LKML care a dime about the "exploit" for poorly configured
>> > DNS servers.
>>
>> It is an exploit that is being abused as we speak and,
>
> That does not mean that abused servers were properly set up.

Properly configured servers are vulnerable, that's why this is such a
big deal. This a problem with the design of the DNS protocol (&
associated behaviors) itself -- the only mitigation strategy sysadmins
have right now is forcing a randomization of the source port (outside
of the DNS resolver itself), or placing the DNS resolver behind a NAT
masquerading firewall that does strict response dropping if a response
comes from the wrong host. (There used to be an option in the kernel
to deal with that -- loose source routing or somesuch, but I think
that's a by-gone from the 2.4 era.)

So, to answer Richard, yes something like that should work. I'm not an
iptables guru by any means, but what you should do is set up a machine
with that, and sniff the output of the DNS server before and after
enabling that line to verify that it works.

The better solution, of course, is to update your DNS server to allow
it to do the source port randomization itself.
