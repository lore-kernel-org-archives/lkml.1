Return-Path: <linux-kernel-owner+w=401wt.eu-S935653AbYEUOrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935653AbYEUOrp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 10:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756808AbYEUOrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 10:47:11 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:44045 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756077AbYEUOrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 10:47:10 -0400
Message-ID: <48343620.2020306@us.ibm.com>
Date: Wed, 21 May 2008 09:48:00 -0500
From: "Steve French (smfltc)" <smfltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: "Frank Ch. Eigler" <fche@redhat.com>, Adrian Bunk <bunk@kernel.org>,
       linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@sunset.davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-cifs-client@lists.samba.org
Subject: Re: Re: [2.6 patch] unexport uts_sem
References: <20080505182937.GZ17139@cs181133002.pp.htv.fi>	<y0mwsloq4kc.fsf@ton.toronto.redhat.com>	<20080520172730.GA2361@infradead.org>	<20080520183802.GA686@redhat.com> <20080521123700.GA8770@infradead.org>
In-Reply-To: <20080521123700.GA8770@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Tue, May 20, 2008 at 02:38:02PM -0400, Frank Ch. Eigler wrote:
>   
>> Sorry, I misspoke - this check is intended not to cross-check
>> kernel-devel and the kernel itself, but the debuginfo or similar data
>> that is given to describe target of a systemtap script.  I guess for
>> new enough kernels we'll just do that using buildid hash codes.
>>
>> By the way, there do appear to be a few suspect in-tree users of
>> utsname() without uts_sem locking 
>
>   
>> cifs/connect.c,
>>     
>
> This one is quite fishy. Not sure what it needs the name for but the
> kernel utsname is probably a bad choise.  And yes, this one actually
> is racy because the host name can change.
>   

CIFS in fs/cifs/sess.c uses utsname()->version because the cifs protocol 
requires that the server and client report their native operating system 
version during session setup (not just their "network operating system" 
or network file system version).   The other uses of utsname()->version 
in connect.c will be removed (they are used in an older implementation 
of session_setup which is disabled by default).

CIFS in fs/cifs/connect.c uses utsname()->nodename to get the default 
hostname during mount.   For RFC1001 connections and for NTLMSSP, if no 
RFC1001 name for the client is supplied on the mount, the TCP host name 
must be used to identify the client in those packets.

