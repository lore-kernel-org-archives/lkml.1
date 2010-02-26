Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965710Ab0BZSl3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 13:41:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65328 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965692Ab0BZSl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 13:41:28 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100226182325.GA31674@redhat.com>
References: <20100226182325.GA31674@redhat.com> <20100225181500.GA18008@redhat.com> <16951.1267207238@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Neil Horman <nhorman@tuxdriver.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/2] umh && creds: convert call_usermodehelper_keys() to use subprocess_info->init()
Date: Fri, 26 Feb 2010 18:41:08 +0000
Message-ID: <17603.1267209668@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> How? Without CLONE_THREAD copy_creds() always creates the new
> struct cred for the child?

Okay, that's a good point.

In which case, you should be calling install_session_keyring_to_cred(), just
so that the credentials installation is always done by the same piece of code.

David
