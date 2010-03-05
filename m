Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844Ab0CEWyk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 17:54:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48172 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755319Ab0CEWyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 17:54:39 -0500
Date: Fri, 5 Mar 2010 23:52:43 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Neil Horman <nhorman@tuxdriver.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 -mm 1/2] umh && creds: convert
	call_usermodehelper_keys() to use subprocess_info->init()
Message-ID: <20100305225243.GA21790@redhat.com>
References: <20100226205300.GA26171@redhat.com> <20100226200357.GB16092@redhat.com> <20100226182325.GA31674@redhat.com> <20100225181500.GA18008@redhat.com> <16951.1267207238@redhat.com> <17603.1267209668@redhat.com> <20100226200313.GA16092@redhat.com> <23363.1267216958@redhat.com> <29907.1267226649@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29907.1267226649@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26, David Howells wrote:
>
> I'm not going to be able to test it before I get back from skiing in a week's
> time, but it looks ackable otherwise.
>
> It can be tested by doing something like this:
>
> 	[root@andromeda ~]# keyctl request2 user debug:a b @s
> 	102880396
> 	[root@andromeda ~]# keyctl show
> 	Session Keyring
> 	       -3 --alswrv      0     0  keyring: _ses
> 	404996112 --alswrv      0    -1   \_ keyring: _uid.0
> 	102880396 --alswrv      0     0   \_ user: debug:a
> 	[root@andromeda ~]# keyctl print 102880396
> 	Debug b
>
> On a system with the keyutils package installed.

Thanks David.

Finally I reserved the machine for the testing,

	[root@hp-dl360-01 ~]# keyctl request2 user debug:a b @s
	623133085
	[root@hp-dl360-01 ~]# keyctl show
	Session Keyring
	       -3 --alswrv      0     0  keyring: _ses
	845914766 --alswrv      0    -1   \_ keyring: _uid.0
	623133085 --alswrv      0     0   \_ user: debug:a
	[root@hp-dl360-01 ~]# keyctl print 623133085
	Debug b

Hopefully this all is right.

Oleg.

