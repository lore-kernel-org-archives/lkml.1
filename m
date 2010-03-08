Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab0CHNT7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 08:19:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15797 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497Ab0CHNT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 08:19:56 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100305230957.GA22614@redhat.com>
References: <20100305230957.GA22614@redhat.com> <20100226205300.GA26171@redhat.com> <20100226200357.GB16092@redhat.com> <20100226182325.GA31674@redhat.com> <20100225181500.GA18008@redhat.com> <16951.1267207238@redhat.com> <17603.1267209668@redhat.com> <20100226200313.GA16092@redhat.com> <23363.1267216958@redhat.com> <29907.1267226649@redhat.com> <20100305225243.GA21790@redhat.com> 
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Neil Horman <nhorman@tuxdriver.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH,RESEND -mm 1/2] umh && creds: convert call_usermodehelper_keys() to use subprocess_info->init()
Date: Mon, 08 Mar 2010 13:19:28 +0000
Message-ID: <19925.1268054368@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> (on top of kmod-replace-call_usermodehelper_pipe-with-use-of-umh-init-function-and-resolve-limit.patch)
> 
> call_usermodehelper_keys() uses call_usermodehelper_setkeys() to change
> subprocess_info->cred in advance. Now that we have info->init() we can
> change this code to set tgcred->session_keyring in context of execing
> kernel thread.
> 
> Note: since currently call_usermodehelper_keys() is never called with
> UMH_NO_WAIT, call_usermodehelper_keys()->key_get() and umh_keys_cleanup()
> are not really needed, we could rely on install_session_keyring_to_cred()
> which does key_get() on success.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Acked-by: Neil Horman <nhorman@tuxdriver.com>

Acked-by: David Howells <dhowells@redhat.com>
