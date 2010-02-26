Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759520Ab0BZXYg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 18:24:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40716 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753672Ab0BZXYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 18:24:35 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100226205300.GA26171@redhat.com>
References: <20100226205300.GA26171@redhat.com> <20100226200357.GB16092@redhat.com> <20100226182325.GA31674@redhat.com> <20100225181500.GA18008@redhat.com> <16951.1267207238@redhat.com> <17603.1267209668@redhat.com> <20100226200313.GA16092@redhat.com> <23363.1267216958@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Neil Horman <nhorman@tuxdriver.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 -mm 1/2] umh && creds: convert call_usermodehelper_keys() to use subprocess_info->init()
Date: Fri, 26 Feb 2010 23:24:09 +0000
Message-ID: <29907.1267226649@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm not going to be able to test it before I get back from skiing in a week's
time, but it looks ackable otherwise.

It can be tested by doing something like this:

	[root@andromeda ~]# keyctl request2 user debug:a b @s
	102880396
	[root@andromeda ~]# keyctl show
	Session Keyring
	       -3 --alswrv      0     0  keyring: _ses
	404996112 --alswrv      0    -1   \_ keyring: _uid.0
	102880396 --alswrv      0     0   \_ user: debug:a
	[root@andromeda ~]# keyctl print 102880396
	Debug b

On a system with the keyutils package installed.

David
