Return-Path: <linux-kernel-owner+w=401wt.eu-S1753860AbYLBV0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860AbYLBV0j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 16:26:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751679AbYLBV0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 16:26:30 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:45892 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbYLBV02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 16:26:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=uM7gqWNLdF/DFVbPuPAjnxnb4S+jxOd155CRxthv+TxsgXOvl8/yz2FVWziM4tH2PQ
         YwHwxLul4dxHQVJgkK1LtJGBIBdU4hjUeQqPyHJ+3gQjpWbeqw9Gpgi8lRYigWrhAx7e
         ofzdP9yDgF4a9SKBQCKeBqZUlj0O6BX2w4Fjk=
Message-ID: <524f69650812021326w26ccceb3qb8d93283aca84558@mail.gmail.com>
Date: Tue, 2 Dec 2008 15:26:26 -0600
From: "Steve French" <smfrench@gmail.com>
To: "jim owens" <jowens@hp.com>
Subject: Re: Support for applications which need NFS or CIFS "share_deny" flags on open
Cc: "Jamie Lokier" <jamie@shareable.org>, "Andreas Dilger" <adilger@sun.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-cifs-client@lists.samba.org" 
	<linux-cifs-client@lists.samba.org>
In-Reply-To: <4935A692.3050300@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <524f69650812020831q4e089b87k9a8306ac37f4234a@mail.gmail.com>
	 <20081202193819.GJ3186@webber.adilger.int>
	 <20081202200621.GA4451@shareable.org>
	 <524f69650812021220n2b7611b9x2eb3b0b6c7ece849@mail.gmail.com>
	 <4935A692.3050300@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 2, 2008 at 3:20 PM, jim owens <jowens@hp.com> wrote:
> Steve French wrote:
>>
>> On Tue, Dec 2, 2008 at 2:06 PM, Jamie Lokier <jamie@shareable.org> wrote:
>>>
>>> The bit I find interesting is that other CIFS clients are said to
>>> implement these flags.  If that means real unixes, maybe they've
>>> worked out a sensible way to handle them?
>>
>> I thought that MacOS uses these flags (not just Windows, and of course
>> older clients too OS/2, DOS etc.).
>
> The title of their proposal was "client"... as in not the local
> filesystem, but the impression of what wine really wanted is
> for local linux filesystems to implement these non-posix behaviors
> so "wine apps can run just like on windows" on the local machine.
>
> Thus the strong objection from everyone doing local filesystems.
>
> Passing exclusive DENYREAD DENYWRITE DENYDELETE network
> protocol flags from a linux client to a remote server
> is an entirely different and IMO acceptible thing.
>
> And AFAIK on unix the only local support would be by doing
> a client-on-server loopback, where the server implements
> these modes as best it can and you are only protected
> against wine apps that are also inside the "share drive".

Yes, I think that this is more important for network file systems not
local file systems (especially since NFSv4 and CIFS and SMB2 all
support these flags in the protocol definition).  Since wine (or any
subsystem running on a single local linux system) can handle its own
locks between application instances, the main problem is that byte
range locks can't perfectly emulate the application semantics needed
when applications are running on two different "clients" (in this
case, one Wine/Linux, and one a Windows client) but mounted to the
same server


-- 
Thanks,

Steve
